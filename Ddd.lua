-- discord.gg/syncrypt

local function geniter(f, s, c)
	if type(f) ~= "function" then
		local mt = getmetatable(f)

		if type(mt) == "table" and mt.__iter then
			f, s, c = mt.__iter(f)
		elseif type(f) == "table" then
			f, s, c = next, f, nil
		end
	end

	return function()
		local r = table.pack(f(s, c))

		if r[1] == nil then
			return false
		end

		c = r[1]

		return true, table.unpack(r, 1, r.n)
	end
end

ply = game.Players
plr = ply.LocalPlayer
Root = plr.Character.HumanoidRootPart
replicated = game:GetService("ReplicatedStorage")
Lv = game.Players.LocalPlayer.Data.Level.Value
TeleportService = game:GetService("TeleportService")
TW = game:GetService("TweenService")
Lighting = game:GetService("Lighting")
Enemies = workspace.Enemies
vim1 = game:GetService("VirtualInputManager")
vim2 = game:GetService("VirtualUser")
TeamSelf = plr.Team
RunSer = game:GetService("RunService")
Stats = game:GetService("Stats")
Energy = plr.Character.Energy.Value
BringConnections = {}
BossList = {}
MaterialList = {}
NPCList = {}
shouldTween = false
getgenv().OnFarm = false
getgenv().AutoMaterial = false
NextIs = false
senth = false
senth2 = false
SoulGuitar = false
KenTest = true
debug = false
Brazier1 = false
Brazier2 = false
Brazier3 = false
Sec = 0.1
ClickState = 0
Num_self = 25

local Loading

repeat
	Loading = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Loading") and game:IsLoaded()
	wait()
until Loading

World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
Marines = function()
	replicated.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
end
Pirates = function()
	replicated.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
end

if World1 then
	BossList = {
		"The Gorilla King",
		"Bobby",
		"The Saw",
		"Yeti",
		"Mob Leader",
		"Vice Admiral",
		"Saber Expert",
		"Warden",
		"Chief Warden",
		"Swan",
		"Magma Admiral",
		"Fishman Lord",
		"Wysper",
		"Thunder God",
		"Cyborg",
		"Ice Admiral",
		"Greybeard"
	}
elseif World2 then
	BossList = {
		"Diamond",
		"Jeremy",
		"Orbitus",
		"Don Swan",
		"Smoke Admiral",
		"Awakened Ice Admiral",
		"Tide Keeper",
		"Darkbeard",
		"Cursed Captain",
		"Order"
	}
elseif World3 then
	BossList = {
		"Stone",
		"Hydra Leader",
		"Kilo Admiral",
		"Captain Elephant",
		"Beautiful Pirate",
		"Cake Queen",
		"Dough King",
		"Longma",
		"Soul Reaper",
		"rip_indra True Form",
		"Tyrant of the Skies"
	}
end

if World1 then
	MaterialList = {
		"Leather + Scrap Metal",
		"Angel Wings",
		"Magma Ore",
		"Fish Tail"
	}
elseif World2 then
	MaterialList = {
		"Leather + Scrap Metal",
		"Radioactive Material",
		"Ectoplasm",
		"Mystic Droplet",
		"Magma Ore",
		"Vampire Fang"
	}
elseif World3 then
	MaterialList = {
		"Scrap Metal",
		"Demonic Wisp",
		"Conjured Cocoa",
		"Dragon Scale",
		"Gunpowder",
		"Fish Tail",
		"Mini Tusk"
	}
end

local t1 = {
	"Snow Lurker",
	"Arctic Warrior",
	"Hidden Key",
	"Awakened Ice Admiral"
}
local t2 = {
	"Part",
	"SpawnLocation",
	"Terrain",
	"WedgePart",
	"MeshPart"
}
local t3 = {
	"Swan Pirate",
	"Jeremy"
}
local t4 = {
	"Fajita",
	"Jeremy",
	"Diamond"
}
local t5 = { "Cookie Crafter" }
local t6 = { "Reborn Skeleton" }
local t7 = {
	["Pirate Millionaire"] = CFrame.new(-712.8272705078125, 98.577049255371094, 5711.9541015625),
	["Pistol Billionaire"] = CFrame.new(-723.43316650390625, 147.42906188964844, 5931.9931640625),
	["Dragon Crew Warrior"] = CFrame.new(7021.50439453125, 55.762702941894531, -730.12908935546875),
	["Dragon Crew Archer"] = CFrame.new(6625, 378, 244),
	["Female Islander"] = CFrame.new(4692.7939453125, 797.9766845703125, 858.8480224609375),
	["Venomous Assailant"] = CFrame.new(4902, 670, 39),
	["Marine Commodore"] = CFrame.new(2401, 123, -7589),
	["Marine Rear Admiral"] = CFrame.new(3588, 229, -7085),
	["Fishman Raider"] = CFrame.new(-10941, 332, -8760),
	["Fishman Captain"] = CFrame.new(-11035, 332, -9087),
	["Forest Pirate"] = CFrame.new(-13446, 413, -7760),
	["Mythological Pirate"] = CFrame.new(-13510, 584, -6987),
	["Jungle Pirate"] = CFrame.new(-11778, 426, -10592),
	["Musketeer Pirate"] = CFrame.new(-13282, 496, -9565),
	["Reborn Skeleton"] = CFrame.new(-8764, 142, 5963),
	["Living Zombie"] = CFrame.new(-10227, 421, 6161),
	["Demonic Soul"] = CFrame.new(-9579, 6, 6194),
	["Posessed Mummy"] = CFrame.new(-9579, 6, 6194),
	["Peanut Scout"] = CFrame.new(-1993, 187, -10103),
	["Peanut President"] = CFrame.new(-2215, 159, -10474),
	["Ice Cream Chef"] = CFrame.new(-877, 118, -11032),
	["Ice Cream Commander"] = CFrame.new(-877, 118, -11032),
	["Cookie Crafter"] = CFrame.new(-2021, 38, -12028),
	["Cake Guard"] = CFrame.new(-2024, 38, -12026),
	["Baking Staff"] = CFrame.new(-1932, 38, -12848),
	["Head Baker"] = CFrame.new(-1932, 38, -12848),
	["Cocoa Warrior"] = CFrame.new(95, 73, -12309),
	["Chocolate Bar Battler"] = CFrame.new(647, 42, -12401),
	["Sweet Thief"] = CFrame.new(116, 36, -12478),
	["Candy Rebel"] = CFrame.new(47, 61, -12889),
	Ghost = CFrame.new(5251, 5, 1111)
}
local t8 = {
	RFJobsRemoteFunction = replicated.Modules.Net["RF/JobsRemoteFunction"],
	RFCraft = replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft")
}

do
	EquipWeapon = function(p1)
		if not p1 then
			return
		end

		if plr.Backpack:FindFirstChild(p1) then
			plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild(p1))
		end
	end
end

do
	weaponSc = function(p2)
		for _, child in pairs(plr.Backpack:GetChildren()) do
			if child:IsA("Tool") and child.ToolTip == p2 then
				EquipWeapon(child.Name)
			end
		end
	end
end

local t9 = {}

t9.__index = t9
t9.Alive = function(p3)
	if not p3 then
		return
	end

	local Humanoid = p3:FindFirstChild("Humanoid")

	return Humanoid and Humanoid.Health > 0
end
t9.Pos = function(p4, p5)
	return (Root.Position - mode.Position).Magnitude <= p5
end
t9.Dist = function(p6, p7)
	return (Root.Position - p6:FindFirstChild("HumanoidRootPart").Position).Magnitude <= p7
end
t9.DistH = function(p8, p9)
	return (Root.Position - p8:FindFirstChild("HumanoidRootPart").Position).Magnitude > p9
end

do
	t9.Kill = function(p10, p11)
		if p10 and p11 then
			if not p10:GetAttribute("Locked") then
				p10:SetAttribute("Locked", p10.HumanoidRootPart.CFrame)
			end

			PosMon = p10:GetAttribute("Locked").Position
			BringEnemy()
			EquipWeapon(_G.SelectWeapon)

			local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")

			if (Tool and Tool:FindFirstChild("ToolTip") and Tool.ToolTip or "") == "Blox Fruit" then
				_tp(p10.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0) * CFrame.Angles(0, math.rad(90), 0))
			else
				_tp(p10.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(0, math.rad(180), 0))
			end

			if RandomCFrame then
				wait(0.5)
				_tp(p10.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
				wait(0.5)
				_tp(p10.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
				wait(0.5)
				_tp(p10.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
				wait(0.5)
				_tp(p10.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
				wait(0.5)
				_tp(p10.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
			end
		end
	end
end

t9.Kill2 = function(p12, p13)
	if p12 and p13 then
		if not p12:GetAttribute("Locked") then
			p12:SetAttribute("Locked", p12.HumanoidRootPart.CFrame)
		end

		PosMon = p12:GetAttribute("Locked").Position
		BringEnemy()
		EquipWeapon(_G.SelectWeapon)

		local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		local ToolTip = Tool and Tool:FindFirstChild("ToolTip") and Tool.ToolTip

		if (ToolTip or "") == "Blox Fruit" then
			_tp(p12.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0) * CFrame.Angles(0, math.rad(90), 0))
		else
			_tp(p12.HumanoidRootPart.CFrame * CFrame.new(0, 10, 8) * CFrame.Angles(0, math.rad(180), 0))
		end

		if RandomCFrame then
			wait(0.1)
			_tp(p12.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
			wait(0.1)
			_tp(p12.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
			wait(0.1)
			_tp(p12.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
			wait(0.1)
			_tp(p12.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
			wait(0.1)
			_tp(p12.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
		end
	end
end
t9.KillSea = function(p14, p15)
	if p14 and p15 then
		if not p14:GetAttribute("Locked") then
			p14:SetAttribute("Locked", p14.HumanoidRootPart.CFrame)
		end

		PosMon = p14:GetAttribute("Locked").Position
		BringEnemy()
		EquipWeapon(_G.SelectWeapon)

		local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")

		if (Tool and Tool:FindFirstChild("ToolTip") and Tool.ToolTip or "") == "Blox Fruit" then
			_tp(p14.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0) * CFrame.Angles(0, math.rad(90), 0))
		else
			notween(p14.HumanoidRootPart.CFrame * CFrame.new(0, 50, 8))
			wait(0.85)
			notween(p14.HumanoidRootPart.CFrame * CFrame.new(0, 400, 0))
			wait(1)
		end
	end
end

do
	t9.Sword = function(p16, p17)
		if p16 and p17 then
			if not p16:GetAttribute("Locked") then
				p16:SetAttribute("Locked", p16.HumanoidRootPart.CFrame)
			end

			PosMon = p16:GetAttribute("Locked").Position
			BringEnemy()
			weaponSc("Sword")
			_tp(p16.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))

			if RandomCFrame then
				wait(0.1)
				_tp(p16.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
				wait(0.1)
				_tp(p16.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
				wait(0.1)
				_tp(p16.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
				wait(0.1)
				_tp(p16.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
				wait(0.1)
				_tp(p16.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
			end
		end
	end
end

t9.Mas = function(p18, p19)
	if p18 then
		if p19 then
			if not p18:GetAttribute("Locked") then
				p18:SetAttribute("Locked", p18.HumanoidRootPart.CFrame)
			end

			PosMon = p18:GetAttribute("Locked").Position
			BringEnemy()

			if p18.Humanoid.Health <= HealthM then
				_tp(p18.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))

				local SelectedMasterySkills = _G.SelectedMasterySkills

				if type(SelectedMasterySkills) ~= "table" then
					SelectedMasterySkills = {
						"Z",
						"X",
						"C",
						"V",
						"F"
					}
				end

				for k, SelectedMasterySkill in pairs(SelectedMasterySkills) do
					if type(k) == "number" then
						Useskills("Blox Fruit", SelectedMasterySkill)
					elseif type(k) == "string" and SelectedMasterySkill == true then
						Useskills("Blox Fruit", k)
					end
				end
			else
				weaponSc("Melee")
				_tp(p18.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
			end
		end
	end
end
t9.Masgun = function(p20, p21)
	if p20 and p21 then
		if not p20:GetAttribute("Locked") then
			p20:SetAttribute("Locked", p20.HumanoidRootPart.CFrame)
		end

		PosMon = p20:GetAttribute("Locked").Position
		BringEnemy()

		if p20.Humanoid.Health <= HealthM then
			_tp(p20.HumanoidRootPart.CFrame * CFrame.new(0, 35, 8))

			local SelectedMasterySkills = _G.SelectedMasterySkills

			if type(SelectedMasterySkills) ~= "table" then
				SelectedMasterySkills = {
					"Z",
					"X",
					"C",
					"V",
					"F"
				}
			end

			for k, SelectedMasterySkill in pairs(SelectedMasterySkills) do
				if type(k) == "number" then
					Useskills("Gun", SelectedMasterySkill)
				elseif type(k) == "string" and SelectedMasterySkill == true then
					Useskills("Gun", k)
				end
			end
		else
			weaponSc("Melee")
			_tp(p20.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
		end
	end
end
statsSetings = function(p22, p23)
	if p22 == "Melee" then
		if plr.Data.Points.Value ~= 0 then
			replicated.Remotes.CommF_:InvokeServer("AddPoint", "Melee", p23)
		end
	else
		if p22 == "Defense" then
			if plr.Data.Points.Value == 0 then
				return
			end

			replicated.Remotes.CommF_:InvokeServer("AddPoint", "Defense", p23)

			return
		end

		if p22 == "Sword" then
			if plr.Data.Points.Value == 0 then
				return
			end

			replicated.Remotes.CommF_:InvokeServer("AddPoint", "Sword", p23)

			return
		end

		if p22 == "Gun" then
			if plr.Data.Points.Value == 0 then
				return
			end

			replicated.Remotes.CommF_:InvokeServer("AddPoint", "Gun", p23)

			return
		end

		if p22 ~= "Devil" or plr.Data.Points.Value == 0 then
			return
		end

		replicated.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", p23)

		return
	end
end

do
	BringEnemy = function(p24)
		if not _B then
			return
		end

		if not p24 then
			local HumanoidRootPart = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return
			end

			local huge = math.huge

			for _, child in ipairs(workspace.Enemies:GetChildren()) do
				local Humanoid = child:FindFirstChildOfClass("Humanoid")
				local HumanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")

				if Humanoid and HumanoidRootPart2 and Humanoid.Health > 0 then
					local Magnitude = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude

					if Magnitude < huge then
						huge = Magnitude
						p24 = child
					end
				end
			end

			if not p24 then
				return
			end
		end

		local u34 = false

		local function v35(p25)
			local Humanoid = p25:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = p25:FindFirstChild("HumanoidRootPart")

			return Humanoid and HumanoidRootPart and Humanoid.Health > 0, HumanoidRootPart, Humanoid
		end
		local function v38(p26)
			if isnetworkowner then
				return isnetworkowner(p26)
			end

			return p26.ReceiveAge == 0 and not p26.Anchored and p26.Velocity.Magnitude > 0
		end

		pcall(function()
			if sethiddenproperty then
				sethiddenproperty(plr, "SimulationRadius", math.huge)
			end

			local Position = p24.HumanoidRootPart.Position
			local v40, v41, v42 = ipairs(workspace.Enemies:GetChildren())
			local v43 = geniter(v40, v41, v42)
			local exitTo
			local v45

			while true do
				local v46 = table.pack(v43())

				if v46[1] then
					v45 = v46[3]

					if v45 ~= p24 then
						exitTo = 1

						break
					end
				else
					break
				end
			end

			if exitTo == 1 then
				local exitTo2

				repeat
					local v48, v49, v50 = v35(v45)

					if v48 and v45.Name == p24.Name then
						local Magnitude = (v49.Position - Position).Magnitude

						if Magnitude <= 3000 then
							if not v49:FindFirstChild("BodyVelocity") then
								local BodyVelocity = Instance.new("BodyVelocity")

								BodyVelocity.Name = "BodyVelocity"
								BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
								BodyVelocity.Velocity = Vector3.zero
								BodyVelocity.Parent = v49
							end

							if Magnitude <= 10 then
								u34 = true
							end

							if not u34 and v38(v49) then
								v49.CFrame = CFrame.new(Position)
							end

							v49.CanCollide = false
							v50.WalkSpeed = 0
							v50.JumpPower = 0
						end
					end

					exitTo2 = nil

					while true do
						local v53 = table.pack(v43())

						if v53[1] then
							v45 = v53[3]

							if v45 ~= p24 then
								exitTo2 = 1

								break
							end
						else
							break
						end
					end
				until exitTo2 ~= 1

				if p24 and p24:FindFirstChild("HumanoidRootPart") then
					p24.HumanoidRootPart.CanCollide = false
					p24.Humanoid.WalkSpeed = 0
					p24.Humanoid.JumpPower = 0
				end
			elseif p24 and p24:FindFirstChild("HumanoidRootPart") then
				p24.HumanoidRootPart.CanCollide = false
				p24.Humanoid.WalkSpeed = 0
				p24.Humanoid.JumpPower = 0

				return
			end
		end)
	end
end

local function v54(p27, p28)
	local LocalPlayer = game.Players.LocalPlayer
	local Name
	local v57, v58, v59 = pairs(LocalPlayer.Character:GetChildren())
	local v60 = geniter(v57, v58, v59)

	while true do
		local v61 = table.pack(v60())

		if v61[1] then
			local v62 = v61[3]

			if v62:IsA("Tool") and v62.ToolTip == p27 then
				Name = v62.Name

				break
			end
		else
			break
		end
	end

	if not Name then
		local v63, v64, v65 = pairs(LocalPlayer.Backpack:GetChildren())

		for _, v1 in v63, v64, v65 do
			if v1:IsA("Tool") and v1.ToolTip == p27 then
				Name = v1.Name

				break
			end
		end
	end

	if Name then
		if LocalPlayer.PlayerGui:FindFirstChild("Main") then
			if LocalPlayer.PlayerGui.Main:FindFirstChild("Skills") then
				local v68 = LocalPlayer.PlayerGui.Main.Skills:FindFirstChild(Name)

				if v68 then
					local v69 = v68:FindFirstChild(p28)

					if not v69 then
						return false
					end

					local Title = v69:FindFirstChild("Title")

					if Title then
						if Title:IsA("TextLabel") and Title.TextColor3.R < 0.5 then
							return false
						end
					end

					local Cooldown = v69:FindFirstChild("Cooldown")

					if Cooldown and (Cooldown.Size.X.Scale > 0 or Cooldown.AbsoluteSize.X > 0) then
						return false
					end

					return true
				end
			end
		end
	end

	return true
end

Useskills = function(p29, p30)
	if p29 == "Melee" then
		weaponSc("Melee")

		if not v54(p29, p30) then
			return
		end

		if p30 == "Z" then
			vim1:SendKeyEvent(true, "Z", false, game)
			vim1:SendKeyEvent(false, "Z", false, game)
		elseif p30 == "X" then
			vim1:SendKeyEvent(true, "X", false, game)
			vim1:SendKeyEvent(false, "X", false, game)
		elseif p30 == "C" then
			vim1:SendKeyEvent(true, "C", false, game)
			vim1:SendKeyEvent(false, "C", false, game)
		elseif p30 == "V" then
			vim1:SendKeyEvent(true, "V", false, game)
			vim1:SendKeyEvent(false, "V", false, game)
		elseif p30 == "F" then
			vim1:SendKeyEvent(true, "F", false, game)
			vim1:SendKeyEvent(false, "F", false, game)
		elseif p30 == "Y" then
			vim1:SendKeyEvent(true, "Y", false, game)
			vim1:SendKeyEvent(false, "Y", false, game)
		end
	elseif p29 == "Sword" then
		weaponSc("Sword")

		if not v54(p29, p30) then
			return
		end

		if p30 == "Z" then
			vim1:SendKeyEvent(true, "Z", false, game)
			vim1:SendKeyEvent(false, "Z", false, game)
		elseif p30 == "X" then
			vim1:SendKeyEvent(true, "X", false, game)
			vim1:SendKeyEvent(false, "X", false, game)
		elseif p30 == "C" then
			vim1:SendKeyEvent(true, "C", false, game)
			vim1:SendKeyEvent(false, "C", false, game)
		elseif p30 == "V" then
			vim1:SendKeyEvent(true, "V", false, game)
			vim1:SendKeyEvent(false, "V", false, game)
		elseif p30 == "F" then
			vim1:SendKeyEvent(true, "F", false, game)
			vim1:SendKeyEvent(false, "F", false, game)
		elseif p30 == "Y" then
			vim1:SendKeyEvent(true, "Y", false, game)
			vim1:SendKeyEvent(false, "Y", false, game)
		end
	elseif p29 == "Blox Fruit" then
		weaponSc("Blox Fruit")

		if not v54(p29, p30) then
			return
		end

		if p30 == "Z" then
			vim1:SendKeyEvent(true, "Z", false, game)
			vim1:SendKeyEvent(false, "Z", false, game)
		elseif p30 == "X" then
			vim1:SendKeyEvent(true, "X", false, game)
			vim1:SendKeyEvent(false, "X", false, game)
		elseif p30 == "C" then
			vim1:SendKeyEvent(true, "C", false, game)
			vim1:SendKeyEvent(false, "C", false, game)
		elseif p30 == "V" then
			vim1:SendKeyEvent(true, "V", false, game)
			vim1:SendKeyEvent(false, "V", false, game)
		elseif p30 == "F" then
			vim1:SendKeyEvent(true, "F", false, game)
			vim1:SendKeyEvent(false, "F", false, game)
		elseif p30 == "Y" then
			vim1:SendKeyEvent(true, "Y", false, game)
			vim1:SendKeyEvent(false, "Y", false, game)
		end
	elseif p29 == "Gun" then
		weaponSc("Gun")

		if not v54(p29, p30) then
			return
		end

		if p30 == "Z" then
			vim1:SendKeyEvent(true, "Z", false, game)
			vim1:SendKeyEvent(false, "Z", false, game)
		elseif p30 == "X" then
			vim1:SendKeyEvent(true, "X", false, game)
			vim1:SendKeyEvent(false, "X", false, game)
		elseif p30 == "C" then
			vim1:SendKeyEvent(true, "C", false, game)
			vim1:SendKeyEvent(false, "C", false, game)
		elseif p30 == "V" then
			vim1:SendKeyEvent(true, "V", false, game)
			vim1:SendKeyEvent(false, "V", false, game)
		elseif p30 == "F" then
			vim1:SendKeyEvent(true, "F", false, game)
			vim1:SendKeyEvent(false, "F", false, game)
		elseif p30 == "Y" then
			vim1:SendKeyEvent(true, "Y", false, game)
			vim1:SendKeyEvent(false, "Y", false, game)
		end
	end

	if p29 == "nil" and p30 == "Y" then
		vim1:SendKeyEvent(true, "Y", false, game)
		vim1:SendKeyEvent(false, "Y", false, game)
	end
end

do
	local v72 = getrawmetatable(game)
	local __namecall = v72.__namecall

	setreadonly(v72, false)
	v72.__namecall = newcclosure(function(...)
		local v74 = getnamecallmethod()
		local t10 = { ... }

		if tostring(v74) == "FireServer" and tostring(t10[1]) == "RemoteEvent" and tostring(t10[2]) ~= "true" and tostring(t10[2]) ~= "false" and (_G.FarmMastery_G and not SoulGuitar or _G.FarmMastery_Dev or _G.FarmBlazeEM or _G.Prehis_Skills or _G.SeaBeast1 or _G.FishBoat or _G.PGB or _G.Leviathan1 or _G.Complete_Trials or _G.AimMethod and ABmethod == "Aim Player" or _G.AimMethod and ABmethod == "Nearest Aim") then
			t10[2] = MousePos

			return __namecall(unpack(t10))
		end

		return __namecall(...)
	end)
end

GetConnectionEnemies = function(p31)
	for _, child in pairs(replicated:GetChildren()) do
		if not child:IsA("Model") or not (typeof(p31) == "table" and table.find(p31, child.Name) or child.Name == p31) then
			continue
		end

		if child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 then
			return child
		end
	end

	local children, v79 = game.Workspace.Enemies:GetChildren()

	for _, v1 in next, children, v79 do
		if not v1:IsA("Model") then
			continue
		end

		if (typeof(p31) == "table" and table.find(p31, v1.Name) or v1.Name == p31) and v1:FindFirstChild("Humanoid") and v1.Humanoid.Health > 0 then
			return v1
		end
	end
end
LowCpu = function()
	local Terrain = game.Workspace.Terrain

	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 0
	game.Lighting.GlobalShadows = false
	game.Lighting.FogEnd = 9e9
	game.Lighting.Brightness = 0
	settings().Rendering.QualityLevel = "Level01"

	for _, descendant in pairs(game:GetDescendants()) do
		if descendant:IsA("Part") or descendant:IsA("Union") or descendant:IsA("CornerWedgePart") or descendant:IsA("TrussPart") then
			descendant.Material = "Plastic"
			descendant.Reflectance = 0
		else
			if not descendant:IsA("Decal") then
				if not descendant:IsA("Texture") then
					if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
						descendant.Lifetime = NumberRange.new(0)
					elseif descendant:IsA("Explosion") then
						descendant.BlastPressure = 1
						descendant.BlastRadius = 1
					elseif descendant:IsA("Fire") or descendant:IsA("SpotLight") or descendant:IsA("Smoke") or descendant:IsA("Sparkles") then
						descendant.Enabled = false
					elseif descendant:IsA("MeshPart") then
						descendant.Material = "Plastic"
						descendant.Reflectance = 0
						descendant.TextureID = 10385902758728956
					end

					continue
				end
			end

			descendant.Transparency = 1
		end
	end

	for _, child in pairs(game.Lighting:GetChildren()) do
		if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
			child.Enabled = false
		end
	end
end
CheckF = function()
	if not (GetBP("Dragon-Dragon") or GetBP("Gas-Gas")) then
		if not (GetBP("Yeti-Yeti") or GetBP("Kitsune-Kitsune") or GetBP("T-Rex-T-Rex")) then
			return
		end
	end

	return true
end
CheckBoat = function()
	for _, child in pairs(workspace.Boats:GetChildren()) do
		if tostring(child.Owner.Value) == tostring(plr.Name) then
			return child
		end
	end

	return false
end

do
	CheckEnemiesBoat = function()
		for _, child in pairs(workspace.Enemies:GetChildren()) do
			if child.Name == "FishBoat" and child:FindFirstChild("Health").Value > 0 then
				return true
			end
		end

		return false
	end
end

CheckPirateGrandBrigade = function()
	for _, child in pairs(workspace.Enemies:GetChildren()) do
		if (child.Name == "PirateGrandBrigade" or child.Name == "PirateBrigade") and child:FindFirstChild("Health").Value > 0 then
			return true
		end
	end

	return false
end

do
	CheckShark = function()
		for _, child in pairs(workspace.Enemies:GetChildren()) do
			if child.Name == "Shark" and t9.Alive(child) then
				return true
			end
		end

		return false
	end
end

CheckTerrorShark = function()
	for _, child in pairs(workspace.Enemies:GetChildren()) do
		if child.Name == "Terrorshark" and t9.Alive(child) then
			return true
		end
	end

	return false
end

do
	CheckPiranha = function()
		for _, child in pairs(workspace.Enemies:GetChildren()) do
			if child.Name == "Piranha" and t9.Alive(child) then
				return true
			end
		end

		return false
	end
end

CheckFishCrew = function()
	for _, child in pairs(workspace.Enemies:GetChildren()) do
		if (child.Name == "Fish Crew Member" or child.Name == "Haunted Crew Member") and t9.Alive(child) then
			return true
		end
	end

	return false
end
CheckHauntedCrew = function()
	for _, child in pairs(workspace.Enemies:GetChildren()) do
		if child.Name == "Haunted Crew Member" then
			if t9.Alive(child) then
				return true
			end
		end
	end

	return false
end
CheckSeaBeast = function()
	if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
		return true
	end

	return false
end
CheckLeviathan = function()
	if workspace.SeaBeasts:FindFirstChild("Leviathan") then
		return true
	end

	return false
end
UpdStFruit = function()
	local children, v104 = plr.Backpack:GetChildren()

	for _, v1 in next, children, v104 do
		StoreFruit = v1:FindFirstChild("EatRemote", true)

		if StoreFruit then
			replicated.Remotes.CommF_:InvokeServer("StoreFruit", StoreFruit.Parent:GetAttribute("OriginalName"), plr.Backpack:FindFirstChild(v1.Name))
		end
	end
end
collectFruits = function(p32)
	if p32 then
		local Character = plr.Character

		for _, child in pairs(workspace:GetChildren()) do
			if string.find(child.Name, "Fruit") then
				child.Handle.CFrame = Character.HumanoidRootPart.CFrame
			end
		end
	end
end

do
	Getmoon = function()
		if World1 then
			return Lighting.FantasySky.MoonTextureId
		end

		if World2 then
			return Lighting.FantasySky.MoonTextureId
		end

		if World3 then
			return Lighting.Sky.MoonTextureId
		end
	end
end

DropFruits = function()
	local children, v111 = plr.Backpack:GetChildren()

	for _, v1 in next, children, v111 do
		if string.find(v1.Name, "Fruit") then
			EquipWeapon(v1.Name)
			wait(0.1)

			if plr.PlayerGui.Main.Dialogue.Visible == true then
				plr.PlayerGui.Main.Dialogue.Visible = false
			end

			EquipWeapon(v1.Name)
			plr.Character:FindFirstChild(v1.Name).EatRemote:InvokeServer("Drop")
		end
	end

	for _, child in pairs(plr.Character:GetChildren()) do
		if string.find(child.Name, "Fruit") then
			EquipWeapon(child.Name)
			wait(0.1)

			if plr.PlayerGui.Main.Dialogue.Visible == true then
				plr.PlayerGui.Main.Dialogue.Visible = false
			end

			EquipWeapon(child.Name)
			plr.Character:FindFirstChild(child.Name).EatRemote:InvokeServer("Drop")
		end
	end
end

do
	GetBP = function(p33)
		return plr.Backpack:FindFirstChild(p33) or plr.Character:FindFirstChild(p33)
	end
end

GetIn = function(p34)
	for _, v1 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
		if type(v1) == "table" then
			if v1.Name == p34 then
				return true
			end

			if plr.Character:FindFirstChild(p34) then
				return true
			end

			if plr.Backpack:FindFirstChild(p34) then
				return true
			end
		end
	end

	return false
end
GetM = function(p35)
	for _, v1 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
		if type(v1) == "table" and v1.Type == "Material" and v1.Name == p35 then
			return v1.Count
		end
	end

	return 0
end
GetWP = function(p36)
	local response = replicated.Remotes.CommF_:InvokeServer("getInventory")

	if type(response) ~= "table" then
		return false
	end

	for _, v1 in pairs(response) do
		if type(v1) == "table" and v1.Type == "Sword" then
			if v1.Name == p36 then
				return true
			end

			if plr.Character then
				if plr.Character:FindFirstChild(p36) then
					return true
				end
			end

			if not plr.Backpack then
				continue
			end

			if plr.Backpack:FindFirstChild(p36) then
				return true
			end
		end
	end

	return false
end

do
	getInfinity_Ability = function(p37, p38)
		if not Root then
			return
		end

		if p37 == "Soru" and p38 then
			local next_ = next
			local v124, v125 = getgc()

			for _, v1 in next_, v124, v125 do
				if plr.Character.Soru and typeof(v1) == "function" then
					if getfenv(v1).script == plr.Character.Soru then
						local next_2 = next
						local v129, v130 = getupvalues(v1)

						for _, v2 in next_2, v129, v130 do
							if typeof(v2) == "table" then
								repeat
									wait(Sec)
									v2.LastUse = 0
								until plr.Character.Humanoid.Health <= 0
							end
						end
					end
				end
			end
		elseif p37 == "Energy" and p38 then
			plr.Character.Energy.Changed:connect(function()
				if p38 then
					plr.Character.Energy.Value = Energy
				end
			end)
		elseif p37 == "Observation" and p38 then
			plr.VisionRadius.Value = math.huge
		end
	end
end

Hop = function()
	pcall(function()
		for i = math.random(1, math.random(40, 75)), 100 do
			for k, v1 in next, replicated.__ServerBrowser:InvokeServer(i), nil do
				if tonumber(v1.Count) < 12 then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, k)
				end
			end
		end
	end)
end

local Part = Instance.new("Part", workspace)

Part.Size = Vector3.new(1, 1, 1)
Part.Name = "Rip_Indra"
Part.Anchored = true
Part.CanCollide = false
Part.CanTouch = false
Part.Transparency = 1

local PartName = workspace:FindFirstChild(Part.Name)

if PartName and PartName ~= Part then
	PartName:Destroy()
end

task.spawn(function()
	while task.wait() do
		if not Part or Part.Parent ~= workspace then
			getgenv().OnFarm = false
		elseif shouldTween then
			getgenv().OnFarm = true
		else
			getgenv().OnFarm = false
		end
	end
end)
task.spawn(function()
	local LocalPlayer = game.Players.LocalPlayer

	while true do
		task.wait()

		if not LocalPlayer.Character then
			continue
		end

		if LocalPlayer.Character.PrimaryPart then
			break
		end
	end

	Part.CFrame = LocalPlayer.Character.PrimaryPart.CFrame

	while task.wait() do
		pcall(function()
			if getgenv().OnFarm then
				if not _G.WasOnFarm then
					_G.WasOnFarm = true
				end

				if Part and Part.Parent == workspace then
					local PrimaryPart = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart

					if PrimaryPart and (PrimaryPart.Position - Part.Position).Magnitude <= 200 then
						PrimaryPart.CFrame = CFrame.new(Part.Position)
					else
						Part.CFrame = PrimaryPart.CFrame
					end
				end

				local Character = LocalPlayer.Character

				if Character then
					for _, child in pairs(Character:GetChildren()) do
						if child:IsA("BasePart") then
							child.CanCollide = false
						end
					end
				end
			elseif _G.WasOnFarm then
				_G.WasOnFarm = false

				local Character = LocalPlayer.Character

				if Character then
					for _, child in pairs(Character:GetChildren()) do
						if child:IsA("BasePart") then
							child.CanCollide = true
						end
					end
				end
			end
		end)
	end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("TweenService")
game:GetService("RunService")

do
	local LocalPlayer = game:GetService("Players").LocalPlayer

	sea1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
	sea2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
	sea3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

	local t11 = {
		["Tween Speed"] = 200,
		["Bypass Teleport"] = false,
		["Up Y"] = false,
		["Up Y When Low Health"] = false,
		["Same Y"] = false
	}
	local cFrame = CFrame.new(10641.0918, -1953.92981, 9825.07031, -0.652825892, -9.2805891e-08, -0.757508039, -2.73638356e-08, 1, -9.89323823e-08, 0.757508039, -4.38572947e-08, -0.652825892)
	local cFrame2 = CFrame.new(-16271.126, 25.5847301, 1371.98755, 0.999396622, -5.78875188e-08, -0.0347310975, 5.52972779e-08, 1, -8.7544322e-08, 0.034731105, 8.28877091e-08, 0.999396741)

	Convert_CFrame = function(p39)
		if not p39 then
			return
		end

		if typeof(p39) == "Vector3" then
			return CFrame.new(p39)
		end

		if typeof(p39) == "CFrame" then
			return p39
		end

		if typeof(p39) == "Model" then
			return p39:GetPivot()
		end

		if p39.CFrame then
			return p39.CFrame
		end

		return nil
	end
	GetDistance = function(p40, p41, p42)
		if p40 == nil then
			return 9e9
		end

		local Character = LocalPlayer.Character

		if not Character then
			return 9e9
		end

		local Humanoid = Character:FindFirstChild("Humanoid")

		if not Humanoid or Humanoid.Health <= 0 then
			return 9e9
		end

		if p41 == nil then
			p41 = Character:FindFirstChild("HumanoidRootPart")

			if not p41 then
				return 9e9
			end
		end

		local v153 = Convert_CFrame(p40)
		local v154 = Convert_CFrame(p41)

		if p42 then
			return (Vector3.new(v153.X, 0, v153.Z) - Vector3.new(v154.X, 0, v154.Z)).Magnitude
		end

		return (v153.Position - v154.Position).Magnitude
	end
	InArea = function(p43)
		local _WorldOrigin = workspace:FindFirstChild("_WorldOrigin")

		if not _WorldOrigin then
			return {
				Name = ""
			}
		end

		local v156 = Convert_CFrame(p43)
		local children, v158 = _WorldOrigin.Locations:GetChildren()

		for _, v1 in next, children, v158 do
			if v1:FindFirstChild("Mesh") and (v156.Position - v1.Position).Magnitude <= v1.Mesh.Scale.X then
				return v1
			end
		end

		return {
			Name = ""
		}
	end
	GetSpawnPoint = function(p44)
		local PlayerSpawns = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("PlayerSpawns")

		PlayerSpawns = PlayerSpawns and workspace._WorldOrigin.PlayerSpawns:FindFirstChild("Pirates")

		if not PlayerSpawns then
			return
		end

		local children, v163 = PlayerSpawns:GetChildren()

		for _, v1 in next, children, v163 do
			if v1:FindFirstChild("Part") and (v1.Part.Position - p44.Position).Magnitude <= 2500 then
				return v1
			end
		end
	end
	CheckLegendaryItems = function()
		local function v166(p45)
			local children, v168 = LocalPlayer.Backpack:GetChildren()

			for _, v1 in next, children, v168 do
				if v1:IsA("Tool") and (v1.Name == p45 or string.find(v1.Name, p45)) then
					return v1
				end
			end

			local children2, v172 = LocalPlayer.Character:GetChildren()

			for _, v1 in next, children2, v172 do
				if v1:IsA("Tool") and (v1.Name == p45 or string.find(v1.Name, p45)) then
					return v1
				end
			end
		end

		if not v166("God's Chalice") then
			if not (v166("Fist of Darkness") or v166("Sweet Chalice") or v166("Hallow Essence") or v166("Flower1")) then
				return false
			end
		end

		return true
	end
	WaitForHumanoid = function()
		local Character = LocalPlayer.Character

		if not Character then
			return nil
		end

		local Humanoid = Character:FindFirstChild("Humanoid")

		if Humanoid then
			return Humanoid
		end

		local v177 = tick() + 5
		local Humanoid2

		while true do
			if not (tick() < v177) then
				return nil
			end

			Humanoid2 = Character:FindFirstChild("Humanoid")

			if not Humanoid2 then
				task.wait(0.1)

				continue
			end

			break
		end

		return Humanoid2
	end
	checkinventory = function(p46)
		if p46 then
			for _, v1 in pairs(ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")) do
				if v1.Name == p46 then
					return true
				end
			end
		end

		return false
	end
	getdis = function(p47, p48)
		local CFrame_ = p48 or LocalPlayer.Character.HumanoidRootPart.CFrame

		return (CFrame.new(p47.X, CFrame_.Y, p47.Z).Position - CFrame.new(CFrame_.X, CFrame_.Y, CFrame_.Z).Position).Magnitude
	end
	CanBypassTeleport = function(p49)
		local Name = InArea(p49).Name

		if Name == "" then
			return false
		end

		if not (not t11["Bypass Teleport"] or Name:find("Dimension") or Name:find("Submerged")) then
			if Name ~= "Sealed Cavern" then
				if not (Name:lower():find("under") or CheckLegendaryItems()) then
					if LocalPlayer.Data and LocalPlayer.Data.LastSpawnPoint and LocalPlayer.Data.LastSpawnPoint.Value == "SubmergedIsland" then
						return false
					end

					if GetDistance(p49.Position) <= 3500 then
						return false
					end

					return true
				end
			end
		end

		return false
	end
	GetBypassCFrame = function(p50)
		local huge = math.huge
		local v184
		local children = workspace._WorldOrigin.PlayerSpawns.Pirates:GetChildren()
		local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return nil
		end

		for _, v1 in next, children, nil do
			if v1:FindFirstChild("Part") and (p50.Position - HumanoidRootPart.Position).Magnitude >= 3000 and GetSpawnPoint(v1.Part) ~= GetSpawnPoint(HumanoidRootPart) and (v1.Part.Position - HumanoidRootPart.Position).Magnitude <= 10000 and (v1.Part.Position - p50.Position).Magnitude <= huge then
				huge = (v1.Part.Position - p50.Position).Magnitude
				v184 = v1
			end
		end

		return v184
	end
	BypassTP = function(p51)
		local Character = LocalPlayer.Character

		if not Character then
			return
		end

		local v190 = WaitForHumanoid()

		if not v190 or v190.Health <= 0 then
			return
		end

		if CanBypassTeleport(p51) and GetBypassCFrame(p51) then
			local v191 = GetBypassCFrame(p51)

			if v191 and v191:FindFirstChild("Part") then
				Character.LastSpawnPoint.Disabled = true
				ReplicatedStorage.Remotes.CommF_:InvokeServer("SetLastSpawnPoint", v191.Name)
				ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
				Character:PivotTo(v191.Part.CFrame)
				v190:ChangeState(15)

				while true do
					task.wait()

					if not LocalPlayer.Character then
						continue
					end

					if WaitForHumanoid() and WaitForHumanoid().Health > 0 then
						break
					end
				end
			end
		end
	end
	totopofgreattree = function()
		if getdis(CFrame.new(28310.0234, 14895.1123, 109.456741)) > 1500 then
			ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28310.0234, 14895.1123, 109.456741))
			wait(0.3)
		end

		local cFrame3 = CFrame.new(28607.5352, 14896.5449, 106.011726)

		_tp(cFrame3)

		repeat
			wait()
		until getdis(cFrame3) <= 5

		wait(0.5)

		for i = 1, 4 do
			ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack")
		end
	end
	requestentrance = function(p52)
		local Position = p52

		if typeof(p52) == "CFrame" then
			Position = p52.Position
		end

		local t12

		if sea1 then
			t12 = {
				Sky3 = Vector3.new(-7894, 5547, -380),
				Sky3Exit = Vector3.new(-4607, 874, -1667),
				UnderWater = Vector3.new(61163, 11, 1819),
				["Underwater City"] = Vector3.new(61165.19140625, 0.18704631924629211, 1897.379150390625),
				["Pirate Village"] = Vector3.new(-1242.4625244140625, 4.7870597839355469, 3901.282958984375),
				UnderwaterExit = Vector3.new(4050, -1, -1814)
			}
		elseif sea2 then
			t12 = {
				["Swan Mansion"] = Vector3.new(-390, 332, 673),
				["Swan Room"] = Vector3.new(2285, 15, 905),
				["Cursed Ship"] = Vector3.new(923, 126, 32852),
				["Zombie Island"] = Vector3.new(-6509, 83, -133)
			}
		else
			t12 = {
				["Hydra Island"] = Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625),
				Mansion = Vector3.new(-12462, 375, -7552),
				Castle = Vector3.new(-5036, 315, -3179),
				["Temple of Time"] = Vector3.new(28286, 14897, 103),
				["Greate Tree"] = Vector3.new(3024.1709, 2280.69434, -7325.12793)
			}

			if not checkinventory("Valkyrie Helm") then
				return
			end
		end

		local v196
		local huge = math.huge

		for _, v1 in pairs(t12) do
			local Magnitude = typeof(v1) == "Vector3" and (v1 - Position).Magnitude or (v1.Position - Position).Magnitude

			if Magnitude < huge then
				huge = Magnitude
				v196 = v1
			end
		end

		if v196 then
			if huge and huge < getdis(p52) then
				pcall(function()
					if _G.TweenCache then
						_G.TweenCache:Cancel()
					end
				end)

				local ok = not (typeof(v196) == "Vector3" and v196.X == 3024.1709 and v196.Y == 2280.69434 and v196.Z == -7325.12793)

				if not ok then
					ok = not (ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") >= 2)
				end

				if ok then
					if huge < getdis(p52) then
						ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", typeof(v196) == "Vector3" and v196 or v196.Position)
						wait(1)
					end
				else
					totopofgreattree()
					wait(1)
				end
			end
		end
	end
	_tp = function(p53)
		local cFrame3

		if typeof(p53) == "Vector3" then
			cFrame3 = CFrame.new(p53)
		elseif typeof(p53) == "CFrame" then
			cFrame3 = p53
		else
			cFrame3 = p53 and p53.CFrame
		end

		if not cFrame3 then
			return
		end

		if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
			return
		end

		local HumanoidRootPart = plr.Character.HumanoidRootPart

		getgenv().OnFarm = false
		pcall(function()
			if CanBypassTeleport(cFrame3) then
				BypassTP(cFrame3)
				task.wait(0.5)
			end
		end)
		pcall(function()
			requestentrance(p53)
		end)

		if sea3 then
			if getdis(cFrame3.Position, cFrame.Position) < 2000 then
				local HumanoidRootPart2 = plr.Character.HumanoidRootPart

				if math.abs(cFrame.Position.Y - HumanoidRootPart2.CFrame.Y) > 1000 then
					repeat
						task.wait()
						old_tp(cFrame2)

						if getdis(cFrame2) < 10 then
							local Net = ReplicatedStorage.Modules.Net

							Net["RF/SubmarineWorkerSpeak"]:InvokeServer("AskKilledTikiBoss")
							task.wait(0.5)
							Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
						end
					until getdis(cFrame3.Position) < 2000

					task.wait(0.6)
					pcall(function()
						if HumanoidRootPart2:FindFirstChild("BodyClip") then
							HumanoidRootPart2.BodyClip:Destroy()
						end
					end)
				end
			end
		end

		local Magnitude = (cFrame3.Position - HumanoidRootPart.Position).Magnitude
		local tweenInfo = TweenInfo.new(Magnitude / (Magnitude <= 15 and (getgenv().TweenSpeedNear or 180) or getgenv().TweenSpeedFar or 150), Enum.EasingStyle.Linear)
		local tween = game:GetService("TweenService"):Create(Part, tweenInfo, {
			CFrame = CFrame.new(cFrame3.Position)
		})

		if plr.Character.Humanoid.Sit == true then
			Part.CFrame = CFrame.new(Part.Position.X, cFrame3.Y, Part.Position.Z)
		end

		tween:Play()
		task.spawn(function()
			while tween.PlaybackState == Enum.PlaybackState.Playing do
				if shouldTween then
					task.wait(0.1)
				else
					tween:Cancel()

					break
				end
			end

			getgenv().OnFarm = true
		end)

		return tween
	end
end

old_tp = function(p54)
	if plr.Character then
		if plr.Character:FindFirstChild("HumanoidRootPart") then
			plr.Character.HumanoidRootPart.CFrame = p54
		end
	end
end

do
	TeleportToTarget = function(p55)
		local v209 = _tp(p55)

		if v209 then
			v209.Completed:Wait()
		end

		task.wait(0.1)
	end
end

notween = function(p56)
	plr.Character.HumanoidRootPart.CFrame = p56
end
BTP = function(p57)
	local LocalPlayer = game.Players.LocalPlayer
	local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
	local Humanoid = LocalPlayer.Character.Humanoid
	local Main = LocalPlayer.PlayerGui.Main
	local Position = HumanoidRootPart.Position

	repeat
		Humanoid.Health = 0
		HumanoidRootPart.CFrame = p57
		Main.Quest.Visible = false

		if (HumanoidRootPart.Position - Position).Magnitude > 1 then
			Position = HumanoidRootPart.Position
			HumanoidRootPart.CFrame = p57
		end

		task.wait(0.5)
	until (p57.Position - HumanoidRootPart.Position).Magnitude <= 2000
end
spawn(function()
	while task.wait() do
		pcall(function()
			if _G.Auto_StartRaid or _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prefully or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or getgenv().AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.AutoPole or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S or _G.FarmBoss or _G.AutoFarmAllBoss or _G.AutoFishSlap or _G.FarmTyrant or _G.FarmPhaBinh or _G.AutoSpawnCP or _G.AutoBerryH or _G.AutoChestBP or _G.FarmEliteHop or _G.AutoHop_Dough or _G.AutoDoughKing or _G.AutoAttackDoughKing or _G.StartEvent or _G.AutoMysticIsland or _G.AutoPlayerHunter or _G.SafeMode or _G.AutoKillMob or _G.AutoStartPrehistoric or _G.AutoUnHaki or _G.AutoAttackRipIndra or _G.AutoFarmIsland or _G.AutoFarmDungeon or _G.AutoFarmCandy or _G.AutoTP_Gift or _G.AutoTPGift or _G.AutoTPAndCollect or _G.MasterAutoLevel or _G.MasterAutoCandy or _G.TPFloor1 or _G.TPFloor2 or _G.TPFloor3 or _G.TPFloor4 or _G.AutoMagnetToken then
				shouldTween = true

				if not plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					local BodyVelocity = Instance.new("BodyVelocity")

					BodyVelocity.Name = "BodyClip"
					BodyVelocity.Parent = plr.Character.HumanoidRootPart
					BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
					BodyVelocity.Velocity = Vector3.new(0, 0, 0)
				end

				if not plr.Character:FindFirstChild("highlight") then
					local Highlight = Instance.new("Highlight")

					Highlight.Name = "highlight"
					Highlight.Enabled = true
					Highlight.FillColor = Color3.fromRGB(0, 255, 254)
					Highlight.OutlineColor = Color3.fromRGB(0, 255, 254)
					Highlight.FillTransparency = 0.5
					Highlight.OutlineTransparency = 0.2
					Highlight.Parent = plr.Character
				end

				for _, descendant in pairs(plr.Character:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = false
					end
				end
			else
				shouldTween = false

				if plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					plr.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
				end

				if plr.Character:FindFirstChild("highlight") then
					plr.Character:FindFirstChild("highlight"):Destroy()
				end
			end
		end)
	end
end)
QuestB = function()
	if World1 then
		if _G.FindBoss == "The Gorilla King" then
			bMon = "The Gorilla King"
			Qname = "JungleQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
			PosB = CFrame.new(-1088.75977, 8.13463783, -488.559906, -0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, -0.707134247)
		elseif _G.FindBoss == "Bobby" then
			bMon = "Bobby"
			Qname = "BuggyQuest1"
			Qdata = 3
			PosQBoss = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
			PosB = CFrame.new(-1087.3760986328, 46.949409484863, 4040.1462402344)
		elseif _G.FindBoss == "The Saw" then
			bMon = "The Saw"
			PosB = CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906)
		elseif _G.FindBoss == "Yeti" then
			bMon = "Yeti"
			Qname = "SnowQuest"
			Qdata = 3
			PosQBoss = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
			PosB = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172)
		elseif _G.FindBoss == "Mob Leader" then
			bMon = "Mob Leader"
			PosB = CFrame.new(-2844.7307128906, 7.4180502891541, 5356.6723632813)
		elseif _G.FindBoss == "Vice Admiral" then
			bMon = "Vice Admiral"
			Qname = "MarineQuest2"
			Qdata = 2
			PosQBoss = CFrame.new(-5036.2465820313, 28.677835464478, 4324.56640625)
			PosB = CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375)
		elseif _G.FindBoss == "Saber Expert" then
			bMon = "Saber Expert"
			PosB = CFrame.new(-1458.89502, 29.8870335, -50.633564)
		elseif _G.FindBoss == "Warden" then
			bMon = "Warden"
			Qname = "ImpelQuest"
			Qdata = 1
			PosB = CFrame.new(5278.04932, 2.15167475, 944.101929, 0.220546961, -4.49946401e-06, 0.975376427, -1.95412576e-05, 1, 9.03162072e-06, -0.975376427, -2.10519756e-05, 0.220546961)
			PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
		elseif _G.FindBoss == "Chief Warden" then
			bMon = "Chief Warden"
			Qname = "ImpelQuest"
			Qdata = 2
			PosB = CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, -0.00062915677, 0.939684749, 0.00191645394, 0.999998152, -2.80422337e-05, -0.939682961, 0.00181045406, 0.342041939)
			PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
		elseif _G.FindBoss == "Swan" then
			bMon = "Swan"
			Qname = "ImpelQuest"
			Qdata = 3
			PosB = CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812)
			PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
		elseif _G.FindBoss == "Magma Admiral" then
			bMon = "Magma Admiral"
			Qname = "MagmaQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-5314.6220703125, 12.262420654297, 8517.279296875)
			PosB = CFrame.new(-5765.8969726563, 82.92064666748, 8718.3046875)
		elseif _G.FindBoss == "Fishman Lord" then
			bMon = "Fishman Lord"
			Qname = "FishmanQuest"
			Qdata = 3
			PosQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
			PosB = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984)
		elseif _G.FindBoss == "Wysper" then
			bMon = "Wysper"
			Qname = "SkyExp1Quest"
			Qdata = 3
			PosQBoss = CFrame.new(-7861.947265625, 5545.517578125, -379.85974121094)
			PosB = CFrame.new(-7866.1333007813, 5576.4311523438, -546.74816894531)
		elseif _G.FindBoss == "Thunder God" then
			bMon = "Thunder God"
			Qname = "SkyExp2Quest"
			Qdata = 3
			PosQBoss = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
			PosB = CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188)
		elseif _G.FindBoss == "Cyborg" then
			bMon = "Cyborg"
			Qname = "FountainQuest"
			Qdata = 3
			PosQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
			PosB = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813)
		elseif _G.FindBoss == "Ice Admiral" then
			bMon = "Ice Admiral"
			Qdata = nil
			PosQBoss = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
			PosB = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
		elseif _G.FindBoss == "Greybeard" then
			bMon = "Greybeard"
			Qdata = nil
			PosQBoss = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
			PosB = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
		end
	end

	if World2 then
		if _G.FindBoss == "Diamond" then
			bMon = "Diamond"
			Qname = "Area1Quest"
			Qdata = 3
			PosQBoss = CFrame.new(-427.5666809082, 73.313781738281, 1835.4208984375)
			PosB = CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407)
		elseif _G.FindBoss == "Jeremy" then
			bMon = "Jeremy"
			Qname = "Area2Quest"
			Qdata = 3
			PosQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063)
			PosB = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109)
		elseif _G.FindBoss == "Orbitus" then
			bMon = "Orbitus"
			Qname = "MarineQuest3"
			Qdata = 3
			PosQBoss = CFrame.new(-2441.986328125, 73.359344482422, -3217.5324707031)
			PosB = CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625)
		elseif _G.FindBoss == "Don Swan" then
			bMon = "Don Swan"
			PosB = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875)
		elseif _G.FindBoss == "Smoke Admiral" then
			bMon = "Smoke Admiral"
			Qname = "IceSideQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813)
			PosB = CFrame.new(-5275.1987304688, 20.757257461548, -5260.6669921875)
		elseif _G.FindBoss == "Awakened Ice Admiral" then
			bMon = "Awakened Ice Admiral"
			Qname = "FrostQuest"
			Qdata = 3
			PosQBoss = CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813)
			PosB = CFrame.new(6403.5439453125, 340.29766845703, -6894.5595703125)
		elseif _G.FindBoss == "Tide Keeper" then
			bMon = "Tide Keeper"
			Qname = "ForgottenQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625)
			PosB = CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188)
		elseif _G.FindBoss == "Darkbeard" then
			bMon = "Darkbeard"
			Qdata = nil
			PosQBoss = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
			PosB = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
		elseif _G.FindBoss == "Cursed Captaim" then
			bMon = "Cursed Captain"
			Qdata = nil
			PosQBoss = CFrame.new(916.928589, 181.092773, 33422)
			PosB = CFrame.new(916.928589, 181.092773, 33422)
		elseif _G.FindBoss == "Order" then
			bMon = "Order"
			Qdata = nil
			PosQBoss = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
			PosB = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
		end
	end

	if World3 then
		if _G.FindBoss == "Stone" then
			bMon = "Stone"
			Qname = "PiratePortQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-289.76705932617, 43.819011688232, 5579.9384765625)
			PosB = CFrame.new(-1027.6512451172, 92.404174804688, 6578.8530273438)
		elseif _G.FindBoss == "Hydra Leader" then
			bMon = "Hydra Leader"
			Qname = "VenomCrewQuest"
			Qdata = 3
			PosQBoss = CFrame.new(5211.021484375, 1004.35778859375, 758.18475341796875)
			PosB = CFrame.new(5821.89794921875, 1019.0950927734375, -73.719230651855469)
		elseif _G.FindBoss == "Kilo Admiral" then
			bMon = "Kilo Admiral"
			Qname = "MarineTreeIsland"
			Qdata = 3
			PosQBoss = CFrame.new(2179.3010253906, 28.731239318848, -6739.9741210938)
			PosB = CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125)
		elseif _G.FindBoss == "Captain Elephant" then
			bMon = "Captain Elephant"
			Qname = "DeepForestIsland"
			Qdata = 3
			PosQBoss = CFrame.new(-13232.682617188, 332.40396118164, -7626.01171875)
			PosB = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125)
		elseif _G.FindBoss == "Beautiful Pirate" then
			bMon = "Beautiful Pirate"
			Qname = "DeepForestIsland2"
			Qdata = 3
			PosQBoss = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
			PosB = CFrame.new(5283.609375, 22.56223487854, -110.78285217285)
		elseif _G.FindBoss == "Cake Queen" then
			bMon = "Cake Queen"
			Qname = "IceCreamIslandQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0, -0.642767608, 0, -0.766061664)
			PosB = CFrame.new(-678.648804, 381.353943, -11114.2012, -0.908641815, 0.00149294338, 0.41757378, 0.00837114919, 0.999857843, 0.0146408929, -0.417492568, 0.0167988986, -0.90852499)
		elseif _G.FindBoss == "Longma" then
			bMon = "Longma"
			Qdata = nil
			PosQBoss = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
			PosB = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
		elseif _G.FindBoss == "Soul Reaper" then
			bMon = "Soul Reaper"
			Qdata = nil
			PosQBoss = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
			PosB = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
		end
	end
end

do
	QuestBeta = function()
		QuestB()

		return {
			[0] = _G.FindBoss,
			bMon,
			Qdata,
			Qname,
			PosB,
			PosQBoss
		}
	end
end

do
	local Quests = require(game:GetService("ReplicatedStorage"):WaitForChild("Quests"))
	local GuideModule = require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule"))
	local t13 = {
		"MarineQuest",
		"BartiloQuest",
		"CitizenQuest",
		"Trainees"
	}

	CheckSea = function(p58)
		if (game.PlaceId == 2753915549 or game.PlaceId == 85211729168715) and p58 == 1 then
			return true
		end

		if (game.PlaceId == 4442272183 or game.PlaceId == 79091703265657) and p58 == 2 then
			return true
		end

		if (game.PlaceId == 7449423635 or game.PlaceId == 100117331123089) and p58 == 3 then
			return true
		end

		return false
	end
	GetQuestPointFromNPC = function(p59)
		for _, child in pairs(workspace.NPCs:GetChildren()) do
			if child.Name == p59 and child:FindFirstChild("HumanoidRootPart") then
				return child.HumanoidRootPart.CFrame
			end
		end

		for _, child in pairs(replicated.NPCs:GetChildren()) do
			if child.Name == p59 and child:FindFirstChild("HumanoidRootPart") then
				return child.HumanoidRootPart.CFrame
			end
		end

		return nil
	end
	GetQuests = function()
		local Value = plr.Data.Level.Value
		local n1 = 0
		local t14 = {}

		if Value >= 700 and CheckSea(1) then
			t14.Mob = "Galley Captain"
			t14.NameQuest = "FountainQuest"
			t14.ID = 2
			t14.LevelReq = 700
		elseif Value >= 1500 and CheckSea(2) then
			t14.Mob = "Water Fighter"
			t14.NameQuest = "ForgottenQuest"
			t14.ID = 2
			t14.LevelReq = 1450
		else
			for k, Quest in pairs(Quests) do
				for k2, v1 in pairs(Quest) do
					local LevelReq = v1.LevelReq

					for k3 in pairs(v1.Task) do
						if LevelReq <= Value and n1 <= LevelReq and v1.Task[k3] > 1 and not table.find(t13, k) then
							n1 = LevelReq
							t14.Mob = k3
							t14.NameQuest = k
							t14.ID = k2
							t14.LevelReq = LevelReq
						end
					end
				end
			end
		end

		return t14
	end
	GetQuestPoint = function()
		if GuideModule and GuideModule.Data and GuideModule.Data.LastClosestNPC then
			return GetQuestPointFromNPC(GuideModule.Data.LastClosestNPC)
		end

		return nil
	end
end

MaterialMon = function()
	local LocalPlayer = game.Players.LocalPlayer
	local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	shouldRequestEntrance = function(p60, p61)
		if p61 <= (HumanoidRootPart.Position - p60).Magnitude then
			replicated.Remotes.CommF_:InvokeServer("requestEntrance", p60)
		end
	end

	if not World1 then
		if not World2 then
			if World3 then
				if SelectMaterial == "Scrap Metal" then
					MMon = {
						"Jungle Pirate",
						"Forest Pirate"
					}
					MPos = CFrame.new(-11975.78515625, 331.77340698242188, -10620.0302734375)
					SP = "Default"
				elseif SelectMaterial == "Fish Tail" then
					MMon = {
						"Fishman Raider",
						"Fishman Captain"
					}
					MPos = CFrame.new(-10993, 332, -8940)
					SP = "Default"
				elseif SelectMaterial == "Conjured Cocoa" then
					MMon = {
						"Chocolate Bar Battler",
						"Cocoa Warrior"
					}
					MPos = CFrame.new(620.63446044921875, 78.936447143554688, -12581.369140625)
					SP = "Default"
				elseif SelectMaterial == "Dragon Scale" then
					MMon = {
						"Dragon Crew Archer",
						"Dragon Crew Warrior"
					}
					MPos = CFrame.new(6594, 383, 139)
					SP = "Default"
				elseif SelectMaterial == "Gunpowder" then
					MMon = { "Pistol Billionaire" }
					MPos = CFrame.new(-84.855690002441406, 85.620613098144531, 6132.0087890625)
					SP = "Default"
				elseif SelectMaterial == "Mini Tusk" then
					MMon = { "Mythological Pirate" }
					MPos = CFrame.new(-13545, 470, -6917)
					SP = "Default"
				elseif SelectMaterial == "Demonic Wisp" then
					MMon = { "Demonic Soul" }
					MPos = CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)
					SP = "Default"
				end
			end
		elseif SelectMaterial == "Leather + Scrap Metal" then
			MMon = { "Marine Captain" }
			MPos = CFrame.new(-2010.5059814453125, 73.00115966796875, -3326.620849609375)
			SP = "Default"
		elseif SelectMaterial == "Magma Ore" then
			MMon = {
				"Magma Ninja",
				"Lava Pirate"
			}
			MPos = CFrame.new(-5428, 78, -5959)
			SP = "Default"
		elseif SelectMaterial == "Ectoplasm" then
			MMon = {
				"Ship Deckhand",
				"Ship Engineer",
				"Ship Steward",
				"Ship Officer"
			}
			MPos = CFrame.new(911.35827636719, 125.95812988281, 33159.5390625)
			SP = "Default"
			shouldRequestEntrance(Vector3.new(61163.8515625, 5.3423423767089844, 1819.7841796875), 18000)
		elseif SelectMaterial == "Mystic Droplet" then
			MMon = { "Water Fighter" }
			MPos = CFrame.new(-3385, 239, -10542)
			SP = "Default"
		elseif SelectMaterial == "Radioactive Material" then
			MMon = { "Factory Staff" }
			MPos = CFrame.new(295, 73, -56)
			SP = "Default"
		elseif SelectMaterial == "Vampire Fang" then
			MMon = { "Vampire" }
			MPos = CFrame.new(-6033, 7, -1317)
			SP = "Default"
		end
	elseif SelectMaterial == "Angel Wings" then
		MMon = {
			"Shanda",
			"Royal Squad",
			"Royal Soldier",
			"Wysper",
			"Thunder God"
		}
		MPos = CFrame.new(-4698, 845, -1912)
		SP = "Default"
		shouldRequestEntrance(Vector3.new(-4607.82275, 872.54248, -1667.55688), 10000)
	elseif SelectMaterial == "Leather + Scrap Metal" then
		MMon = {
			"Brute",
			"Pirate"
		}
		MPos = CFrame.new(-1145, 15, 4350)
		SP = "Default"
	elseif SelectMaterial == "Magma Ore" then
		MMon = {
			"Military Soldier",
			"Military Spy",
			"Magma Admiral"
		}
		MPos = CFrame.new(-5815, 84, 8820)
		SP = "Default"
	elseif SelectMaterial == "Fish Tail" then
		MMon = {
			"Fishman Warrior",
			"Fishman Commando",
			"Fishman Lord"
		}
		MPos = CFrame.new(61123, 19, 1569)
		SP = "Default"
		shouldRequestEntrance(Vector3.new(61163.8515625, 5.3423423767089844, 1819.7841796875), 17000)
	end
end
QuestNeta = function()
	local v237 = GetQuests()

	return {
		v237.Mob,
		v237.ID,
		v237.NameQuest,
		v237.LevelReq,
		v237.Mob,
		(GetQuestPoint())
	}
end

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxfruitsnokey/Banana/refs/heads/main/GB/ui.luau"))()
local v239 = lib:CreateWindow({
	Title = "GB Hub",
	Subtitle = "Blox Fruit Script",
	Image = "rbxassetid://88329907835665"
})
local t15 = {
	Info = v239:AddTab("Info And Status"),
	Main = v239:AddTab("Farming"),
	Settings = v239:AddTab("Setting"),
	Fish = v239:AddTab("Fishing"),
	Quests = v239:AddTab("Quest And Item"),
	SeaEvent = v239:AddTab("Sea Event"),
	Race = v239:AddTab("Mirage And Race"),
	Prehistoric = v239:AddTab("Volcano Event"),
	Esp = v239:AddTab("Stats And Esp"),
	Raids = v239:AddTab("Fruit And Raid"),
	Combat = v239:AddTab("Local Player"),
	Travel = v239:AddTab("Teleport"),
	Shop = v239:AddTab("Shopping"),
	Misc = v239:AddTab("Miscellaneous")
}

lib.ToggleUI()

local v241 = t15.Info:AddLeftGroupbox("Time Zone"):AddLabel("")

UpdateOS = function()
	local v242 = os.date("*t")
	local v243 = v242.hour % 24
	local v244 = v243 < 12 and "AM" or "PM"
	local v245 = string.format("%02i:%02i:%02i %s", (v243 - 1) % 12 + 1, v242.min, v242.sec, v244)
	local v246 = string.format("%02d/%02d/%04d", v242.day, v242.month, v242.year)
	local LocalizationService = game:GetService("LocalizationService")
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local countryRegionCode

	if getgenv().countryRegionCode then
		countryRegionCode = getgenv().countryRegionCode
	else
		local ok, result = pcall(function()
			return LocalizationService:GetCountryRegionForPlayerAsync(LocalPlayer)
		end)

		countryRegionCode = result

		if ok then
			getgenv().countryRegionCode = countryRegionCode
		else
			getgenv().countryRegionCode = "Unknown"
		end
	end

	v241:SetText(v246 .. " - " .. v245 .. " [ " .. countryRegionCode .. " ]")
end
spawn(function()
	while true do
		UpdateOS()
		wait(1)
	end
end)

local v252 = t15.Info:AddLeftGroupbox("Game Time"):AddLabel("")

UpdateGameTime = function()
	local v253 = math.floor(workspace.DistributedGameTime + 0.5)

	v252:SetText(math.floor(v253 / 3600) % 24 .. " Hour (h) " .. math.floor(v253 / 60) % 60 .. " Minute (m) " .. math.floor(v253 / 1) % 60 .. " Second (s)")
end
spawn(function()
	while true do
		UpdateGameTime()
		wait(1)
	end
end)

do
	local v254 = t15.Info:AddLeftGroupbox("Mirage Island"):AddLabel("Status: ")
	local s1 = ""

	spawn(function()
		pcall(function()
			while true do
				wait(1)

				local status = game.Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") ~= nil and "✅" or "❌"

				if status ~= s1 then
					v254:SetText("Status: " .. status)
					s1 = status
				end
			end
		end)
	end)
end

do
	local v257 = t15.Info:AddLeftGroupbox("Kitsune Island"):AddLabel("Status: ")
	local s2 = ""

	spawn(function()
		while task.wait(1) do
			local status = game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland") and "✅" or "❌"

			if status ~= s2 then
				v257:SetText("Status: " .. status)
				s2 = status
			end
		end
	end)
end

do
	local v260 = t15.Info:AddLeftGroupbox("Prehistoric Island"):AddLabel("Status: ")
	local s3 = ""

	task.spawn(function()
		if task.wait(1) then
			repeat
				local status = game.Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") and "✅" or "❌"

				if status ~= s3 then
					v260:SetText("Status: " .. status)
					s3 = status
				end
			until not task.wait(1)
		end
	end)
end

do
	local v263 = t15.Info:AddLeftGroupbox("Frozen Dimension"):AddLabel("Status: ")
	local s4 = ""

	spawn(function()
		while wait(1) do
			local status = game.Workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") and "✅" or "❌"

			if status ~= s4 then
				v263:SetText("Status: " .. status)
				s4 = status
			end
		end
	end)
end

local v266 = t15.Info:AddLeftGroupbox("Cake Prince Status"):AddLabel("")

spawn(function()
	while wait(1) do
		local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
		local s5 = "Cake Prince: ✅"

		if string.len(response) >= 86 then
			s5 = "Killed: " .. string.sub(response, 39, 41)
		end

		v266:SetText(s5)
	end
end)

do
	local v269 = t15.Info:AddLeftGroupbox("Rip Indra"):AddLabel("Status: ")
	local s6 = ""

	spawn(function()
		while wait(1) do
			local status = (game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form") or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra")) and "✅" or "❌"

			if status ~= s6 then
				v269:SetText("Status: " .. status)
				s6 = status
			end
		end
	end)
end

do
	local v272 = t15.Info:AddLeftGroupbox("Dough King"):AddLabel("Status: ")
	local s7 = ""

	spawn(function()
		while wait(1) do
			local status = (game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King")) and "✅" or "❌"

			if status ~= s7 then
				v272:SetText("Status: " .. status)
				s7 = status
			end
		end
	end)
end

do
	local v275 = t15.Info:AddLeftGroupbox("Full Moon"):AddLabel("")

	task.spawn(function()
		while task.wait(1) do
			local MoonTextureId = game:GetService("Lighting").Sky.MoonTextureId
			local s8 = "Moon: 0/5"

			if MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then
				s8 = "Moon: 5/5 (Full Moon) ✅"
			elseif MoonTextureId == "http://www.roblox.com/asset/?id=9709149052" then
				s8 = "Moon: 4/5"
			elseif MoonTextureId == "http://www.roblox.com/asset/?id=9709143733" then
				s8 = "Moon: 3/5"
			elseif MoonTextureId == "http://www.roblox.com/asset/?id=9709150401" then
				s8 = "Moon: 2/5"
			elseif MoonTextureId == "http://www.roblox.com/asset/?id=9709149680" then
				s8 = "Moon: 1/5"
			end

			v275:SetText(s8)
		end
	end)
end

local v278 = t15.Info:AddLeftGroupbox("Legendary Sword"):AddLabel("Status: ")

spawn(function()
	while wait(1) do
		local s9 = "Not Found"

		if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1") then
			s9 = "Shisui ✅"
		elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2") then
			s9 = "Wando ✅"
		elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3") then
			s9 = "Saddi ✅"
		end

		v278:SetText(s9)
	end
end)

local v280 = t15.Info:AddLeftGroupbox("Bone"):AddLabel("")

GRP_Main_Select_Weapon = t15.Main:AddLeftGroupbox("Select Weapon")
WeaponDropdown = GRP_Main_Select_Weapon:AddDropdown("Select_Weapon", {
	Text = "Select Weapon",
	Values = {
		"Melee",
		"Sword",
		"Blox Fruit",
		"Gun"
	},
	Default = "Melee",
	Callback = function(p62)
		_G.ChooseWP = p62
	end
})
spawn(function()
	while task.wait(0.5) do
		pcall(function()
			if _G.ChooseWP == "Melee" then
				for _, child in pairs(plr.Backpack:GetChildren()) do
					if child.ToolTip == "Melee" then
						_G.SelectWeapon = child.Name
					end
				end
			elseif _G.ChooseWP == "Sword" then
				for _, child in pairs(plr.Backpack:GetChildren()) do
					if child.ToolTip == "Sword" then
						_G.SelectWeapon = child.Name
					end
				end
			elseif _G.ChooseWP == "Gun" then
				for _, child in pairs(plr.Backpack:GetChildren()) do
					if child.ToolTip == "Gun" then
						_G.SelectWeapon = child.Name
					end
				end
			elseif _G.ChooseWP == "Blox Fruit" then
				for _, child in pairs(plr.Backpack:GetChildren()) do
					if child.ToolTip == "Blox Fruit" then
						_G.SelectWeapon = child.Name
					end
				end
			end
		end)
	end
end)
GRP_Main_Farming = t15.Main:AddLeftGroupbox("Farming")
FarmLevel = GRP_Main_Farming:AddToggle("Auto_Farm_Level", {
	Text = "Auto Farm Level",
	Default = false,
	Callback = function(p63)
		_G.Level = p63

		if not p63 then
			alreadyTeleported = false
			teleporting = false
		end
	end
})

do
	local u289 = false
	local u290 = false

	_G.CheckQuestVisible = function(p64)
		local LocalPlayer = p64 or game.Players.LocalPlayer
		local Quest = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
		local TrackedQuestFrame = LocalPlayer.PlayerGui:FindFirstChild("TrackedQuestFrame")

		if Quest and Quest.Visible then
			local s10 = ""

			pcall(function()
				s10 = Quest.Container.QuestTitle.Title.Text
			end)

			return true, s10
		end

		if not TrackedQuestFrame or not TrackedQuestFrame.Enabled then
			return false, ""
		end

		local s11 = ""

		pcall(function()
			s11 = TrackedQuestFrame.Frame.header.textLabel.Text
		end)

		if s11 == "" then
			pcall(function()
				s11 = TrackedQuestFrame.Frame.header.textLabel.textLabel.Text
			end)
		end

		return true, s11
	end

	local function v296()
		if not plr.Character then
			return false
		end

		local HumanoidRootPart = plr.Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return false
		end

		if HumanoidRootPart.Position.Y < -1000 then
			return true
		end

		local vector3 = Vector3.new(10533.28, 0, 9940.48)

		return (Vector3.new(HumanoidRootPart.Position.X, 0, HumanoidRootPart.Position.Z) - vector3).Magnitude < 4500
	end
	local function v299(...)
		local Main = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")

		if not Main then
			return nil
		end

		local v301 = Main

		for _, v1 in ipairs({ ... }) do
			if v301 then
				v301 = v301:FindFirstChild(v1)

				continue
			end

			return nil
		end

		return v301
	end
	local function v304(...)
		if select("#", ...) == 1 and select(1, ...) == "Quest" then
			local TrackedQuestFrame = game.Players.LocalPlayer.PlayerGui:FindFirstChild("TrackedQuestFrame")

			if TrackedQuestFrame then
				local Frame = TrackedQuestFrame:FindFirstChild("Frame")

				if Frame then
					return TrackedQuestFrame.Enabled and Frame.Visible
				end
			end
		end

		local v307 = v299(...)

		return v307 ~= nil and v307.Visible == true
	end
	local function v308()
		local TrackedQuestFrame = game.Players.LocalPlayer.PlayerGui:FindFirstChild("TrackedQuestFrame")

		if TrackedQuestFrame then
			local Frame = TrackedQuestFrame:FindFirstChild("Frame")

			if Frame and Frame.Visible then
				local header = Frame:FindFirstChild("header")
				local textLabel = header and header:FindFirstChild("textLabel")

				if textLabel and textLabel:IsA("TextLabel") then
					return tostring(textLabel.Text)
				end
			end
		end

		local Quest = v299("Quest", "Container", "QuestTitle", "Title")

		if Quest then
			return tostring(Quest.Text)
		end

		return ""
	end
	local function v314(p65)
		if not p65 then
			return false
		end

		if not v304("Quest") then
			return false
		end

		local v315 = v308()

		if v315 == "" then
			return false
		end

		return string.find(string.lower(v315), string.lower(p65), 1, true) ~= nil
	end
	local function v316(p66, p67, p68)
		if v314(p68) then
			return true
		end

		local CommF_ = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")

		if not CommF_ then
			return false
		end

		local ok = pcall(function()
			return CommF_:InvokeServer("StartQuest", p66, p67)
		end)

		if not ok then
			return false
		end

		local v320 = os.clock() + 3

		while true do
			if not v314(p68) then
				task.wait(0.25)

				if not (v320 <= os.clock()) then
					continue
				end

				return v314(p68)
			end

			break
		end

		return true
	end

	task.spawn(function()
		while task.wait(Sec) do
			if _G.Level then
				pcall(function()
					local HumanoidRootPart = (plr.Character or plr.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")

					if not HumanoidRootPart then
						return
					end

					local Value = plr.Data.Level.Value
					local v323 = v296()

					v304("Quest")
					v308()

					if not World3 or not (Value >= 2600) or v323 or u290 or u289 then
						if v323 or Value < 2600 or not World3 then
							u289 = true
							u290 = false

							local v324 = QuestNeta()

							if not v324 or not v324[1] then
								task.wait(1)

								return
							end

							local Quest = v304("Quest")

							if Quest then
								Quest = v314(v324[5] or v324[1])
							end

							if v304("Quest") and not Quest then
								replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
								task.wait(0.2)

								return
							end

							if not Quest then
								local v326 = v324[6]

								if v326 then
									_tp(v326)
									task.wait(2)

									if (HumanoidRootPart.Position - v326.Position).Magnitude <= 10 then
										v316(v324[3], v324[2], v324[5] or v324[1])
									end
								else
									v316(v324[3], v324[2], v324[5] or v324[1])
								end

								return
							end

							local v327 = v324[1]
							local v328 = false
							local v329, v330, v331 = pairs(workspace.Enemies:GetChildren())
							local v332 = geniter(v329, v330, v331)
							local exitTo
							local v334

							while true do
								local v335 = table.pack(v332())

								if v335[1] then
									v334 = v335[3]

									if string.find(v334.Name, v327) and t9.Alive(v334) then
										exitTo = 1

										break
									end
								else
									break
								end
							end

							if exitTo == 1 then
								v328 = true

								while true do
									task.wait(Sec)
									_tp(v334.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
									t9.Kill(v334, _G.Level)

									if v304("Quest") then
										if not _G.Level or not v334.Parent or v334.Humanoid.Health <= 0 then
											break
										end
									else
										break
									end
								end
							end

							if not v328 then
								local v336, v337, v338 = pairs(replicated:GetChildren())
								local v339 = geniter(v336, v337, v338)

								while true do
									local v340 = table.pack(v339())

									if v340[1] then
										local v341 = v340[3]

										if string.find(v341.Name, v327) and t9.Alive(v341) then
											v328 = true
											_tp(v341.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))

											break
										end
									else
										break
									end
								end
							end

							if not v328 then
								local v342, v343, v344 = pairs(workspace._WorldOrigin.EnemySpawns:GetChildren())

								for _, v1 in v342, v343, v344 do
									if string.find(v1.Name, v327) then
										_tp(v1.CFrame * CFrame.new(0, 20, 0))

										break
									end
								end
							end
						end
					else
						u290 = true

						local cFrame = CFrame.new(-16269.7041, 25.2288494, 1373.65955)
						local n2 = 0

						while true do
							task.wait(Sec)
							_tp(cFrame)
							n2 += 1

							if not _G.Level then
								break
							elseif (HumanoidRootPart.Position - cFrame.Position).Magnitude <= 8 or n2 > 20 then
								break
							end
						end

						if not _G.Level then
							u290 = false

							return
						end

						task.wait(1)
						pcall(function()
							game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack({ "TravelToSubmergedIsland" }))
						end)

						local now = tick()

						while true do
							task.wait(0.5)

							local v350 = v296()
							local v351 = (HumanoidRootPart.Position - cFrame.Position).Magnitude > 50

							if v350 then
								break
							elseif v351 or not _G.Level or tick() - now > 15 then
								break
							end
						end

						task.wait(2)
						u289 = true
						u290 = false
					end
				end)
			else
				u290 = false
				u289 = false
			end
		end
	end)
end

do
	ClosetMons = GRP_Main_Farming:AddToggle("Auto_Farm_Nearest", {
		Text = "Auto Farm Nearest",
		Default = false,
		Callback = function(p69)
			_G.AutoFarmNear = p69
		end
	})
end

spawn(function()
	while wait() do
		pcall(function()
			if _G.AutoFarmNear then
				for _, child in pairs(workspace.Enemies:GetChildren()) do
					if (child:FindFirstChild("Humanoid") or child:FindFirstChild("HumanoidRootPart")) and child.Humanoid.Health > 0 then
						while true do
							wait()
							t9.Kill(child, _G.AutoFarmNear)

							if not _G.AutoFarmNear then
								break
							elseif not child.Parent or child.Humanoid.Health <= 0 then
								break
							end
						end
					end
				end
			end
		end)
	end
end)

do
	FactoryRaids = GRP_Main_Farming:AddToggle("Auto_Factory_Raid", {
		Text = "Auto Factory Raid",
		Default = false,
		Callback = function(p70)
			_G.AutoFactory = p70
		end
	})
end

spawn(function()
	if wait(Sec) then
		repeat
			pcall(function()
				if _G.AutoFactory then
					local Core = GetConnectionEnemies("Core")

					if Core then
						while true do
							wait()
							EquipWeapon(_G.SelectWeapon)
							_tp(CFrame.new(448.46756, 199.356781, -441.389252))

							if Core.Humanoid.Health <= 0 then
								break
							elseif _G.AutoFactory == false then
								break
							end
						end
					else
						_tp(CFrame.new(448.46756, 199.356781, -441.389252))
					end
				end
			end)
		until not wait(Sec)
	end
end)
CastleRaids = GRP_Main_Farming:AddToggle("Auto_Pirate_Raid", {
	Text = "Auto Pirate Raid",
	Default = false,
	Callback = function(p71)
		_G.AutoRaidCastle = p71
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoRaidCastle then
				local exitTo

				repeat
					pcall(function()
						local cFrame = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-09, 0.380223751, 3.5881019e-08, 1, -1.06665446e-07, -0.380223751, 1.12297109e-07, 0.924894512)

						if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - Root.Position).Magnitude <= 500 then
							for _, child in pairs(workspace.Enemies:GetChildren()) do
								if child:FindFirstChild("HumanoidRootPart") then
									if child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 and child.Name and (child.HumanoidRootPart.Position - Root.Position).Magnitude <= 2000 then
										while true do
											wait()
											t9.Kill(child, _G.AutoRaidCastle)

											if not _G.AutoRaidCastle or not child.Parent or child.Humanoid.Health <= 0 then
												break
											elseif not workspace.Enemies:FindFirstChild(child.Name) then
												break
											end
										end
									end
								end
							end
						else
							local t16 = {
								"Galley Pirate",
								"Galley Captain",
								"Raider",
								"Mercenary",
								"Vampire",
								"Zombie",
								"Snow Trooper",
								"Winter Warrior",
								"Lab Subordinate",
								"Horned Warrior",
								"Magma Ninja",
								"Lava Pirate",
								"Ship Deckhand",
								"Ship Engineer",
								"Ship Steward",
								"Ship Officer",
								"Arctic Warrior",
								"Snow Lurker",
								"Sea Soldier",
								"Water Fighter"
							}

							for i = 1, #t16 do
								if replicated:FindFirstChild(t16[i]) then
									for _, child in pairs(replicated:GetChildren()) do
										if table.find(t16, child.Name) then
											_tp(cFrame)
										end
									end
								end
							end
						end
					end)
					exitTo = nil

					while wait(Sec) do
						if _G.AutoRaidCastle then
							exitTo = 1

							break
						end
					end
				until exitTo ~= 1

				return
			end
		end
	end)
end

Ecto = GRP_Main_Farming:AddToggle("Auto_Farm_Ectoplasm", {
	Text = "Auto Farm Ectoplasm",
	Default = false,
	Callback = function(p72)
		_G.AutoEctoplasm = p72
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.AutoEctoplasm then
				local v363 = GetConnectionEnemies({
					"Ship Deckhand",
					"Ship Engineer",
					"Ship Steward",
					"Ship Officer",
					"Arctic Warrior"
				})

				if t9.Alive(v363) then
					while true do
						wait()
						t9.Kill(v363, _G.AutoEctoplasm)

						if not _G.AutoEctoplasm then
							break
						elseif not v363.Parent or v363.Humanoid.Health <= 0 then
							break
						end
					end
				else
					replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
				end
			end
		end)
	end
end)
GRP_Main_Chest = t15.Main:AddLeftGroupbox("Chest")
ChestTW = GRP_Main_Chest:AddToggle("Auto_Farm_Chest", {
	Text = "Auto Farm Chest",
	Default = false,
	Callback = function(p73)
		_G.AutoFarmChest = p73
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoFarmChest then
				pcall(function()
					local CollectionService = game:GetService("CollectionService")
					local LocalPlayer = game:GetService("Players").LocalPlayer
					local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

					if not Character then
						return
					end

					local Position = Character:GetPivot().Position
					local tagged = CollectionService:GetTagged("_ChestTagged")
					local huge = math.huge
					local v370

					for i = 1, #tagged do
						local v372 = tagged[i]
						local Magnitude = (v372:GetPivot().Position - Position).Magnitude

						if (not SelectedIsland or v372:IsDescendantOf(SelectedIsland)) and not v372:GetAttribute("IsDisabled") and Magnitude < huge then
							huge = Magnitude
							v370 = v372
						end
					end

					if v370 then
						_tp(v370:GetPivot())
					end
				end)
			end
		end
	end)
end

ChestBP = GRP_Main_Chest:AddToggle("Auto_Chest_Bypass", {
	Text = "Auto Chest Bypass",
	Default = false,
	Callback = function(p74)
		_G.AutoChestBP = p74

		if p74 then
			local LocalPlayer = game:GetService("Players").LocalPlayer
			local u375 = false
			local t17 = {}
			local u377 = true

			local function v378()
				if not LocalPlayer.Character then
					LocalPlayer.CharacterAdded:Wait()
				end

				LocalPlayer.Character:WaitForChild("HumanoidRootPart")

				return LocalPlayer.Character
			end
			local function v379()
				if u377 then
					u377 = false

					for _, descendant in pairs(game:GetDescendants()) do
						if descendant.Name:find("Chest") and descendant.ClassName == "Part" then
							table.insert(t17, descendant)
						end
					end
				end

				local t18 = {}

				for _, v1 in pairs(t17) do
					if v1:FindFirstChild("TouchInterest") then
						table.insert(t18, v1)
					end
				end

				local LowerTorso = v378().LowerTorso

				table.sort(t18, function(p75, p76)
					return (LowerTorso.Position - p75.Position).Magnitude < (LowerTorso.Position - p76.Position).Magnitude
				end)

				return t18
			end
			local function v386()
				if u375 then
					return
				end

				u375 = true
				task.spawn(function()
					while _G.AutoChestBP do
						if not LocalPlayer.Character or not LocalPlayer.Character.Parent then
							break
						end

						local v387 = v379()

						if #v387 > 0 then
							v378().HumanoidRootPart.CFrame = v387[1].CFrame
						end

						task.wait(0.1)
					end

					u375 = false
				end)
			end

			LocalPlayer.CharacterAdded:Connect(function()
				v378()
				task.wait(0.5)

				if _G.AutoChestBP then
					v386()
				end
			end)
			v386()
		end
	end
})
StopI = GRP_Main_Chest:AddToggle("Stop_Items", {
	Text = "Stop Items",
	Default = true,
	Callback = function(p77)
		_G.StopWhenChalice = p77
	end
})

do
	spawn(function()
		while wait(0.2) do
			if _G.StopWhenChalice and (_G.AutoFarmChest or _G.AutoChestBP) then
				pcall(function()
					if GetBP("God's Chalice") then
						_G.AutoFarmChest = false
						_G.AutoChestBP = false
					elseif GetBP("Sweet Chalice") or GetBP("Fist of Darkness") then
						_G.AutoFarmChest = false
						_G.AutoChestBP = false

						return
					end
				end)
			end
		end
	end)
end

GRP_Main_Collect_Berry = t15.Main:AddLeftGroupbox("Collect Berry")
Berry = GRP_Main_Collect_Berry:AddToggle("Auto_Farm_Berry", {
	Text = "Auto Farm Berry",
	Default = false,
	Callback = function(p78)
		_G.AutoBerry = p78
	end
})
spawn(function()
	while true do
		if not wait(Sec) then
			return
		elseif _G.AutoBerry then
			break
		end
	end

	while true do
		local CollectionService = game:GetService("CollectionService")
		local LocalPlayer = game:GetService("Players").LocalPlayer
		local tagged = CollectionService:GetTagged("BerryBush")
		local n3 = 1
		local v392 = #tagged
		local H_0_, X_0_, A_0_, exitTo

		if true then
			if n3 <= v392 then
				-- (could not be recovered)
			end

			H_0_ = H_0
			X_0_ = X_0
			A_0_ = A_0
			exitTo = nil

			while wait(Sec) do
				if _G.AutoBerry then
					exitTo = 1

					break
				end
			end

			if exitTo ~= 1 then
				break
			end
		else
			if n3 >= v392 then
				-- (could not be recovered)
			end

			H_0_ = H_0
			X_0_ = X_0
			A_0_ = A_0
			exitTo = nil

			while wait(Sec) do
				if _G.AutoBerry then
					exitTo = 1

					break
				end
			end

			if exitTo ~= 1 then
				break
			end
		end
	end
end)

do
	BerryH = GRP_Main_Collect_Berry:AddToggle("Auto_Farm_Berry_+_Hop", {
		Text = "Auto Farm Berry + Hop",
		Default = false,
		Callback = function(p79)
			_G.AutoBerryH = p79
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoBerryH then
				local CollectionService = game:GetService("CollectionService")
				local LocalPlayer = game:GetService("Players").LocalPlayer
				local tagged = CollectionService:GetTagged("BerryBush")

				if #tagged == 0 then
					local TeleportService_ = game:GetService("TeleportService")
					local t19 = {}
					local ok = pcall(function()
						t19 = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
					end)

					if ok then
						if t19.data then
							for _, v1 in pairs(t19.data) do
								if v1.playing < v1.maxPlayers and v1.id ~= game.JobId then
									TeleportService_:TeleportToPlaceInstance(game.PlaceId, v1.id, LocalPlayer)

									break
								end
							end
						end
					end
				else
					for i = 1, #tagged do
						local v407 = tagged[i]

						for _, v1 in pairs(v407:GetAttributes()) do
							if BerryArray then
								if not table.find(BerryArray, v1) then
									continue
								end
							end

							_tp(v407.Parent:GetPivot())

							for i2 = 1, #tagged do
								for _, child in pairs(tagged[i2]:GetChildren()) do
									if not BerryArray or table.find(BerryArray, child.Name) then
										_tp(child.WorldPivot)
										fireproximityprompt(child.ProximityPrompt, math.huge)
									end
								end
							end
						end
					end
				end
			end
		end
	end)
end

GRP_Main_Farm_Mob = t15.Main:AddLeftGroupbox("Farm Mob")

if World1 then
	GRP_Main_Farm_Mob:AddDropdown("Select_Mob", {
		Text = "Select Mob",
		Values = {
			"Bandit",
			"Monkey",
			"Gorilla",
			"Pirate",
			"Brute",
			"Desert Bandit",
			"Desert Officer",
			"Snow Bandit",
			"Snowman",
			"Chief Petty Officer",
			"Sky Bandit",
			"Dark Master",
			"Toga Warrior",
			"Gladiator",
			"Military Soldier",
			"Military Spy",
			"Fishman Warrior",
			"Fishman Commando",
			"God's Guard",
			"Shanda",
			"Royal Squad",
			"Royal Soldier",
			"Galley Pirate",
			"Galley Captain"
		},
		Default = 1,
		Callback = function(p80)
			getgenv().SelectMob = p80
		end
	})
end

do
	if World2 then
		GRP_Main_Farm_Mob:AddDropdown("Select_Mob", {
			Text = "Select Mob",
			Values = {
				"Raider",
				"Mercenary",
				"Swan Pirate",
				"Factory Staff",
				"Marine Lieutenant",
				"Marine Captain",
				"Zombie",
				"Vampire",
				"Snow Trooper",
				"Winter Warrior",
				"Lab Subordinate",
				"Horned Warrior",
				"Magma Ninja",
				"Lava Pirate",
				"Ship Deckhand",
				"Ship Engineer",
				"Ship Steward",
				"Ship Officer",
				"Arctic Warrior",
				"Snow Lurker",
				"Sea Soldier",
				"Water Fighter"
			},
			Default = 1,
			Callback = function(p81)
				getgenv().SelectMob = p81
			end
		})
	end
end

do
	if World3 then
		GRP_Main_Farm_Mob:AddDropdown("Select_Mob", {
			Text = "Select Mob",
			Values = {
				"Pirate Millionaire",
				"Dragon Crew Warrior",
				"Dragon Crew Archer",
				"Female Islander",
				"Giant Islander",
				"Marine Commodore",
				"Marine Rear Admiral",
				"Fishman Raider",
				"Fishman Captain",
				"Forest Pirate",
				"Mythological Pirate",
				"Jungle Pirate",
				"Musketeer Pirate",
				"Reborn Skeleton",
				"Living Zombie",
				"Demonic Soul",
				"Posessed Mummy",
				"Peanut Scout",
				"Peanut President",
				"Ice Cream Chef",
				"Ice Cream Commander",
				"Cookie Crafter",
				"Cake Guard",
				"Baking Staff",
				"Head Baker",
				"Cocoa Warrior",
				"Chocolate Bar Battler",
				"Sweet Thief",
				"Candy Rebel",
				"Candy Pirate",
				"Snow Demon",
				"Isle Outlaw",
				"Island Boy",
				"Sun-kissed Warrior",
				"Isle Champion"
			},
			Default = 1,
			Callback = function(p82)
				getgenv().SelectMob = p82
			end
		})
	end
end

do
	GRP_Main_Farm_Mob:AddToggle("Auto_Kill_Mob", {
		Text = "Auto Kill Mob",
		Default = false,
		Callback = function(p83)
			_G.AutoKillMob = p83
		end
	})
end

do
	spawn(function()
		while wait() do
			if _G.AutoKillMob then
				local exitTo

				repeat
					pcall(function()
						if game:GetService("Workspace").Enemies:FindFirstChild(getgenv().SelectMob) then
							for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if child.Name == getgenv().SelectMob and child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0 then
									while true do
										game:GetService("RunService").Heartbeat:Wait()
										t9.Kill(child, _G.AutoKillMob)

										if not _G.AutoKillMob then
											break
										elseif not child.Parent or child.Humanoid.Health <= 0 then
											break
										end
									end
								end
							end
						end
					end)
					exitTo = nil

					while wait() do
						if _G.AutoKillMob then
							exitTo = 1

							break
						end
					end
				until exitTo ~= 1

				return
			end
		end
	end)
end

GRP_Main_Farm_All_Island = t15.Main:AddLeftGroupbox("Farm All Island")

do
	local t20 = {
		Pirates = {
			CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929),
			Mobs = { "Bandit" }
		},
		Marine = {
			CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929),
			Mobs = { "Trainee" }
		},
		Jungle = {
			CFrame = CFrame.new(-1600, 36, 150),
			Mobs = {
				"Monkey",
				"Gorilla"
			}
		},
		["Pirate Village"] = {
			CFrame = CFrame.new(-1100, 4, 3850),
			Mobs = {
				"Pirate",
				"Brute"
			}
		},
		Desert = {
			CFrame = CFrame.new(1090, 7, 4370),
			Mobs = {
				"Desert Bandit",
				"Desert Officer"
			}
		},
		["Frozen Village"] = {
			CFrame = CFrame.new(1200, 28, -1500),
			Mobs = {
				"Snow Bandit",
				"Snowman"
			}
		},
		["Marine Fortress"] = {
			CFrame = CFrame.new(-4500, 20, 4250),
			Mobs = { "Chief Petty Officer" }
		},
		["Skylands Lower"] = {
			CFrame = CFrame.new(-5000, 700, -2500),
			Mobs = {
				"Sky Bandit",
				"Dark Master"
			}
		},
		Prison = {
			CFrame = CFrame.new(4875, 6, 735),
			Mobs = {
				"Prisoner",
				"Dangerous Prisoner"
			}
		},
		Colosseum = {
			CFrame = CFrame.new(-1500, 60, -290),
			Mobs = {
				"Toga Warrior",
				"Gladiator"
			}
		},
		["Magma Village"] = {
			CFrame = CFrame.new(-5200, 8, 8400),
			Mobs = {
				"Military Soldier",
				"Military Spy"
			}
		},
		["Underwater City"] = {
			CFrame = CFrame.new(61160, 5, 1819),
			Mobs = {
				"Fishman Warrior",
				"Fishman Commando"
			}
		},
		["Skylands Upper"] = {
			CFrame = CFrame.new(-7880, 5545, -380),
			Mobs = {
				"Shanda",
				"Royal Squad",
				"Royal Soldier"
			}
		}
	}
	local t21 = {
		["Kingdom of Rose"] = {
			CFrame = CFrame.new(-321, 73, 297),
			Mobs = {
				"Raider",
				"Mercenary",
				"Swan Pirate",
				"Factory Staff"
			}
		},
		["Green Zone"] = {
			CFrame = CFrame.new(-2447, 73, -3211),
			Mobs = {
				"Marine Lieutenant",
				"Marine Captain"
			}
		},
		["Graveyard Island"] = {
			CFrame = CFrame.new(-9515, 142, 5536),
			Mobs = {
				"Zombie",
				"Vampire"
			}
		},
		["Snow Mountain"] = {
			CFrame = CFrame.new(561, 401, -5306),
			Mobs = {
				"Snow Trooper",
				"Winter Warrior"
			}
		},
		["Hot and Cold (Cold)"] = {
			CFrame = CFrame.new(-6026, 15, -5062),
			Mobs = {
				"Lab Subordinate",
				"Horned Warrior"
			}
		},
		["Hot and Cold (Hot)"] = {
			CFrame = CFrame.new(-5478, 15, -5240),
			Mobs = {
				"Magma Ninja",
				"Lava Pirate"
			}
		},
		["Cursed Ship"] = {
			CFrame = CFrame.new(902, 126, 33071),
			Mobs = {
				"Ship Deckhand",
				"Ship Engineer",
				"Ship Steward",
				"Ship Officer"
			}
		},
		["Ice Castle"] = {
			CFrame = CFrame.new(6137, 294, -6747),
			Mobs = {
				"Arctic Warrior",
				"Snow Lurker"
			}
		},
		["Forgotten Island"] = {
			CFrame = CFrame.new(-3043, 238, -10191),
			Mobs = {
				"Sea Soldier",
				"Water Fighter"
			}
		}
	}
	local t22 = {
		["Port Town"] = {
			CFrame = CFrame.new(-290, 44, 5450),
			Mobs = {
				"Pirate Millionaire",
				"Pistol Billionaire"
			}
		},
		["Hydra Island"] = {
			CFrame = CFrame.new(5228, 604, 345),
			Mobs = {
				"Dragon Crew Warrior",
				"Dragon Crew Archer",
				"Female Islander",
				"Giant Islander",
				"Training Dummy"
			}
		},
		["Great Tree"] = {
			CFrame = CFrame.new(2682, 1682, -7190),
			Mobs = {
				"Marine Commodore",
				"Marine Rear Admiral"
			}
		},
		["Floating Turtle"] = {
			CFrame = CFrame.new(-12000, 331, -8500),
			Mobs = {
				"Forest Pirate",
				"Mythological Pirate",
				"Jungle Pirate",
				"Musketeer Pirate",
				"Fishman Raider",
				"Fishman Captain"
			}
		},
		["Haunted Castle"] = {
			CFrame = CFrame.new(-9515, 142, 5536),
			Mobs = {
				"Reborn Skeleton",
				"Living Zombie",
				"Demonic Soul",
				"Posessed Mummy"
			}
		},
		["Sea of Treats"] = {
			CFrame = CFrame.new(-1145, 13, -14450),
			Mobs = {
				"Peanut Scout",
				"Peanut President",
				"Ice Cream Commander",
				"Cookie Crafter",
				"Cake Guard",
				"Baking Staff",
				"Head Baker",
				"Cocoa Warrior",
				"Chocolate Bar Battler",
				"Sweet Thief",
				"Candy Rebel"
			}
		},
		["Tiki Outpost"] = {
			CFrame = CFrame.new(-16200, 90, -17300),
			Mobs = {
				"Isle Outlaw",
				"Island Boy",
				"Sun-kissed Warrior",
				"Isle Champion"
			}
		},
		["Submerged Island"] = {
			CFrame = CFrame.new(-3200, -10, -10000),
			Mobs = {
				"Reef Bandit",
				"Coral Pirate",
				"Sea Chanter",
				"Ocean Prophet",
				"High Disciple",
				"Grand Devotee"
			}
		}
	}

	if World1 then
		GRP_Main_Farm_All_Island:AddDropdown("Select_Island", {
			Text = "Select Island",
			Values = {
				"Pirates",
				"Marine",
				"Jungle",
				"Pirate Village",
				"Desert",
				"Frozen Village",
				"Marine Fortress",
				"Skylands Lower",
				"Prison",
				"Colosseum",
				"Magma Village",
				"Underwater City",
				"Skylands Upper"
			},
			Default = 1,
			Callback = function(p84)
				_G.SelectIsland = p84
			end
		})
	end

	if World2 then
		GRP_Main_Farm_All_Island:AddDropdown("Select_Island", {
			Text = "Select Island",
			Values = {
				"Kingdom of Rose",
				"Green Zone",
				"Graveyard Island",
				"Snow Mountain",
				"Hot and Cold (Cold)",
				"Hot and Cold (Hot)",
				"Cursed Ship",
				"Ice Castle",
				"Forgotten Island"
			},
			Default = 1,
			Callback = function(p85)
				_G.SelectIsland = p85
			end
		})
	end

	if World3 then
		GRP_Main_Farm_All_Island:AddDropdown("Select_Island", {
			Text = "Select Island",
			Values = {
				"Port Town",
				"Hydra Island",
				"Great Tree",
				"Floating Turtle",
				"Haunted Castle",
				"Sea of Treats",
				"Tiki Outpost",
				"Submerged Island"
			},
			Default = 1,
			Callback = function(p86)
				_G.SelectIsland = p86
			end
		})
	end

	local v419

	if World1 then
		v419 = t20
	elseif World2 then
		v419 = t21
	elseif World3 then
		v419 = t22
	end

	GRP_Main_Farm_All_Island:AddToggle("Auto_Farm_All_Island", {
		Text = "Auto Farm All Island",
		Default = false,
		Callback = function(p87)
			_G.AutoFarmIsland = p87
		end
	})
	task.spawn(function()
		local v420

		while true do
			if not task.wait(0.2) then
				return
			elseif _G.AutoFarmIsland and _G.SelectIsland and v419 then
				v420 = v419[_G.SelectIsland]

				if v420 then
					break
				end
			end
		end

		local exitTo

		repeat
			local CFrame_ = v420.CFrame
			local t23 = {}

			for _, mob in ipairs(v420.Mobs) do
				t23[mob] = true
			end

			local v426 = false

			for _, child in pairs(workspace.Enemies:GetChildren()) do
				if t23[child.Name] and child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0 then
					v426 = true

					while true do
						task.wait()
						_tp(child.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
						t9.Kill(child, true)

						if not _G.AutoFarmIsland then
							break
						elseif not child.Parent or child.Humanoid.Health <= 0 then
							break
						end
					end
				end
			end

			if not v426 then
				_tp(CFrame_)
			end

			exitTo = nil

			while task.wait(0.2) do
				if _G.AutoFarmIsland and _G.SelectIsland and v419 then
					v420 = v419[_G.SelectIsland]

					if v420 then
						exitTo = 1

						break
					end
				end
			end
		until exitTo ~= 1
	end)
end

GRP_Main_Farm_Elite_Hunter = t15.Main:AddLeftGroupbox("Farm Elite Hunter")

do
	local v429 = GRP_Main_Farm_Elite_Hunter:AddLabel("Elite Progress : 0")

	spawn(function()
		if wait(Sec) then
			repeat
				pcall(function()
					v429:SetText("Elite Progress : " .. replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
				end)
			until not wait(Sec)
		end
	end)
end

do
	local v430 = GRP_Main_Farm_Elite_Hunter:AddLabel("Status: Not Found")

	spawn(function()
		local s12 = ""

		while wait(1) do
			local v432 = (game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban")) and "✅" or "❌"
			local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress")

			if v432 ~= s12 then
				v430:SetText("Status: " .. v432 .. " | Killed: " .. response)
				s12 = v432
			end
		end
	end)
end

EliteQ = GRP_Main_Farm_Elite_Hunter:AddToggle("Auto_Farm_Elite", {
	Text = "Auto Farm Elite",
	Default = false,
	Callback = function(p88)
		_G.FarmEliteHunt = p88
	end
})
spawn(function()
	while wait(1) do
		pcall(function()
			if _G.FarmEliteHunt then
				local Quest = plr.PlayerGui.Main.Quest
				local Text = Quest.Container.QuestTitle.Title.Text

				if Quest.Visible then
					local v436
					local v437, v438, v439 = pairs({
						"Diablo",
						"Urban",
						"Deandre"
					})
					local v440 = geniter(v437, v438, v439)

					while true do
						local v441 = table.pack(v440())

						if v441[1] then
							local v442 = v441[3]

							if string.find(Text, v442) then
								v436 = v442

								break
							end
						else
							break
						end
					end

					if v436 then
						local v443
						local v444, v445, v446 = pairs(replicated:GetChildren())
						local v447 = geniter(v444, v445, v446)

						while true do
							local v448 = table.pack(v447())

							if v448[1] then
								local v449 = v448[3]

								if v449.Name == v436 and v449:FindFirstChild("HumanoidRootPart") then
									v443 = v449

									break
								end
							else
								break
							end
						end

						local v450, v451, v452 = pairs(Enemies:GetChildren())

						for _, v1 in v450, v451, v452 do
							if v1.Name == v436 and t9.Alive(v1) then
								v443 = v1

								break
							end
						end

						if v443 and v443:FindFirstChild("HumanoidRootPart") then
							_tp(v443.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))

							while true do
								wait()
								t9.Kill(v443, _G.FarmEliteHunt)

								if not _G.FarmEliteHunt then
									break
								elseif not v443.Parent or v443.Humanoid.Health <= 0 or not Quest.Visible then
									break
								end
							end
						else
							wait(5)
						end
					else
						replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
					end
				else
					local response = replicated.Remotes.CommF_:InvokeServer("EliteHunter")

					if response == nil or string.find(response, "Cooldown") then
						wait(10)

						return
					end

					task.wait(1)
				end
			end
		end)
	end
end)
EliteH = GRP_Main_Farm_Elite_Hunter:AddToggle("Auto_Farm_Elite_+_Hop", {
	Text = "Auto Farm Elite + Hop",
	Default = false,
	Callback = function(p89)
		_G.FarmEliteH = p89
	end
})

do
	local function v456()
		local HttpService = game:GetService("HttpService")
		local TeleportService_ = game:GetService("TeleportService")
		local s13 = ""
		local v460 = false

		repeat
			local ok, result = pcall(function()
				return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. s13)
			end)

			if ok and result then
				local data = HttpService:JSONDecode(result)

				if data.data then
					for _, v1 in pairs(data.data) do
						if v1.playing < v1.maxPlayers and v1.id ~= game.JobId then
							v460 = true
							TeleportService_:TeleportToPlaceInstance(game.PlaceId, v1.id)

							break
						end
					end

					s13 = data.nextPageCursor or ""
				end
			end
		until not s13 or v460
	end

	spawn(function()
		while task.wait(1) do
			pcall(function()
				if _G.FarmEliteH then
					local Quest = plr.PlayerGui.Main.Quest
					local Text = Quest.Container.QuestTitle.Title.Text

					if Quest.Visible then
						local v468
						local v469, v470, v471 = pairs({
							"Diablo",
							"Urban",
							"Deandre"
						})
						local v472 = geniter(v469, v470, v471)

						while true do
							local v473 = table.pack(v472())

							if v473[1] then
								local v474 = v473[3]

								if string.find(Text, v474) then
									v468 = v474

									break
								end
							else
								break
							end
						end

						if v468 then
							local v475
							local v476, v477, v478 = pairs(replicated:GetChildren())
							local v479 = geniter(v476, v477, v478)

							while true do
								local v480 = table.pack(v479())

								if v480[1] then
									local v481 = v480[3]

									if v481.Name == v468 and v481:FindFirstChild("HumanoidRootPart") then
										v475 = v481

										break
									end
								else
									break
								end
							end

							local v482, v483, v484 = pairs(workspace.Enemies:GetChildren())

							for _, v1 in v482, v483, v484 do
								if v1.Name == v468 then
									if t9.Alive(v1) then
										v475 = v1

										break
									end
								end
							end

							if v475 and v475:FindFirstChild("HumanoidRootPart") then
								_tp(v475.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))

								repeat
									wait()
									t9.Kill(v475, _G.FarmEliteH)

									if not _G.FarmEliteH or not v475.Parent then
										break
									end

									if v475.Humanoid.Health <= 0 then
										break
									end
								until not Quest.Visible
							else
								task.wait(5)
								v456()
							end
						else
							replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
							task.wait(1)
							v456()
						end
					else
						local response = replicated.Remotes.CommF_:InvokeServer("EliteHunter")

						if response == nil or string.find(response, "Cooldown") then
							v456()

							return
						end

						task.wait(1)
					end
				end
			end)
		end
	end)
end

GRP_Main_Farm_Rip_Indra = t15.Main:AddLeftGroupbox("Farm Rip Indra")
GRP_Main_Farm_Rip_Indra:AddToggle("Auto_Attack_Rip_Indra", {
	Text = "Auto Attack Rip Indra",
	Default = false,
	Callback = function(p90)
		_G.AutoRipIngay = p90
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.AutoRipIngay then
					local ripIndra = GetConnectionEnemies("rip_indra")

					if not GetWP("Dark Dagger") or not GetIn("Valkyrie") and ripIndra then
						while true do
							wait()
							t9.Kill(ripIndra, _G.AutoRipIngay)

							if not _G.AutoRipIngay then
								break
							elseif not ripIndra.Parent or ripIndra.Humanoid.Health <= 0 then
								break
							end
						end

						return
					end

					replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5097.93164, 316.447021, -3142.66602, -0.405007899, -4.31682743e-08, 0.914313197, -1.90943332e-08, 1, 3.8755779e-08, -0.914313197, -1.76180437e-09, -0.405007899))
					wait(0.1)
					_tp(CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781))
				end
			end)
		end
	end)
end

GRP_Main_Farm_Rip_Indra:AddToggle("Auto_Unlocked_Haki", {
	Text = "Auto Unlocked Haki",
	Default = false,
	Callback = function(p91)
		_G.AutoUnHaki = p91
	end
})
AuraSkin = function(p92)
	local t24 = { {
		StorageName = p92,
		Type = "AuraSkin",
		Context = "Equip"
	} }

	replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer(unpack(t24))
end
VaildColor = function(p93)
	if p93 and p93.BrickColor then
		return tostring(p93.BrickColor) == "Lime green"
	end
end
HakiCalculate = function(p94)
	local t25 = {
		["Really red"] = "Pure Red",
		Oyster = "Snow White",
		["Hot pink"] = "Winter Sky"
	}

	if p94 then
		if p94.BrickColor then
			return t25[tostring(p94.BrickColor)]
		end
	end
end
spawn(function()
	while wait(Sec) do
		if _G.AutoUnHaki then
			pcall(function()
				local Summoner = workspace.Map["Boat Castle"]:FindFirstChild("Summoner")

				if Summoner and Summoner:FindFirstChild("Circle") then
					local pairs_ = pairs
					local Circle = Summoner:FindFirstChild("Circle")

					for _, child in pairs_(Circle:GetChildren()) do
						if child.Name == "Part" then
							local Part2 = child:FindFirstChild("Part")

							if VaildColor(Part2) == false then
								AuraSkin(HakiCalculate(child))

								while true do
									wait()
									_tp(child.CFrame)

									if VaildColor(Part2) == true then
										break
									elseif not _G.AutoUnHaki then
										break
									end
								end
							end
						end
					end
				end
			end)
		end
	end
end)
GRP_Main_Farming_Cake = t15.Main:AddLeftGroupbox("Farming Cake")

do
	local v497 = GRP_Main_Farming_Cake:AddLabel("")

	spawn(function()
		while wait(0.2) do
			pcall(function()
				local v498 = string.match(replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner"), "%d+")

				if v498 then
					v497:SetText("Killed : " .. (500 - tonumber(v498) or 0))
				end
			end)
		end
	end)
end

Cake = GRP_Main_Farming_Cake:AddToggle("Auto_Farm_Cake_Prince", {
	Text = "Auto Farm Cake Prince",
	Default = false,
	Callback = function(p95)
		_G.Auto_Cake_Prince = p95
	end
})
spawn(function()
	while task.wait() do
		if _G.Auto_Cake_Prince and not _G.AutoRaidCastle then
			local exitTo

			repeat
				pcall(function()
					local LocalPlayer = game.Players.LocalPlayer
					local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local CakeLoaf = workspace.Map:FindFirstChild("CakeLoaf")
					local BigMirror = CakeLoaf and CakeLoaf:FindFirstChild("BigMirror")

					if not HumanoidRootPart then
						return
					end

					if _G.AcceptQuestC and not _G.CheckQuestVisible(LocalPlayer) then
						local cFrame = CFrame.new(-1927.92, 37.8, -12842.54)

						_tp(cFrame)

						while (cFrame.Position - HumanoidRootPart.Position).Magnitude > 50 do
							task.wait(0.2)
						end

						local v505 = math.random(1, 4)
						local t26 = {
							{
								"StartQuest",
								"CakeQuest2",
								2
							},
							{
								"StartQuest",
								"CakeQuest2",
								1
							},
							{
								"StartQuest",
								"CakeQuest1",
								1
							},
							{
								"StartQuest",
								"CakeQuest1",
								2
							}
						}

						pcall(function()
							game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(t26[v505]))
						end)
					end

					if not CakeLoaf then
						_tp(CFrame.new(-2077, 252, -12373))
						task.wait(2)

						return
					end

					if BigMirror and (BigMirror.Other.Transparency == 0 or workspace.Enemies:FindFirstChild("Cake Prince")) then
						local v507 = GetConnectionEnemies("Cake Prince")

						if v507 then
							while true do
								task.wait()
								t9.Kill2(v507, _G.Auto_Cake_Prince)

								if not _G.Auto_Cake_Prince then
									break
								elseif not v507.Parent or v507.Humanoid.Health <= 0 then
									break
								end
							end
						else
							_tp(CFrame.new(-2151.82, 149.32, -12404.91))
						end
					else
						local v508 = GetConnectionEnemies({
							"Cookie Crafter",
							"Cake Guard",
							"Baking Staff",
							"Head Baker"
						})

						if v508 then
							while true do
								task.wait()
								t9.Kill(v508, _G.Auto_Cake_Prince)

								if not _G.Auto_Cake_Prince then
									break
								elseif not v508.Parent or v508.Humanoid.Health <= 0 or BigMirror and BigMirror.Other.Transparency == 0 then
									break
								end
							end
						else
							_tp(CFrame.new(-2077, 252, -12373))
						end
					end
				end)
				exitTo = nil

				while task.wait() do
					if _G.Auto_Cake_Prince and not _G.AutoRaidCastle then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)
CakeQ = GRP_Main_Farming_Cake:AddToggle("Accept_Quests", {
	Text = "Accept Quests",
	Default = false,
	Callback = function(p96)
		_G.AcceptQuestBoss = p96
	end
})
CakeSM = GRP_Main_Farming_Cake:AddToggle("Auto_Summon_Cake_Prince", {
	Text = "Auto Summon Cake Prince",
	Default = false,
	Callback = function(p97)
		_G.AutoSpawnCP = p97
	end
})
spawn(function()
	while task.wait(2) do
		if _G.AutoSpawnCP then
			pcall(function()
				local CommF_ = game.ReplicatedStorage.Remotes.CommF_
				local BigMirror = workspace.Map.CakeLoaf:FindFirstChild("BigMirror")

				if not BigMirror then
					return
				end

				if workspace.Enemies:FindFirstChild("Cake Prince") then
					return
				end

				if BigMirror.Other.Transparency == 0 then
					return
				end

				CommF_:InvokeServer("CakePrinceSpawner", true)
			end)
		end
	end
end)
GRP_Main_Farming_Cake:AddToggle("Auto_Dough_King_[Fully]", {
	Text = "Auto Dough King [Fully]",
	Default = false,
	Callback = function(p98)
		_G.AutoDoughKing = p98
	end
})
spawn(function()
	while wait() do
		if _G.AutoDoughKing then
			pcall(function()
				if workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
					if not workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
						if GetConnectionEnemies("Dough King") then
							local v511 = GetConnectionEnemies("Dough King")

							if v511 then
								while true do
									task.wait()
									t9.Kill(v511, _G.AutoDoughKing)

									if not _G.AutoDoughKing then
										break
									elseif not v511.Parent or v511.Humanoid.Health <= 0 then
										break
									end
								end
							else
								_tp(CFrame.new(-1943.676513671875, 251.50956726074219, -12337.880859375))
							end
						end
					elseif GetBP("Red Key") then
						while true do
							task.wait()
							_tp(CFrame.new(-2681.97998, 64.3921585, -12853.7363, 0.149007782, -1.87902192e-08, 0.98883605, 3.60619588e-08, 1, 1.35681812e-08, -0.98883605, 3.36376011e-08, 0.149007782))

							if not getgenv().AutoDoughKing then
								break
							elseif (plr.Character.HumanoidRootPart.CFrame - CFrame.new(-2681.97998, 64.3921585, -12853.7363, 0.149007782, -1.87902192e-08, 0.98883605, 3.60619588e-08, 1, 1.35681812e-08, -0.98883605, 3.36376011e-08, 0.149007782)).Magnitude <= 5 then
								break
							end
						end

						EquipWeapon("Red Key")
					end
				elseif GetBP("Red Key") then
					replicated.Remotes.CommF_:InvokeServer("CakeScientist", "Check")
					replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Check")
				end

				if GetBP("Sweet Chalice") then
					replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
					_G.AutoAttackDoughKing = true
				else
					_G.AutoAttackDoughKing = false
				end

				if GetBP("God's Chalice") and GetM("Conjured Cocoa") >= 10 then
					replicated.Remotes.CommF_:InvokeServer("SweetChaliceNpc")
				end

				local ok = not plr.Backpack:FindFirstChild("God's Chalice")

				if not ok then
					ok = plr.Character:FindFirstChild("God's Chalice")
				end

				if ok then
					_G.FarmEliteHunt = true
				else
					_G.FarmEliteHunt = false
				end

				if GetM("Conjured Cocoa") <= 10 then
					local v513 = GetConnectionEnemies({
						"Cocoa Warrior",
						"Chocolate Bar Battler"
					})

					if v513 then
						while true do
							task.wait()
							t9.Kill(v513, _G.AutoDoughKing)

							if _G.AutoDoughKing == false then
								break
							elseif not v513.Parent or v513.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(402.71890258789062, 81.060501098632812, -12259.54296875))
					end
				end
			end)
		end
	end
end)

do
	GRP_Main_Farming_Cake:AddToggle("Auto_Farm_Dough_King", {
		Text = "Auto Farm Dough King",
		Default = false,
		Callback = function(p99)
			_G.AutoAttackDoughKing = p99
		end
	})
end

spawn(function()
	while wait() do
		if _G.AutoAttackDoughKing then
			pcall(function()
				local v514 = GetConnectionEnemies("Dough King")

				if v514 then
					while true do
						task.wait()
						t9.Kill(v514, _G.AutoAttackDoughKing)

						if not _G.AutoAttackDoughKing then
							break
						elseif not v514.Parent or v514.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(-1943.6765, 251.5095, -12337.8809))
				end
			end)
		end
	end
end)
GRP_Main_Farming_Cake:AddToggle("Auto_Farm_Dough_King_+_Hop", {
	Text = "Auto Farm Dough King + Hop",
	Default = false,
	Callback = function(p100)
		_G.AutoHop_Dough = p100
	end
})

do
	local function v515()
		pcall(function()
			local HttpService = game:GetService("HttpService")
			local t27 = {}
			local response = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")

			for _, v1 in pairs(HttpService:JSONDecode(response).data) do
				if v1.playing < v1.maxPlayers then
					table.insert(t27, v1.id)
				end
			end

			if #t27 > 0 then
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, t27[math.random(1, #t27)], game.Players.LocalPlayer)
			end
		end)
	end

	spawn(function()
		while task.wait() do
			if _G.AutoHop_Dough then
				pcall(function()
					local v521 = GetConnectionEnemies("Dough King")

					if v521 then
						while true do
							task.wait()
							t9.Kill(v521, _G.AutoHop_Dough)

							if not _G.AutoHop_Dough then
								break
							elseif not v521.Parent or v521.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(-1943.6765, 251.5095, -12337.8809))
						task.wait(2)

						if not GetConnectionEnemies("Dough King") and _G.AutoHop_Dough then
							v515()
						end
					end
				end)
			end
		end
	end)
end

GRP_Main_Farming_Bone = t15.Main:AddLeftGroupbox("Farming Bone")

local v522 = GRP_Main_Farming_Bone:AddLabel("")

spawn(function()
	while wait(1) do
		local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check") or 0

		v522:SetText("You Have: " .. tostring(response) .. " Bones")
		v280:SetText("You Have: " .. tostring(response) .. " Bones")
	end
end)

do
	GRP_Main_Farming_Bone:AddToggle("Auto_Farm_Bone", {
		Text = "Auto Farm Bone",
		Default = false,
		Callback = function(p101)
			_G.AutoFarm_Bone = p101
		end
	})
end

spawn(function()
	local LocalPlayer = game.Players.LocalPlayer
	local t28 = {
		"Reborn Skeleton",
		"Living Zombie",
		"Demonic Soul",
		"Possessed Mummy"
	}

	while wait(0.5) do
		if _G.AutoFarm_Bone then
			pcall(function()
				local Character = LocalPlayer.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart then
					return
				end

				if LocalPlayer.PlayerGui:FindFirstChild("Main") then
					LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
				end

				local v528 = GetConnectionEnemies(t28)

				if _G.AcceptQuestB and not _G.CheckQuestVisible(LocalPlayer) then
					local cFrame = CFrame.new(-9516.99316, 172.01718, 6078.46533)

					_tp(cFrame)

					while true do
						wait(2)

						if not _G.AutoFarm_Bone then
							break
						elseif (cFrame.Position - HumanoidRootPart.Position).Magnitude <= 50 then
							break
						end
					end

					if not _G.AutoFarm_Bone then
						return
					end

					local t29 = {
						{
							"StartQuest",
							"HauntedQuest2",
							2
						},
						{
							"StartQuest",
							"HauntedQuest2",
							1
						},
						{
							"StartQuest",
							"HauntedQuest1",
							1
						},
						{
							"StartQuest",
							"HauntedQuest1",
							2
						}
					}

					game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(t29[math.random(1, #t29)]))
				end

				if v528 then
					while true do
						wait()
						t9.Kill(v528, true)

						if not _G.AutoFarm_Bone then
							break
						elseif not v528.Parent or v528.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
				end
			end)
		end
	end
end)
BoneQ = GRP_Main_Farming_Bone:AddToggle("Accept_Quests", {
	Text = "Accept Quests",
	Default = false,
	Callback = function(p102)
		_G.AcceptQuestBoss = p102
	end
})
GRP_Main_Farming_Bone:AddToggle("Auto_Soul_Reaper", {
	Text = "Auto Soul Reaper",
	Default = false,
	Callback = function(p103)
		_G.AutoHytHallow = p103
	end
})
spawn(function()
	while wait(Sec) do
		if _G.AutoHytHallow then
			local exitTo

			repeat
				pcall(function()
					local v532 = GetConnectionEnemies("Soul Reaper")

					if v532 then
						while true do
							task.wait()
							t9.Kill(v532, _G.AutoHytHallow)

							if v532.Humanoid.Health <= 0 then
								break
							elseif _G.AutoHytHallow == false then
								break
							end
						end
					elseif GetBP("Hallow Essence") then
						while true do
							wait(0.1)
							_tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))

							if _G.AutoHytHallow == false then
								break
							elseif plr.Character.HumanoidRootPart.CFrame == CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125) then
								break
							end
						end

						EquipWeapon("Hallow Essence")
					else
						while true do
							task.wait(0.1)
							replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)

							if _G.AutoHytHallow == false then
								break
							elseif GetBP("Hallow Essence") then
								break
							end
						end
					end
				end)
				exitTo = nil

				while wait(Sec) do
					if _G.AutoHytHallow then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)

do
	RanBone = GRP_Main_Farming_Bone:AddToggle("Auto_Random_Bones", {
		Text = "Auto Random Bones",
		Default = false,
		Callback = function(p104)
			_G.Auto_Random_Bone = p104
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Random_Bone then
				repeat
					task.wait()
					replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
				until not _G.Auto_Random_Bone
			end
		end)
	end
end)

do
	Lucky = GRP_Main_Farming_Bone:AddToggle("Auto_Try_Luck_Gravestone", {
		Text = "Auto Try Luck Gravestone",
		Default = false,
		Callback = function(p105)
			_G.TryLucky = p105
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.TryLucky then
			local cFrame = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)

			if plr.Character.HumanoidRootPart.CFrame ~= cFrame then
				_tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))

				continue
			end

			if plr.Character.HumanoidRootPart.CFrame ~= cFrame then
				continue
			end

			replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 1)
		end
	end
end)
Pray = GRP_Main_Farming_Bone:AddToggle("Auto_Pray_Gravestone", {
	Text = "Auto Pray Gravestone",
	Default = false,
	Callback = function(p106)
		_G.Praying = p106
	end
})
spawn(function()
	while true do
		if not wait(Sec) then
			return
		end

		if _G.Praying then
			local cFrame = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)

			if plr.Character.HumanoidRootPart.CFrame ~= cFrame then
				break
			end

			if plr.Character.HumanoidRootPart.CFrame == cFrame then
				replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
			end
		end
	end

	local exitTo

	repeat
		_tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))
		exitTo = nil

		while wait(Sec) do
			if _G.Praying then
				local cFrame = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)

				if plr.Character.HumanoidRootPart.CFrame ~= cFrame then
					exitTo = 1

					break
				elseif plr.Character.HumanoidRootPart.CFrame == cFrame then
					replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
				end
			end
		end
	until exitTo ~= 1
end)
GRP_Main_Tyrant_of_the_Skies = t15.Main:AddLeftGroupbox("Tyrant of the Skies")

local v537 = GRP_Main_Tyrant_of_the_Skies:AddLabel("Tyrant of the Skies: ")

spawn(function()
	pcall(function()
		while wait(1) do
			if workspace.Enemies:FindFirstChild("Tyrant of the Skies") then
				v537:SetText("Tyrant of the Skies: ✅")
			else
				v537:SetText("Tyrant of the Skies: ❌")
			end
		end
	end)
end)

do
	local v538 = GRP_Main_Tyrant_of_the_Skies:AddLabel("Eyes: 0/4")

	Check_Eye = function()
		local IslandModel = workspace.Map.TikiOutpost.IslandModel
		local n4 = 0

		for _, v1 in ipairs({
			IslandModel.Eye1,
			IslandModel.Eye2,
			IslandModel.IslandChunks.E.Eye3,
			IslandModel.IslandChunks.E.Eye4
		}) do
			if v1 and v1.Transparency ~= 1 then
				n4 += 1
			end
		end

		return n4, n4 == 4
	end
	task.spawn(function()
		local v543 = false

		while task.wait(1) do
			local v544, v545 = Check_Eye()

			v538:SetText("Eyes: " .. v544 .. "/4")

			if not v545 or v543 then
				if not v545 then
					v543 = false
				end
			else
				v543 = true
			end
		end
	end)
end

do
	FarmTyrant = GRP_Main_Tyrant_of_the_Skies:AddToggle("Auto_Farm_Boss_TOTS", {
		Text = "Auto Farm Boss TOTS",
		Default = false,
		Callback = function(p107)
			_G.FarmTyrant = p107
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.FarmTyrant then
				pcall(function()
					if not plr.Character then
						return
					end

					local HumanoidRootPart = plr.Character:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart then
						return
					end

					local vector3 = Vector3.new(-16268.287, 152.616, 1390.773)

					if (HumanoidRootPart.Position - vector3).Magnitude > 5 then
						_tp(CFrame.new(vector3))

						while true do
							wait()

							if not _G.FarmTyrant then
								break
							end

							if not plr.Character then
								continue
							elseif not plr.Character:FindFirstChild("HumanoidRootPart") or not ((plr.Character.HumanoidRootPart.Position - vector3).Magnitude <= 5) then
								continue
							end

							break
						end
					end

					local TyrantOfTheSkies = workspace.Enemies:FindFirstChild("Tyrant of the Skies")

					if TyrantOfTheSkies and TyrantOfTheSkies:FindFirstChild("Humanoid") and TyrantOfTheSkies.Humanoid.Health > 0 then
						while _G.FarmTyrant do
							if t9 and t9.Kill then
								t9.Kill(TyrantOfTheSkies, _G.FarmTyrant)
							end

							wait()

							if not _G.FarmTyrant or not TyrantOfTheSkies.Parent or TyrantOfTheSkies.Humanoid.Health <= 0 then
								break
							end
						end

						return
					end

					for _, v1 in ipairs({
						"Serpent Hunter",
						"Skull Slayer",
						"Isle Champion",
						"Sun-kissed Warrior"
					}) do
						if not _G.FarmTyrant then
							break
						end

						for _, child in pairs(workspace.Enemies:GetChildren()) do
							if not _G.FarmTyrant then
								break
							end

							if child and child.Name == v1 and child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 then
								if (HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude > 5000 then
									_tp(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))

									local now = tick()

									repeat
										wait()
										HumanoidRootPart = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
									until not _G.FarmTyrant or not HumanoidRootPart or (HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude <= 6 or tick() - now > 8
								end

								while _G.FarmTyrant do
									if t9 and t9.Kill then
										t9.Kill(child, _G.FarmTyrant)
									end

									wait()

									if not _G.FarmTyrant or not child.Parent or child.Humanoid.Health <= 0 then
										break
									end
								end
							end
						end
					end
				end)
			end
		end
	end)
end

FarmPhaBinh = GRP_Main_Tyrant_of_the_Skies:AddToggle("Auto_Summon_Boss", {
	Text = "Auto Summon Boss",
	Default = false,
	Callback = function(p108)
		_G.FarmPhaBinh = p108
	end
})

do
	local function v554(p109)
		local VirtualInputManager = game:GetService("VirtualInputManager")

		VirtualInputManager:SendKeyEvent(true, p109, true, game)
		wait(0.05)
		VirtualInputManager:SendKeyEvent(false, p109, true, game)
	end
	local function v556(p110)
		if not plr.Character or not plr.Character:FindFirstChild("Humanoid") or not (plr.Character.Humanoid.Health > 0) then
			return
		end

		for _, child in pairs(plr.Backpack:GetChildren()) do
			if child:IsA("Tool") and child.ToolTip == p110 then
				child.Parent = plr.Character
				wait(0.12)

				for _, v1 in ipairs({
					"Z",
					"X",
					"C",
					"V",
					"F"
				}) do
					if not _G.FarmPhaBinh then
						break
					end

					pcall(function()
						v554(v1)
					end)
					wait(0.12)
				end

				child.Parent = plr.Backpack

				return
			end
		end
	end

	local t30 = {
		CFrame.new(-16332.5263671875, 158.07200622558594, 1440.324951171875),
		CFrame.new(-16288.609375, 158.16700744628906, 1470.3680419921875),
		CFrame.new(-16245.412109375, 158.43699645996094, 1463.365966796875),
		CFrame.new(-16212.46875, 158.16700744628906, 1466.343994140625),
		CFrame.new(-16211.9462890625, 158.07200622558594, 1322.39794921875),
		CFrame.new(-16260.921875, 154.92100524902344, 1323.615966796875),
		CFrame.new(-16297.0595703125, 159.322998046875, 1317.2239990234375),
		CFrame.new(-16335.0966796875, 159.33399963378906, 1324.885986328125)
	}

	spawn(function()
		while wait(Sec) do
			if _G.FarmPhaBinh then
				pcall(function()
					if plr and plr.Character then
						if plr.Character:FindFirstChild("HumanoidRootPart") then
							if plr.Character:FindFirstChild("Humanoid") then
								if plr.Character.Humanoid.Health > 0 then
									for _, v1 in ipairs(t30) do
										if not _G.FarmPhaBinh then
											break
										end

										_tp(v1)

										local v564 = false
										local now = tick()

										while tick() - now < 12 and _G.FarmPhaBinh do
											local HumanoidRootPart = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

											if not HumanoidRootPart then
												break
											end

											if not ((HumanoidRootPart.Position - v1.Position).Magnitude <= 3) then
												wait(0.1)

												continue
											end

											v564 = true

											break
										end

										if _G.FarmPhaBinh and v564 then
											v556("Melee")
											v556("Sword")
											v556("Gun")
										end
									end

									return
								end
							end
						end
					end
				end)
			end
		end
	end)
end

GRP_Main_Farm_Material = t15.Main:AddLeftGroupbox("Farm Material")
Test = GRP_Main_Farm_Material:AddDropdown("Choose_Material", {
	Text = "Choose Material",
	Values = MaterialList,
	Default = 1,
	Callback = function(p111)
		getgenv().SelectMaterial = p111
	end
})
Toggle = GRP_Main_Farm_Material:AddToggle("Auto_Farm_Materials", {
	Text = "Auto Farm Materials",
	Default = false,
	Callback = function(p112)
		getgenv().AutoMaterial = p112
	end
})
spawn(function()
	local function v567(p113, p114)
		if p113:FindFirstChild("Humanoid") and p113:FindFirstChild("HumanoidRootPart") and p113.Humanoid.Health > 0 and p113.Name == p114 then
			while true do
				wait()
				t9.Kill(p113, getgenv().AutoMaterial)

				if not getgenv().AutoMaterial then
					break
				elseif not p113.Parent or p113.Humanoid.Health <= 0 then
					break
				end
			end
		end
	end
	local function v568()
		for _, child in pairs(game:GetService("Workspace")._WorldOrigin.EnemySpawns:GetChildren()) do
			for _, v1 in ipairs(MMon) do
				if string.find(child.Name, v1) and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - child.Position).Magnitude >= 10 then
					_tp(child.CFrame * Pos)
				end
			end
		end
	end

	while wait() do
		if getgenv().AutoMaterial then
			local exitTo

			repeat
				pcall(function()
					if getgenv().SelectMaterial then
						MaterialMon(getgenv().SelectMaterial)
						_tp(MPos)
					end

					for _, v1 in ipairs(MMon) do
						for _, child in pairs(workspace.Enemies:GetChildren()) do
							v567(child, v1)
						end
					end

					v568()
				end)
				exitTo = nil

				while wait() do
					if getgenv().AutoMaterial then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)
GRP_Main_Farm_Boss = t15.Main:AddLeftGroupbox("Farm Boss")
BossDropdown = GRP_Main_Farm_Boss:AddDropdown("Select_Boss", {
	Text = "Select Boss",
	Values = BossList,
	Default = 1,
	Callback = function(p115)
		_G.FindBoss = p115
	end
})

do
	FarmBoss = GRP_Main_Farm_Boss:AddToggle("Auto_Farm_Boss", {
		Text = "Auto Farm Boss",
		Default = false,
		Callback = function(p116)
			_G.FarmBoss = p116
			spawn(function()
				while wait(Sec) do
					if _G.FarmBoss then
						local exitTo

						repeat
							pcall(function()
								local v579 = QuestBeta()[2] ~= nil and QuestBeta()[3] ~= nil
								local Text = plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text

								if _G.AcceptQuestBoss and v579 then
									if not string.find(Text, QuestBeta()[0]) then
										replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
									end

									if plr.PlayerGui.Main.Quest.Visible == false then
										_tp(QuestBeta()[5])

										if (Root.Position - QuestBeta()[5].Position).Magnitude <= 5 then
											replicated.Remotes.CommF_:InvokeServer("StartQuest", QuestBeta()[3], QuestBeta()[2])
										end
									elseif plr.PlayerGui.Main.Quest.Visible == true then
										if workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
											for _, child in pairs(workspace.Enemies:GetChildren()) do
												if t9.Alive(child) then
													if child.Name == QuestBeta()[1] then
														if string.find(Text, QuestBeta()[0]) then
															while true do
																wait()
																t9.Kill(child, _G.FarmBoss)

																if not _G.FarmBoss then
																	break
																elseif child.Humanoid.Health <= 0 or not child.Parent or plr.PlayerGui.Main.Quest.Visible == false then
																	break
																end
															end
														else
															replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
														end
													end
												end
											end
										else
											_tp(QuestBeta()[4])

											if replicated:FindFirstChild(QuestBeta()[1]) then
												_tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
											end
										end
									end
								elseif workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
									for _, child in pairs(workspace.Enemies:GetChildren()) do
										if t9.Alive(child) and child.Name == QuestBeta()[1] then
											while true do
												wait()
												t9.Kill(child, _G.FarmBoss)

												if not _G.FarmBoss then
													break
												elseif child.Humanoid.Health <= 0 or not child.Parent then
													break
												end
											end
										end
									end
								else
									_tp(QuestBeta()[4])

									if replicated:FindFirstChild(QuestBeta()[1]) then
										_tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									end
								end
							end)
							exitTo = nil

							while wait(Sec) do
								if _G.FarmBoss then
									exitTo = 1

									break
								end
							end
						until exitTo ~= 1

						return
					end
				end
			end)
		end
	})
end

do
	BossQ = GRP_Main_Farm_Boss:AddToggle("Accept_Quests", {
		Text = "Accept Quests",
		Default = true,
		Callback = function(p117)
			_G.AcceptQuestBoss = p117
		end
	})
end

do
	FarmAllBoss = GRP_Main_Farm_Boss:AddToggle("Auto_Farm_All_Boss", {
		Text = "Auto Farm All Boss",
		Default = false,
		Callback = function(p118)
			_G.AutoFarmAllBoss = p118
		end
	})
end

task.spawn(function()
	while task.wait(0.3) do
		if _G.AutoFarmAllBoss then
			local exitTo

			repeat
				pcall(function()
					local LocalPlayer = game.Players.LocalPlayer

					if LocalPlayer.Character then
						if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
							local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
							local v588
							local huge = math.huge

							for _, child in pairs(workspace.Enemies:GetChildren()) do
								if child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 and table.find(BossList, child.Name) then
									local Magnitude = (HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude

									if Magnitude < huge then
										v588 = child
										huge = Magnitude
									end
								end
							end

							if v588 and v588:FindFirstChild("HumanoidRootPart") then
								local HumanoidRootPart2 = v588.HumanoidRootPart
								local Humanoid = v588.Humanoid

								while true do
									task.wait(0.1)

									if _G.AutoFarmAllBoss then
										local v595 = HumanoidRootPart2.CFrame * CFrame.new(0, 5, 0)

										if (HumanoidRootPart.Position - v595.Position).Magnitude > 100 then
											LocalPlayer.Character:PivotTo(v595)
										else
											_tp(v595)
										end

										if t9 and typeof(t9.Kill) == "function" then
											t9.Kill(v588, true)
										end

										if not v588.Parent or Humanoid.Health <= 0 or not _G.AutoFarmAllBoss then
											break
										end
									else
										break
									end
								end
							end

							return
						end
					end
				end)
				exitTo = nil

				while task.wait(0.3) do
					if _G.AutoFarmAllBoss then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)
_G.MasteryHealthPct = 70
_G.SelectedMasterySkills = {
	Z = true,
	X = true,
	C = true,
	V = true,
	F = true
}

do
	local v596 = t15.Main:AddLeftGroupbox("Farming Mastery")
	local s14 = "Cake"

	v596:AddDropdown("Choose_Island", {
		Text = "Choose Island",
		Values = {
			"Cake",
			"Bone"
		},
		Default = 1,
		Callback = function(p119)
			s14 = p119
		end
	})
	v596:AddSlider({
		Text = "NPC Health % Switch to Weapon",
		Min = 10,
		Max = 95,
		Default = 70,
		Rounding = 1,
		Callback = function(p120)
			_G.MasteryHealthPct = p120
		end
	})
	v596:AddDropdown("Select_Skills", {
		Text = "Select Skills to Use",
		Values = {
			"Z",
			"X",
			"C",
			"V",
			"F",
			"Y"
		},
		Multi = true,
		Default = {
			Z = true,
			X = true,
			C = true,
			V = true,
			F = true
		},
		Callback = function(p121, p122)
			if type(p121) == "table" then
				_G.SelectedMasterySkills = p121
			elseif type(p121) == "string" then
				if type(_G.SelectedMasterySkills) ~= "table" then
					_G.SelectedMasterySkills = {}
				end

				_G.SelectedMasterySkills[p121] = p122 and true or nil
			end
		end
	})
	v596:AddToggle("Auto_Mastery_Fruits", {
		Text = "Auto Mastery Fruits",
		Default = false,
		Callback = function(p123)
			_G.FarmMastery_Dev = p123
		end
	})
	spawn(function()
		RunSer.RenderStepped:Connect(function()
			pcall(function()
				if _G.FarmMastery_Dev or _G.FarmMastery_G or _G.FarmMastery_S then
					for _, child in pairs(plr.PlayerGui.Notifications:GetChildren()) do
						if child.Name == "NotificationTemplate" and string.find(child.Text, "Skill locked!") then
							child:Destroy()
						end
					end
				end
			end)
		end)
	end)
	spawn(function()
		while wait(Sec) do
			if _G.FarmMastery_Dev then
				pcall(function()
					if s14 == "Cake" then
						local v600 = GetConnectionEnemies(t5)

						if v600 then
							while true do
								wait()
								HealthM = v600.Humanoid.MaxHealth * (_G.MasteryHealthPct / 100)
								MousePos = v600.HumanoidRootPart.Position
								t9.Mas(v600, _G.FarmMastery_Dev)

								if _G.FarmMastery_Dev == false then
									break
								elseif v600.Humanoid.Health <= 0 or not v600.Parent then
									break
								end
							end
						else
							_tp(CFrame.new(-1943.676513671875, 251.50956726074219, -12337.880859375))
						end
					elseif s14 == "Bone" then
						local v601 = GetConnectionEnemies(t6)

						if v601 then
							while true do
								wait()
								HealthM = v601.Humanoid.MaxHealth * (_G.MasteryHealthPct / 100)
								MousePos = v601.HumanoidRootPart.Position
								t9.Mas(v601, _G.FarmMastery_Dev)

								if _G.FarmMastery_Dev == false or v601.Humanoid.Health <= 0 then
									break
								elseif not v601.Parent then
									break
								end
							end
						else
							_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
						end
					end
				end)
			end
		end
	end)
	v596:AddToggle("Auto_Mastery_Gun", {
		Text = "Auto Mastery Gun",
		Default = false,
		Callback = function(p124)
			_G.FarmMastery_G = p124
		end
	})
	spawn(function()
		while wait(Sec) do
			if _G.FarmMastery_G then
				pcall(function()
					if s14 == "Cake" then
						local v602 = GetConnectionEnemies(t5)

						if v602 then
							HealthM = v602.Humanoid.MaxHealth * _G.MasteryHealthPct / 100

							repeat
								wait()
								MousePos = v602.HumanoidRootPart.Position
								t9.Masgun(v602, _G.FarmMastery_G)

								local REShootGunEvent = replicated:FindFirstChild("Modules"):FindFirstChild("Net"):FindFirstChild("RE/ShootGunEvent")

								if plr.Character:FindFirstChildOfClass("Tool").ToolTip ~= "Gun" then
									return
								end

								local Character, Character2

								if not plr.Character:FindFirstChildOfClass("Tool") then
									Character = plr.Character

									if Character:FindFirstChildOfClass("Tool") then
										Character2 = plr.Character

										if Character2:FindFirstChildOfClass("Tool").Name ~= "Skull Guitar" then
											SoulGuitar = false
											REShootGunEvent:FireServer(MousePos, { v602.HumanoidRootPart })

											if _G.FarmMastery_G then
												vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
												wait(0.05)
												vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
												wait(0.05)
											end
										end
									end
								elseif plr.Character:FindFirstChildOfClass("Tool").Name == "Skull Guitar" then
									SoulGuitar = true
									plr.Character:FindFirstChildOfClass("Tool").RemoteEvent:FireServer("TAP", MousePos)

									if _G.FarmMastery_G then
										vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
										wait(0.05)
										vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
										wait(0.05)
									end
								else
									Character = plr.Character

									if Character:FindFirstChildOfClass("Tool") then
										Character2 = plr.Character

										if Character2:FindFirstChildOfClass("Tool").Name ~= "Skull Guitar" then
											SoulGuitar = false
											REShootGunEvent:FireServer(MousePos, { v602.HumanoidRootPart })

											if _G.FarmMastery_G then
												vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
												wait(0.05)
												vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
												wait(0.05)
											end
										end
									end

									if _G.FarmMastery_G == false or v602.Humanoid.Health <= 0 or not v602.Parent then
										break
									end
								end
							until _G.FarmMastery_G == false or v602.Humanoid.Health <= 0 or not v602.Parent

							SoulGuitar = false
						else
							_tp(CFrame.new(-1943.676513671875, 251.50956726074219, -12337.880859375))
						end
					elseif s14 == "Bone" then
						local v606 = GetConnectionEnemies(t6)

						if v606 then
							HealthM = v606.Humanoid.MaxHealth * _G.MasteryHealthPct / 100

							repeat
								wait()
								MousePos = v606.HumanoidRootPart.Position
								t9.Masgun(v606, _G.FarmMastery_G)

								local REShootGunEvent = replicated:FindFirstChild("Modules"):FindFirstChild("Net"):FindFirstChild("RE/ShootGunEvent")

								if plr.Character:FindFirstChildOfClass("Tool").ToolTip ~= "Gun" then
									return
								end

								local Character, Character2

								if not plr.Character:FindFirstChildOfClass("Tool") then
									Character = plr.Character

									if Character:FindFirstChildOfClass("Tool") then
										Character2 = plr.Character

										if Character2:FindFirstChildOfClass("Tool").Name ~= "Skull Guitar" then
											SoulGuitar = false
											REShootGunEvent:FireServer(MousePos, { v606.HumanoidRootPart })

											if _G.FarmMastery_G then
												vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
												wait(0.05)
												vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
												wait(0.05)
											end
										end
									end
								elseif plr.Character:FindFirstChildOfClass("Tool").Name == "Skull Guitar" then
									SoulGuitar = true
									plr.Character:FindFirstChildOfClass("Tool").RemoteEvent:FireServer("TAP", MousePos)

									if _G.FarmMastery_G then
										vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
										wait(0.05)
										vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
										wait(0.05)
									end
								else
									Character = plr.Character

									if Character:FindFirstChildOfClass("Tool") then
										Character2 = plr.Character

										if Character2:FindFirstChildOfClass("Tool").Name ~= "Skull Guitar" then
											SoulGuitar = false
											REShootGunEvent:FireServer(MousePos, { v606.HumanoidRootPart })

											if _G.FarmMastery_G then
												vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
												wait(0.05)
												vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
												wait(0.05)
											end
										end
									end

									if _G.FarmMastery_G == false or v606.Humanoid.Health <= 0 or not v606.Parent then
										break
									end
								end
							until _G.FarmMastery_G == false or v606.Humanoid.Health <= 0 or not v606.Parent

							SoulGuitar = false
						else
							_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
						end
					end
				end)
			end
		end
	end)
	v596:AddToggle("Auto_Mastery_All_Sword", {
		Text = "Auto Mastery All Sword",
		Default = false,
		Callback = function(p125)
			_G.FarmMastery_S = p125
		end
	})
	spawn(function()
		if wait(Sec) then
			repeat
				pcall(function()
					if _G.FarmMastery_S then
						if s14 == "Cake" then
							local next_ = next
							local response, v612 = replicated.Remotes.CommF_:InvokeServer("getInventory")
							local exitTo
							local v614

							for _, v1 in next_, response, v612 do
								if type(v1) == "table" and v1.Type == "Sword" then
									v614 = v1
									exitTo = 1

									break
								end
							end

							if exitTo == 1 then
								SwordName = v614.Name

								if tonumber(v614.Mastery) >= 1 or tonumber(v614.Mastery) <= 599 then
									local v617 = GetConnectionEnemies(t5)

									if not GetBP(SwordName) then
										replicated.Remotes.CommF_:InvokeServer("LoadItem", SwordName)
									elseif v617 then
										while true do
											wait()
											t9.Sword(v617, _G.FarmMastery_S)

											if _G.FarmMastery_S == false then
												break
											elseif not v617.Parent or v617.Humanoid.Health <= 0 then
												break
											end
										end
									else
										_tp(CFrame.new(-1943.676513671875, 251.50956726074219, -12337.880859375))
									end
								elseif tonumber(v614.Mastery) >= 600 then
									if GetBP(SwordName) then
										return nil
									end

									replicated.Remotes.CommF_:InvokeServer("LoadItem", SwordName)
								end
							end
						elseif s14 == "Bone" then
							local next_ = next
							local response, v620 = replicated.Remotes.CommF_:InvokeServer("getInventory")
							local exitTo2
							local v622

							for _, v1 in next_, response, v620 do
								if type(v1) == "table" and v1.Type == "Sword" then
									v622 = v1
									exitTo2 = 1

									break
								end
							end

							if exitTo2 == 1 then
								SwordName = v622.Name

								if tonumber(v622.Mastery) >= 1 or tonumber(v622.Mastery) <= 599 then
									local v625 = GetConnectionEnemies(t6)

									if not GetBP(SwordName) then
										replicated.Remotes.CommF_:InvokeServer("LoadItem", SwordName)
									elseif v625 then
										while true do
											wait()
											t9.Sword(v625, _G.FarmMastery_S)

											if _G.FarmMastery_S == false then
												break
											elseif not v625.Parent or v625.Humanoid.Health <= 0 then
												break
											end
										end
									else
										_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
									end
								elseif tonumber(v622.Mastery) >= 600 then
									if GetBP(SwordName) then
										return nil
									end

									replicated.Remotes.CommF_:InvokeServer("LoadItem", SwordName)
								end
							end
						end
					end
				end)
			until not wait(Sec)
		end
	end)
end

do
	local MagnetEvent26 = require(game.ReplicatedStorage.EventConfig.MagnetEvent26)

	local function v627()
		local serverTimeNow = workspace:GetServerTimeNow()

		return MagnetEvent26.ENABLED and serverTimeNow >= MagnetEvent26.START_AT._Value and serverTimeNow < MagnetEvent26.NO_MORE_GAMEPLAY_AT._Value
	end
end

GRP_Main_Update_30_Magnet_Token = t15.Main:AddLeftGroupbox("Update 30 / Magnet Token")

do
	local v629 = GRP_Main_Update_30_Magnet_Token:AddLabel("Loading...")
	local Idle = GRP_Main_Update_30_Magnet_Token:AddLabel("Idle")

	local function v631(p126)
		Idle:SetText(p126)
	end

	task.spawn(function()
		if task.wait(1) then
			repeat
				pcall(function()
					local now = os.time()
					local v633 = os.date("*t", now)
					local min = v633.min
					local sec = v633.sec
					local v636 = min >= 0 and min < 10
					local v637 = false

					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if child:IsA("Model") and (child:GetAttribute("MagnetEnemy") == true or string.find(string.lower(child.Name), "magnetized")) then
							v637 = true

							break
						end
					end

					local s15 = "🔴"
					local v641

					if v637 then
						local s16 = "🟢"
						local v643 = (10 - min) * 60 - sec

						if v643 < 0 then
							v643 = 0
						end

						v641 = string.format("%s ACTIVE - Time Left: %02d:%02d (✅ Enemies Found)", s16, math.floor(v643 / 60), v643 % 60)
					elseif v636 then
						local s17 = "🟢"
						local v645 = (10 - min) * 60 - sec

						if v645 < 0 then
							v645 = 0
						end

						v641 = string.format("%s ACTIVE - Time Left: %02d:%02d", s17, math.floor(v645 / 60), v645 % 60)
					else
						local v646 = (60 - min) * 60 - sec

						if v646 <= 0 then
							v646 = 0
						end

						v641 = string.format("%s INACTIVE - Next Event: %02d:%02d", s15, math.floor(v646 / 60), v646 % 60)
					end

					v629:SetText(v641)
				end)
			until not task.wait(1)
		end
	end)
	_G.MagnetEventSpawnIndex = _G.MagnetEventSpawnIndex or 1

	local t31 = {
		sky = true,
		skyarea2 = true,
		uppersky = true,
		["upper sky"] = true,
		["underwater city"] = true,
		["fishman island"] = true,
		sewers = true,
		["sewer gangs"] = true
	}
	local t32 = {}

	local function v649(p127)
		if not p127 then
			return
		end

		if p127:IsA("BasePart") then
			return p127.Position
		end

		local ok, result = pcall(function()
			return p127:GetPivot()
		end)
		local Position = ok and typeof(result) == "CFrame" and result.Position or nil

		return Position
	end
	local function v653(p128)
		local Locations = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("Locations")

		if not Locations then
			return "unknown"
		end

		local Name
		local v656

		for _, child in ipairs(Locations:GetChildren()) do
			if child:IsA("BasePart") then
				local Magnitude = (child.Position - p128).Magnitude

				if not Name or Magnitude < v656 then
					Name = child.Name
					v656 = Magnitude
				end
			end
		end

		return Name and string.lower(Name) or "unknown"
	end
	local function v660(p129, p130)
		local v661 = string.lower(tostring(p130 or ""))
		local v662 = string.lower(tostring(p129.Name or ""))
		local v663 = string.lower(tostring(p129:GetAttribute("DisplayName") or ""))
		local v664 = v662 .. " " .. v663

		if t31[v661] or v661:find("fishman", 1, true) or v661:find("underwater", 1, true) or v661:find("sewer", 1, true) or v664:find("boss", 1, true) then
			return true
		end

		return t32[v662] or t32[v663]
	end
	local function v665()
		local t33 = {}
		local t34 = {}
		local _WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
		local EnemySpawns = _WorldOrigin and _WorldOrigin:FindFirstChild("EnemySpawns")

		if not EnemySpawns then
			return t33
		end

		for _, child in ipairs(EnemySpawns:GetChildren()) do
			local v672 = v649(child)

			if v672 then
				local v673 = v653(v672)
				local v674 = tostring(child:GetAttribute("DisplayName") or child.Name or "")

				if v674 ~= "" and not v660(child, v673) then
					t34[v673] = t34[v673] or {}
					t34[v673][v674] = t34[v673][v674] or {}
					t34[v673][v674][#t34[v673][v674] + 1] = v672
				end
			end
		end

		local t35 = {}

		for k in pairs(t34) do
			t35[#t35 + 1] = k
		end

		table.sort(t35)

		for _, v1 in ipairs(t35) do
			local v679 = t34[v1]
			local t36 = {}

			for k in pairs(v679) do
				t36[#t36 + 1] = k
			end

			table.sort(t36)

			local Position
			local Locations = _WorldOrigin and _WorldOrigin:FindFirstChild("Locations")

			if Locations then
				for _, child in ipairs(Locations:GetChildren()) do
					if child:IsA("BasePart") and string.lower(child.Name) == v1 then
						Position = child.Position

						break
					end
				end
			end

			for _, v2 in ipairs(t36) do
				local v688 = v679[v2][1]

				if #t36 > 1 then
					t33[#t33 + 1] = {
						Island = v1,
						Name = v2,
						CFrame = CFrame.new(v688 + Vector3.new(0, 40, 0))
					}
				else
					local vector3 = Vector3.new(1, 0, 0)

					if Position then
						local vector32 = Vector3.new(v688.X - Position.X, 0, v688.Z - Position.Z)

						if vector32.Magnitude > 0.01 then
							vector3 = vector32.Unit
						end
					end

					t33[#t33 + 1] = {
						Island = v1,
						Name = v2,
						CFrame = CFrame.new(v688 + vector3 * 60 + Vector3.new(0, 40, 0))
					}
					t33[#t33 + 1] = {
						Island = v1,
						Name = v2,
						CFrame = CFrame.new(v688 - vector3 * 60 + Vector3.new(0, 40, 0))
					}
				end
			end
		end

		return t33
	end
	local function v691()
		local Enemies_ = workspace:FindFirstChild("Enemies")

		if not Enemies_ then
			return
		end

		local Character = game.Players.LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		local v695
		local v696

		for _, child in ipairs(Enemies_:GetChildren()) do
			if child:IsA("Model") and (child:GetAttribute("MagnetEnemy") == true or string.find(string.lower(child.Name), "magnetized")) and child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 and child:FindFirstChild("HumanoidRootPart") then
				local Magnitude = HumanoidRootPart and (child.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude or 0

				if not v695 or Magnitude < v696 then
					v695 = child
					v696 = Magnitude
				end
			end
		end

		return v695
	end
	local function v700(p131)
		if not p131 or typeof(p131.CFrame) ~= "CFrame" then
			return false
		end

		local LocalPlayer = game.Players.LocalPlayer
		local Character = LocalPlayer.Character

		if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
			return false
		end

		v631("Patrolling - " .. tostring(p131.Island))
		pcall(function()
			_tp(p131.CFrame)
		end)

		local now = tick()
		local exitTo2
		local v705

		while true do
			if not _G.AutoMagnetToken then
				exitTo2 = 1

				break
			end

			v705 = v691()

			if v705 then
				break
			end

			local Character2 = LocalPlayer.Character
			local HumanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				if not ((p131.CFrame.Position - HumanoidRootPart.Position).Magnitude <= 15) and not (tick() - now > 10) then
					task.wait(0.1)

					continue
				end

				exitTo2 = 1

				break
			end

			exitTo2 = 2

			break
		end

		if exitTo2 ~= 1 then
			if exitTo2 == 2 then
				return false
			end

			return v705
		end

		if not _G.AutoMagnetToken then
			return false
		end

		v631("Searching - " .. tostring(p131.Island))

		local now2 = tick()
		local exitTo
		local v710

		while true do
			if not _G.AutoMagnetToken then
				exitTo = 1

				break
			end

			if not (tick() - now2 < 1) then
				exitTo = 1

				break
			end

			v710 = v691()

			if not v710 then
				task.wait(0.05)

				continue
			end

			break
		end

		if exitTo ~= 1 then
			return v710
		end

		local v711 = v691() or false

		return v711
	end

	GRP_Main_Update_30_Magnet_Token:AddToggle("Auto_Farm_Magnet_Token", {
		Text = "Auto Farm Magnet Token",
		Default = false,
		Callback = function(p132)
			_G.AutoMagnetToken = p132
			v631(p132 and "Starting..." or "Idle")

			if not p132 then
				_G.MagnetEventSpawnIndex = 1
			end
		end
	})
	task.spawn(function()
		local magnetEventSpawnRoute = {}
		local magnetEventSpawnIndex = 1
		local v714 = true

		while task.wait() do
			if _G.AutoMagnetToken then
				if v714 or #magnetEventSpawnRoute == 0 then
					magnetEventSpawnRoute = v665()

					if #magnetEventSpawnRoute == 0 then
						task.wait(5)

						continue
					end

					magnetEventSpawnIndex = _G.MagnetEventSpawnIndex or 1

					if magnetEventSpawnIndex > #magnetEventSpawnRoute then
						magnetEventSpawnIndex = 1
					end

					v714 = false
					_G.MagnetEventSpawnRoute = magnetEventSpawnRoute
				end

				local v715 = magnetEventSpawnRoute[magnetEventSpawnIndex]

				if not v715 then
					magnetEventSpawnIndex = 1
					v715 = magnetEventSpawnRoute[magnetEventSpawnIndex]
				end

				local v716 = v700(v715)

				if v716 then
					v631("Farming - " .. tostring(v716.Name))

					repeat
						task.wait(0.1)

						if not v716.Parent or not v716:FindFirstChild("HumanoidRootPart") then
							break
						end

						_tp(v716.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
						t9.Kill(v716, _G.AutoMagnetToken)
					until not _G.AutoMagnetToken or v716.Humanoid.Health <= 0 or not v716.Parent

					magnetEventSpawnIndex += 1

					if magnetEventSpawnIndex > #magnetEventSpawnRoute then
						magnetEventSpawnIndex = 1
					end

					_G.MagnetEventSpawnIndex = magnetEventSpawnIndex
				else
					magnetEventSpawnIndex += 1

					if magnetEventSpawnIndex > #magnetEventSpawnRoute then
						magnetEventSpawnIndex = 1
					end

					_G.MagnetEventSpawnIndex = magnetEventSpawnIndex
					task.wait(0.2)
				end
			else
				v631("Idle")
				_G.MagnetEventSpawnIndex = magnetEventSpawnIndex
				task.wait(1)
			end
		end
	end)
end

GRP_Settings_Settings_Configure = t15.Settings:AddLeftGroupbox("Settings / Configure")
Initialize = GRP_Settings_Settings_Configure:AddToggle("Fast_Attack", {
	Text = "Fast Attack",
	Default = true,
	Callback = function(p133)
		_G.Seriality = p133
	end
})
Bringmob = GRP_Settings_Settings_Configure:AddToggle("Bring_Mobs", {
	Text = "Bring Mobs",
	Default = true,
	Callback = function(p134)
		_B = p134
	end
})
GRP_Settings_Settings_Configure:AddToggle("Auto_Hop_Server_with_time", {
	Text = "Auto Hop Server with time",
	Default = false,
	Callback = function(p135)
		_G.AutoHopServer = p135

		if not p135 then
			_G.HopTimer = nil
		end
	end
})
Spawn(function()
	while Wait(1) do
		if _G.AutoHopServer then
			pcall(function()
				if not _G.HopTimer then
					_G.HopTimer = tick()
				end

				if _G.HopDelay <= tick() - _G.HopTimer then
					_G.HopTimer = tick()

					if syn and syn.queue_on_teleport then
						syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Chest'))()")
					end

					game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
				end
			end)
		end
	end
end)

do
	GRP_Settings_Settings_Configure:AddSlider({
		Text = "Hop Delay (Minutes)",
		Min = 5,
		Max = 120,
		Default = 30,
		Rounding = 0,
		Callback = function(p136)
			_G.HopDelay = p136 * 60
		end
	})
end

GRP_Settings_Settings_Configure:AddToggle("Auto_Set_Spawn_Point", {
	Text = "Auto Set Spawn Point",
	Default = false,
	Callback = function(p137)
		getgenv().Set = p137

		if p137 then
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
			end)
		end
	end
})
BusuAura = GRP_Settings_Settings_Configure:AddToggle("Auto_Turn_on_Buso", {
	Text = "Auto Turn on Buso",
	Default = true,
	Callback = function(p138)
		Boud = p138
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if Boud then
				local t37 = {
					"HasBuso",
					"Buso"
				}

				if not plr.Character:FindFirstChild(t37[1]) then
					replicated.Remotes.CommF_:InvokeServer(t37[2])
				end
			end
		end)
	end
end)

do
	GRP_Settings_Settings_Configure:AddToggle("Auto_Haki_Observation", {
		Text = "Auto Haki Observation",
		Default = false,
		Callback = function(p139)
			getgenv().Observation = p139
		end
	})
end

spawn(function()
	while wait() do
		if getgenv().Observation then
			local exitTo

			repeat
				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
				end)
				exitTo = nil

				while wait() do
					if getgenv().Observation then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)
RaceV3Aura = GRP_Settings_Settings_Configure:AddToggle("AutoTurnonRaceV3", {
	Text = "Auto Turn on Race V3",
	Default = false,
	Callback = function(p140)
		_G.RaceClickAutov3 = p140
	end
})
spawn(function()
	while wait(0.2) do
		pcall(function()
			if _G.RaceClickAutov3 then
				repeat
					replicated.Remotes.CommE:FireServer("ActivateAbility")
					wait(30)
				until not _G.RaceClickAutov3
			end
		end)
	end
end)
RaceV4Aura = GRP_Settings_Settings_Configure:AddToggle("Auto_Turn_on_Race_V4", {
	Text = "Auto Turn on Race V4",
	Default = false,
	Callback = function(p141)
		_G.RaceClickAutov4 = p141
	end
})
spawn(function()
	if wait(0.2) then
		repeat
			pcall(function()
				if _G.RaceClickAutov4 then
					if plr.Character:FindFirstChild("RaceEnergy") then
						if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then
							Useskills("nil", "Y")
						end
					end
				end
			end)
		until not wait(0.2)
	end
end)
RandomAround = GRP_Settings_Settings_Configure:AddToggle("Auto_Turn_on_Spin__xyz", {
	Text = "Auto Turn on Spin  xyz",
	Default = false,
	Callback = function(p142)
		RandomCFrame = p142
	end
})
SafeModes = GRP_Settings_Settings_Configure:AddToggle("Safe_Mode", {
	Text = "Safe Mode",
	Default = false,
	Callback = function(p143)
		_G.Safemode = p143
	end
})

do
	spawn(function()
		while task.wait(Sec) do
			pcall(function()
				if _G.Safemode then
					if plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * 100 < Num_self then
						shouldTween = true
						_tp(Root.CFrame * CFrame.new(0, 500, 0))
					else
						shouldTween = false
					end
				end
			end)
		end
	end)
end

DisableHitVFX = GRP_Settings_Settings_Configure:AddToggle("Remove_Hit_VFX", {
	Text = "Remove Hit VFX",
	Default = false,
	Callback = function(p144)
		_G.DestroyHit = p144
	end
})

local t38 = {
	"SlashHit",
	"CurvedRing",
	"SwordSlash",
	"SlashTail"
}

task.spawn(function()
	while task.wait(Sec) do
		if _G.DestroyHit then
			pcall(function()
				for _, child in pairs(workspace._WorldOrigin:GetChildren()) do
					if table.find(t38, child.Name) then
						child:Destroy()
					end
				end
			end)
		end
	end
end)
RmvVFX = GRP_Settings_Settings_Configure:AddToggle("Remove_Death_&_Respawned_VFX", {
	Text = "Remove Death & Respawned VFX",
	Default = false,
	Callback = function(p145)
		RDeath = p145
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if RDeath then
					if replicated.Effect.Container:FindFirstChild("Death") then
						replicated.Effect.Container.Death:Destroy()
					end

					if replicated.Effect.Container:FindFirstChild("Respawn") then
						replicated.Effect.Container.Respawn:Destroy()
					end
				end
			end)
		end
	end)
end

do
	DisblesNotify = GRP_Settings_Settings_Configure:AddToggle("Disable_Notify", {
		Text = "Disable Notify",
		Default = false,
		Callback = function(p146)
			RemoveDamage = p146
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if RemoveDamage then
				replicated.Assets.GUI.DamageCounter.Enabled = false
				plr.PlayerGui.Notifications.Enabled = false
			else
				replicated.Assets.GUI.DamageCounter.Enabled = true
				plr.PlayerGui.Notifications.Enabled = true
			end
		end)
	end
end)

do
	GRP_Settings_Settings_Configure:AddToggle("Anti_AFK", {
		Text = "Anti AFK",
		Default = true,
		Callback = function(p147)
			if p147 then
				local VirtualUser = game:GetService("VirtualUser")

				repeat
					wait()
				until game:IsLoaded()

				game:GetService("Players").LocalPlayer.Idled:Connect(function()
					VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
					wait(1)
					VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
				end)
			end
		end
	})
end

GRP_Settings_Settings_Configure:AddToggle("Auto_Anti_-_Admin_Join_Server", {
	Text = "Auto Anti - Admin Join Server",
	Default = true,
	Callback = function(p148)
		getgenv().HopServerAdmin = p148
	end
})
spawn(function()
	while wait() do
		pcall(function()
			if getgenv().HopServerAdmin then
				local v723, v724, v725 = pairs(game.Players:GetPlayers())
				local v726 = geniter(v723, v724, v725)
				local v727 = table.pack(v726())

				if v727[1] then
					local v728 = v727[3]
					local t39 = {}
					local s18 = "red_game43"
					local s19 = "rip_indra"
					local s20 = "Axiore"

					while true do
						t39[1] = s18
						t39[2] = s19
						t39[3] = s20
						t39[4] = "Polkster"
						t39[5] = "wenlocktoad"
						t39[6] = "Daigrock"
						t39[7] = "toilamvidamme"
						t39[8] = "oofficialnoobie"
						t39[9] = "Uzoth"
						t39[10] = "Azarth"
						t39[11] = "arlthmetic"
						t39[12] = "Death_King"
						t39[13] = "Lunoven"
						t39[14] = "TheGreateAced"
						t39[15] = "rip_fud"
						t39[16] = "drip_mama"
						t39[17] = "layandikit12"
						t39[18] = "Hingoi"

						if table.find(t39, v728.Name) then
							Hop()
						end

						local v733 = table.pack(v726())

						if not v733[1] then
							break
						end

						v728 = v733[3]
						t39 = {}
						s18 = "red_game43"
					end
				end
			end
		end)
	end
end)
GRP_Settings_Settings_Configure:AddToggle("No_Clip", {
	Text = "No Clip",
	Default = false,
	Callback = function(p149)
		getgenv().NoClip = p149
	end
})

do
	spawn(function()
		pcall(function()
			game:GetService("RunService").Stepped:Connect(function()
				if getgenv().NoClip then
					for _, descendant in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if descendant:IsA("BasePart") or descendant:IsA("Part") then
							descendant.CanCollide = false
						end
					end
				end
			end)
		end)
	end)
end

GRP_Esp_Stats_Upgrade = t15.Esp:AddLeftGroupbox("Stats Upgrade")
StatusSelect = GRP_Esp_Stats_Upgrade:AddSlider({
	Text = "Stats Value",
	Min = 0,
	Max = 1000,
	Default = 10,
	Rounding = 0,
	Callback = function(p150)
		pSats = p150
	end
})

do
	StatsUpg = GRP_Esp_Stats_Upgrade:AddToggle("Auto_Melee", {
		Text = "Auto Melee",
		Default = false,
		Callback = function(p151)
			_G.Auto_Melee = p151
		end
	})
end

do
	spawn(function()
		if wait(Sec) then
			repeat
				pcall(function()
					if _G.Auto_Melee then
						statsSetings("Melee", pSats)
					end
				end)
			until not wait(Sec)
		end
	end)
end

StatsUpg = GRP_Esp_Stats_Upgrade:AddToggle("Auto_Swords", {
	Text = "Auto Swords",
	Default = false,
	Callback = function(p152)
		_G.Auto_Sword = p152
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Sword then
				statsSetings("Sword", pSats)
			end
		end)
	end
end)
StatsUpg = GRP_Esp_Stats_Upgrade:AddToggle("Auto_Gun", {
	Text = "Auto Gun",
	Default = false,
	Callback = function(p153)
		_G.Auto_Gun = p153
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Gun then
				statsSetings("Gun", pSats)
			end
		end)
	end
end)
StatsUpg = GRP_Esp_Stats_Upgrade:AddToggle("Auto_Blox_Fruit", {
	Text = "Auto Blox Fruit",
	Default = false,
	Callback = function(p154)
		_G.Auto_DevilFruit = p154
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Auto_DevilFruit then
					statsSetings("Devil", pSats)
				end
			end)
		end
	end)
end

StatsUpg = GRP_Esp_Stats_Upgrade:AddToggle("Auto_Defense", {
	Text = "Auto Defense",
	Default = false,
	Callback = function(p155)
		_G.Auto_Defense = p155
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Defense then
				statsSetings("Defense", pSats)
			end
		end)
	end
end)
GRP_Fish_Fishing = t15.Fish:AddLeftGroupbox("Fishing")

do
	GRP_Fish_Fishing:AddDropdown("Select_Fishing_Rod", {
		Text = "Select Fishing Rod",
		Values = {
			"Fishing Rod",
			"Gold Rod",
			"Shark Rod",
			"Shell Rod",
			"Treasure Rod"
		},
		Default = "Fishing Rod",
		Callback = function(p156)
			_G.SelectedRod = p156
		end
	})
end

BaitDropdown = GRP_Fish_Fishing:AddDropdown("Select_Bait", {
	Text = "Select Bait",
	Values = {
		"Basic Bait",
		"Kelp Bait",
		"Good Bait",
		"Abyssal Bait",
		"Frozen Bait",
		"Epic Bait",
		"Carnivore Bait"
	},
	Default = "Basic Bait",
	Callback = function(p157)
		_G.SelectedBait = p157

		if _G.AutoBuyBait then
			pcall(function()
				t8.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
			end)
		end
	end
})
BuyBaitToggle = GRP_Fish_Fishing:AddToggle("Auto_Buy_Bait", {
	Text = "Auto Buy Bait",
	Default = false,
	Callback = function(p158)
		_G.AutoBuyBait = p158

		if p158 then
			pcall(function()
				t8.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
			end)
		end
	end
})
task.spawn(function()
	while task.wait(2) do
		if _G.AutoBuyBait and _G.SelectedBait then
			pcall(function()
				t8.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
			end)
		end
	end
end)

do
	FishingToggle = GRP_Fish_Fishing:AddToggle("Auto_Fishing", {
		Text = "Auto Fishing",
		Default = false,
		Callback = function(p159)
			_G.AutoFishing = p159
		end
	})
end

local Players = game:GetService("Players")

do
	local LocalPlayer = Players.LocalPlayer
	local Workspace = game:GetService("Workspace")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local FishReplicated = ReplicatedStorage2:WaitForChild("FishReplicated")
	local FishingRequest = FishReplicated:WaitForChild("FishingRequest")
	local Config = require(FishReplicated.FishingClient.Config)
	local GetWaterHeightAtLocation = require(ReplicatedStorage2.Util.GetWaterHeightAtLocation)
	local MaxLaunchDistance = Config.Rod.MaxLaunchDistance

	task.spawn(function()
		while task.wait(0.5) do
			if _G.AutoFishing then
				pcall(function()
					local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
					local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart then
						return
					end

					local Tool = Character:FindFirstChildOfClass("Tool")

					if _G.SelectedRod and (not Tool or Tool.Name ~= _G.SelectedRod) then
						local _GSelectedRod = LocalPlayer.Backpack:FindFirstChild(_G.SelectedRod)

						if _GSelectedRod then
							Character.Humanoid:EquipTool(_GSelectedRod)
							Tool = _GSelectedRod
						end
					end

					if Tool then
						local v749 = GetWaterHeightAtLocation(HumanoidRootPart.Position)
						local _, v751 = Workspace:FindPartOnRayWithIgnoreList(Ray.new(Character.Head.Position, HumanoidRootPart.CFrame.LookVector * MaxLaunchDistance), {
							Character,
							Workspace.Characters,
							Workspace.Enemies
						})
						local vector3 = v751 and Vector3.new(v751.X, math.max(v751.Y, v749), v751.Z)
						local attribute = Tool:GetAttribute("State")
						local attribute2 = Tool:GetAttribute("ServerState")

						if vector3 and (attribute == "ReeledIn" or attribute2 == "ReeledIn") then
							FishingRequest:InvokeServer("StartCasting")
							task.wait()
							FishingRequest:InvokeServer("CastLineAtLocation", vector3, 100, true)
						elseif attribute2 == "Biting" then
							FishingRequest:InvokeServer("Catching", true)
							task.wait(0.1)
							FishingRequest:InvokeServer("Catch", 1)
						end
					end
				end)
			end
		end
	end)
end

do
	FishingQ = GRP_Fish_Fishing:AddToggle("Auto_Quest_Fishing", {
		Text = "Auto Quest Fishing",
		Default = false,
		Callback = function(p160)
			_G.AutoFishingQuest = p160
		end
	})
end

do
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local RFJobsRemoteFunction = game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RF/JobsRemoteFunction")

	local function v757()
		local Quest = LocalPlayer.PlayerGui:FindFirstChild("Quest") or LocalPlayer.PlayerGui:FindFirstChild("QuestGui")

		if Quest and Quest:FindFirstChild("Container") then
			if Quest.Container:FindFirstChild("QuestTitle") then
				return true
			end
		end

		return false
	end

	task.spawn(function()
		while task.wait(1) do
			if _G.AutoFishingQuest then
				local exitTo

				repeat
					pcall(function()
						if not v757() then
							RFJobsRemoteFunction:InvokeServer("FishingNPC", "Angler", "AskQuest")
						end
					end)
					exitTo = nil

					while task.wait(1) do
						if _G.AutoFishingQuest then
							exitTo = 1

							break
						end
					end
				until exitTo ~= 1

				return
			end
		end
	end)
end

QuestToggle = GRP_Fish_Fishing:AddToggle("Auto_Complete_Quest", {
	Text = "Auto Complete Quest",
	Default = false,
	Callback = function(p161)
		_G.AutoQuestComplete = p161

		if p161 then
			pcall(function()
				t8.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest")
			end)
		end
	end
})

do
	task.spawn(function()
		while task.wait(5) do
			if _G.AutoQuestComplete then
				pcall(function()
					t8.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest")
				end)
			end
		end
	end)
end

do
	SellFishToggle = GRP_Fish_Fishing:AddToggle("Auto_Sell_Fish", {
		Text = "Auto Sell Fish",
		Default = false,
		Callback = function(p162)
			_G.AutoSellFish = p162

			if p162 then
				pcall(function()
					t8.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish")
				end)
			end
		end
	})
end

task.spawn(function()
	while task.wait(5) do
		if _G.AutoSellFish then
			pcall(function()
				t8.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish")
			end)
		end
	end
end)
SpamSkillZ = GRP_Fish_Fishing:AddToggle("Auto_Spam_Skill_Z", {
	Text = "Auto Spam Skill Z",
	Default = false,
	Callback = function(p163)
		_G.AutoSkillZ = p163
	end
})

do
	local RFJobToolAbilities = game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RF/JobToolAbilities")

	task.spawn(function()
		while task.wait(0.5) do
			if _G.AutoSkillZ then
				pcall(function()
					RFJobToolAbilities:InvokeServer("Z", true)
				end)
			end
		end
	end)
end

GRP_Quests_Auto_Quest_Sea_2 = t15.Quests:AddLeftGroupbox("Auto Quest Sea 2")
TravelDress = GRP_Quests_Auto_Quest_Sea_2:AddToggle("Auto_Quest_Sea_2", {
	Text = "Auto Quest Sea 2",
	Default = false,
	Callback = function(p164)
		_G.TravelDres = p164
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.TravelDres and plr.Data.Level.Value >= 700 then
				if workspace.Map.Ice.Door.CanCollide == true and workspace.Map.Ice.Door.Transparency == 0 then
					replicated.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
					EquipWeapon("Key")

					while true do
						wait()
						_tp(CFrame.new(1347.7124, 37.3751602, -1325.6488))

						if not _G.TravelDres then
							break
						elseif Root.Position == CFrame.new(1347.7124, 37.3751602, -1325.6488).Position then
							break
						end
					end
				else
					if workspace.Map.Ice.Door.CanCollide ~= false or workspace.Map.Ice.Door.Transparency ~= 1 then
						replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")

						return
					end

					if not Enemies:FindFirstChild("Ice Admiral") then
						_tp(CFrame.new(1347.7124, 37.3751602, -1325.6488))

						return
					end

					local v761, v762, v763 = pairs(Enemies:GetChildren())
					local v764 = geniter(v761, v762, v763)
					local v765

					while true do
						local v766 = table.pack(v764())

						if v766[1] then
							v765 = v766[3]

							if v765.Name == "Ice Admiral" then
								break
							end
						else
							return
						end
					end

					local exitTo

					repeat
						if t9.Alive(v765) then
							while true do
								task.wait()
								t9.Kill(v765, _G.TravelDres)

								if _G.TravelDres == false then
									break
								elseif v765.Humanoid.Health <= 0 then
									break
								end
							end

							replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
						end

						exitTo = nil

						while true do
							local v768 = table.pack(v764())

							if v768[1] then
								v765 = v768[3]

								if v765.Name == "Ice Admiral" then
									exitTo = 1

									break
								end
							else
								break
							end
						end
					until exitTo ~= 1

					return
				end
			end
		end)
	end
end)
Zou = GRP_Quests_Auto_Quest_Sea_2:AddToggle("Auto_Quest_Sea_3", {
	Text = "Auto Quest Sea 3",
	Default = false,
	Callback = function(p165)
		_G.AutoZou = p165
	end
})
spawn(function()
	if wait(Sec) then
		repeat
			pcall(function()
				if _G.AutoZou and plr.Data.Level.Value >= 1500 then
					if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 3 then
						if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
							replicated.Remotes.CommF_:InvokeServer("F_", "TravelZou")

							if replicated.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 0 then
								local ripIndra = GetConnectionEnemies("rip_indra")

								if ripIndra then
									while true do
										wait()
										t9.Kill(ripIndra, _G.AutoZou)

										if not _G.AutoZou then
											break
										elseif not ripIndra.Parent or ripIndra.Humanoid.Health <= 0 then
											break
										end
									end

									Check = 2

									repeat
										wait()
										replicated.Remotes.CommF_:InvokeServer("F_", "TravelZou")
									until Check == 1
								else
									replicated.Remotes.CommF_:InvokeServer("F_", "ZQuestProgress", "Check")
									wait(0.1)
									replicated.Remotes.CommF_:InvokeServer("F_", "ZQuestProgress", "Begin")
								end
							elseif replicated.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 1 then
								replicated.Remotes.CommF_:InvokeServer("F_", "TravelZou")
							else
								local v770 = GetConnectionEnemies("Don Swan")

								if v770 then
									while true do
										wait()
										t9.Kill(v770, _G.AutoZou)

										if not _G.AutoZou then
											break
										elseif not v770.Parent or v770.Humanoid.Health <= 0 then
											break
										end
									end
								else
									while true do
										wait()
										_tp(CFrame.new(2288.802, 15.1870775, 863.034607))

										if not _G.AutoZou then
											break
										elseif Root.Position == CFrame.new(2288.802, 15.1870775, 863.034607).Position then
											break
										end
									end

									if Root.CFrame == CFrame.new(2288.802, 15.1870775, 863.034607) then
										notween(CFrame.new(2288.802, 15.1870775, 863.034607))
									end
								end
							end
						elseif replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
							TabelDevilFruitStore = {}
							TabelDevilFruitOpen = {}

							for _, v1 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventoryFruits")) do
								for k, v2 in pairs(v1) do
									if k == "Name" then
										table.insert(TabelDevilFruitStore, v2)
									end
								end
							end

							local next_ = next
							local response, v777 = game.ReplicatedStorage:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits")

							for _, v1 in next_, response, v777 do
								if v1.Price >= 1000000 then
									table.insert(TabelDevilFruitOpen, v1.Name)
								end
							end

							for _, v1 in pairs(TabelDevilFruitOpen) do
								for _, v2 in pairs(TabelDevilFruitStore) do
									if v1 == v2 then
										if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
											if plr.Backpack:FindFirstChild(v2) then
												replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "1")
												replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "2")
												replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "3")
											else
												replicated.Remotes.CommF_:InvokeServer("F_", "LoadFruit", v2)
											end
										end
									end
								end
							end

							replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "1")
							replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "2")
							replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "3")
						end
					elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 0 then
						if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") then
							if not string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") or plr.PlayerGui.Main.Quest.Visible ~= true then
								_tp(CFrame.new(-456.28952, 73.0200958, 299.895966))

								return
							end

							local v784 = GetConnectionEnemies("Swan Pirate")

							if v784 then
								pcall(function()
									while true do
										wait()
										t9.Kill(v784, _G.AutoZou)

										if not v784.Parent then
											break
										elseif v784.Humanoid.Health <= 0 or _G.AutoZou == false or plr.PlayerGui.Main.Quest.Visible == false then
											break
										end
									end
								end)
							else
								_tp(CFrame.new(1057.92761, 137.614319, 1242.08069))
							end
						else
							_tp(CFrame.new(-456.28952, 73.0200958, 299.895966))
						end
					elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 1 then
						local Jeremy = GetConnectionEnemies("Jeremy")

						if Jeremy then
							while true do
								wait()
								t9.Kill(Jeremy, _G.AutoZou)

								if not Jeremy.Parent then
									break
								elseif Jeremy.Humanoid.Health <= 0 or _G.AutoZou == false then
									break
								end
							end
						else
							_tp(CFrame.new(2099.88159, 448.931, 648.997375))
						end
					elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 2 then
						while true do
							wait()
							_tp(CFrame.new(-1836, 11, 1714))

							if not _G.AutoZou then
								break
							elseif Root.Position == CFrame.new(-1836, 11, 1714).Position then
								break
							end
						end

						if Root.CFrame == CFrame.new(-1836, 11, 1714) then
							notween(CFrame.new(-1836, 11, 1714))
						end

						notween(CFrame.new(-1850.49329, 13.1789551, 1750.89685))
						wait(0.1)
						notween(CFrame.new(-1858.87305, 19.3777466, 1712.01807))
						wait(0.1)
						notween(CFrame.new(-1803.94324, 16.5789185, 1750.89685))
						wait(0.1)
						notween(CFrame.new(-1858.55835, 16.8604317, 1724.79541))
						wait(0.1)
						notween(CFrame.new(-1869.54224, 15.987854, 1681.00659))
						wait(0.1)
						notween(CFrame.new(-1800.0979, 16.4978027, 1684.52368))
						wait(0.1)
						notween(CFrame.new(-1819.26343, 14.795166, 1717.90625))
						wait(0.1)
						notween(CFrame.new(-1813.51843, 14.8604736, 1724.79541))
					end
				end
			end)
		until not wait(Sec)
	end
end)
GRP_Quests_Tushita_Yama = t15.Quests:AddLeftGroupbox("Tushita + Yama")
Q = GRP_Quests_Tushita_Yama:AddToggle("Auto_Tushita_Sword", {
	Text = "Auto Tushita Sword",
	Default = false,
	Callback = function(p166)
		_G.Auto_Tushita = p166
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Tushita then
				if not workspace.Map.Turtle:FindFirstChild("TushitaGate") then
					local Longma = GetConnectionEnemies("Longma")

					if Longma then
						while true do
							task.wait()
							t9.Kill(Longma, _G.Auto_Tushita)

							if Longma.Humanoid.Health <= 0 then
								break
							elseif not _G.Auto_Tushita or not Longma.Parent then
								break
							end
						end
					elseif replicated:FindFirstChild("Longma") then
						_tp(replicated:FindFirstChild("Longma").HumanoidRootPart.CFrame * CFrame.new(0, 40, 0))
					end
				elseif GetBP("Holy Torch") then
					EquipWeapon("Holy Torch")
					task.wait(1)

					while true do
						task.wait()
						_tp(CFrame.new(-10752, 417, -9366))

						if not _G.Auto_Tushita then
							break
						elseif (CFrame.new(-10752, 417, -9366).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							break
						end
					end

					wait(0.7)

					while true do
						task.wait()
						_tp(CFrame.new(-11672, 334, -9474))

						if not _G.Auto_Tushita then
							break
						elseif (CFrame.new(-11672, 334, -9474).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							break
						end
					end

					wait(0.7)

					while true do
						task.wait()
						_tp(CFrame.new(-12132, 521, -10655))

						if not _G.Auto_Tushita then
							break
						elseif (CFrame.new(-12132, 521, -10655).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							break
						end
					end

					wait(0.7)

					while true do
						task.wait()
						_tp(CFrame.new(-13336, 486, -6985))

						if not _G.Auto_Tushita then
							break
						elseif (CFrame.new(-13336, 486, -6985).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							break
						end
					end

					wait(0.7)

					while true do
						task.wait()
						_tp(CFrame.new(-13489, 332, -7925))

						if not _G.Auto_Tushita then
							break
						elseif (CFrame.new(-13489, 332, -7925).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							break
						end
					end
				else
					_tp(CFrame.new(5148.03613, 162.352493, 910.548218))
					wait(0.7)
				end
			end
		end)
	end
end)
Q = GRP_Quests_Tushita_Yama:AddToggle("Auto_Yama_Sword", {
	Text = "Auto Yama Sword",
	Default = false,
	Callback = function(p167)
		_G.Auto_Yama = p167
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Yama then
				if replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress") < 30 then
					_G.FarmEliteHunt = true
				elseif replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress") > 30 then
					_G.FarmEliteHunt = false

					if (workspace.Map.Waterfall.SealedKatana.Handle.Position - plr.Character.HumanoidRootPart.Position).Magnitude >= 20 then
						_tp(workspace.Map.Waterfall.SealedKatana.Handle.CFrame)

						local Ghost = GetConnectionEnemies("Ghost")

						if Ghost then
							while true do
								wait()
								t9.Kill(Ghost, _G.Auto_Yama)

								if Ghost.Humanoid.Health <= 0 then
									break
								elseif not Ghost.Parent or not _G.Auto_Yama then
									break
								end
							end

							fireclickdetector(workspace.Map.Waterfall.SealedKatana.Handle.ClickDetector)
						end
					end
				end
			end
		end)
	end
end)
GRP_Quests_Skull_Guitars_Misc = t15.Quests:AddLeftGroupbox("Skull Guitars / Misc")

do
	local v788 = GRP_Quests_Skull_Guitars_Misc:AddLabel("")

	spawn(function()
		while wait(0.2) do
			pcall(function()
				if Quest1 == true then
					v788:SetText("Quest Number : Quest1")
				elseif Quest2 == true then
					v788:SetText("Quest Number : Quest2")
				elseif Quest3 == true then
					v788:SetText("Quest Number : Quest3")
				elseif Quest4 == true then
					v788:SetText("Quest Number : Quest4")
				elseif GetWP("Skull Guitar") then
					v788:SetText("Quest Number : Collect!!")
				else
					v788:SetText("Quest Number : No Quest!!")
				end
			end)
		end
	end)
end

do
	GRP_Quests_Skull_Guitars_Misc:AddToggle("Auto_Skull_Guitar", {
		Text = "Auto Skull Guitar",
		Default = false,
		Callback = function(p168)
			_G.Auto_Soul_Guitar = p168
		end
	})
end

task.spawn(function()
	while wait() do
		if _G.Auto_Soul_Guitar then
			pcall(function()
				local v789 = GetConnectionEnemies("Living Zombie")

				if v789 then
					v789.HumanoidRootPart.CFrame = CFrame.new(-10138.3974609375, 138.6524658203125, 5902.89208984375)
					v789.Head.CanCollide = false
					v789.Humanoid.Sit = false
					v789.HumanoidRootPart.CanCollide = false
					v789.Humanoid.JumpPower = 0
					v789.Humanoid.WalkSpeed = 0

					if v789.Humanoid:FindFirstChild("Animator") then
						v789.Humanoid:FindFirstChild("Animator"):Destroy()
					end
				end
			end)
		end
	end
end)
getT = function(p169)
	local Rotation

	if p169 == 1 then
		Rotation = workspace.Map["Haunted Castle"].Tablet.Segment1.Line.Rotation
	elseif p169 == 3 then
		Rotation = workspace.Map["Haunted Castle"].Tablet.Segment3.Line.Rotation
	elseif p169 == 4 then
		Rotation = workspace.Map["Haunted Castle"].Tablet.Segment4.Line.Rotation
	elseif p169 == 7 then
		Rotation = workspace.Map["Haunted Castle"].Tablet.Segment7.Line.Rotation
	elseif p169 == 10 then
		Rotation = workspace.Map["Haunted Castle"].Tablet.Segment10.Line.Rotation
	end

	if Rotation then
		return Rotation.Z
	end
end
getRT = function(p170)
	local Rotation

	for _, child in pairs(workspace.Map["Haunted Castle"].Trophies.Quest:GetChildren()) do
		if p170 == 1 and child.Name == "Trophy1" and child:FindFirstChild("Handle") then
			Rotation = child.Handle.Rotation
		elseif p170 == 2 and child.Name == "Trophy2" and child:FindFirstChild("Handle") then
			Rotation = child.Handle.Rotation
		elseif p170 == 3 and child.Name == "Trophy3" and child:FindFirstChild("Handle") then
			Rotation = child.Handle.Rotation
		elseif p170 == 4 and child.Name == "Trophy4" and child:FindFirstChild("Handle") then
			Rotation = child.Handle.Rotation
		elseif p170 == 5 and child.Name == "Trophy5" and child:FindFirstChild("Handle") then
			Rotation = child.Handle.Rotation
		end

		if Rotation then
			return Rotation.Z
		end
	end
end
GetFirePlacard = function(p171, p172)
	if tostring(workspace.Map["Haunted Castle"]["Placard" .. p171][p172].Indicator.BrickColor) ~= "Pearl" then
		fireclickdetector(workspace.Map["Haunted Castle"]["Placard" .. p171][p172].ClickDetector)
	end
end
spawn(function()
	repeat
		task.wait()
	until _G.Auto_Soul_Guitar

	while wait(Sec) do
		pcall(function()
			if _G.Auto_Soul_Guitar and World3 then
				replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
				replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)

				if replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check") == nil then
					_tp(CFrame.new(-8655.0166015625, 141.31669616699219, 6160.0224609375))
					replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
					replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
				elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check").Swamp == false then
					Quest1 = true
					Quest2 = false
					Quest3 = false
					Quest4 = false

					local v794 = GetConnectionEnemies("Living Zombie")

					if v794 then
						while true do
							task.wait()
							t9.Kill(v794, _G.Auto_Soul_Guitar)

							if not _G.Auto_Soul_Guitar then
								break
							elseif v794.Humanoid.Health <= 0 or not v794.Parent or workspace.Map["Haunted Castle"].SwampWater.Color ~= Color3.fromRGB(117, 0, 0) then
								break
							end
						end
					else
						_tp(CFrame.new(-10170.7275390625, 138.6524658203125, 5934.26513671875))
					end
				elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check").Gravestones == false then
					Quest1 = false
					Quest2 = true
					Quest3 = false
					Quest4 = false
					GetFirePlacard("7", "Left")
					GetFirePlacard("6", "Left")
					GetFirePlacard("5", "Left")
					GetFirePlacard("4", "Right")
					GetFirePlacard("3", "Left")
					GetFirePlacard("2", "Right")
					GetFirePlacard("1", "Right")
				elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check").Ghost == false then
					replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost")
					replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost", true)
				elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check").Trophies == false then
					Quest1 = false
					Quest2 = false
					Quest3 = true
					Quest4 = false
					_tp(CFrame.new(-9532.8232421875, 6.4716677665710449, 6078.068359375))

					local v795, v796

					repeat
						wait()
						v796 = getRT(1)
						v795 = getT(1)

						if v796 and v795 then
							fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment1:FindFirstChild("ClickDetector"))
						end
					until v796 == v795

					local v797, v798

					repeat
						wait()
						v798 = getRT(2)
						v797 = getT(3)

						if v798 and v797 then
							fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment3:FindFirstChild("ClickDetector"))
						end
					until v798 == v797

					local v799, v800

					repeat
						wait()
						v800 = getRT(3)
						v799 = getT(4)

						if v800 and v799 then
							fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment4:FindFirstChild("ClickDetector"))
						end
					until v800 == v799

					local v801, v802

					repeat
						wait()
						v802 = getRT(4)
						v801 = getT(7)

						if v802 and v801 then
							fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment7:FindFirstChild("ClickDetector"))
						end
					until v802 == v801

					local v803, v804

					repeat
						wait()
						v804 = getRT(5)
						v803 = getT(10)

						if v804 and v803 then
							fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment10:FindFirstChild("ClickDetector"))
						end
					until v804 == v803

					while true do
						wait()
						fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment2:FindFirstChild("ClickDetector"))
						fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment5:FindFirstChild("ClickDetector"))
						fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment6:FindFirstChild("ClickDetector"))
						fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment8:FindFirstChild("ClickDetector"))
						fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment9:FindFirstChild("ClickDetector"))

						if workspace.Map["Haunted Castle"].Tablet.Segment2.Line.Rotation.Z == 0 then
							break
						elseif workspace.Map["Haunted Castle"].Tablet.Segment5.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment6.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment8.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment9.Line.Rotation.Z == 0 then
							break
						end
					end
				elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check").Pipes == false then
					Quest1 = false
					Quest2 = false
					Quest3 = false
					Quest4 = true
					_tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.CFrame)
					fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.ClickDetector)
					_tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.CFrame)
					fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
					fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
					fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
					_tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.CFrame)
					fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
					fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
					_tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.CFrame)
					fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.ClickDetector)
					_tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.CFrame)
					fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
					fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
					fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
				end
			end
		end)
	end
end)
GRP_Quests_Skull_Guitars_Misc:AddToggle("Auto_Farm_Material_Skull_Guitar", {
	Text = "Auto Farm Material Skull Guitar",
	Default = false,
	Callback = function(p173)
		_G.AutoMatSoul = p173
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.AutoMatSoul and GetWP("Skull Guitar") == false then
				if GetM("Bones") >= 500 and GetM("Ectoplasm") >= 250 and GetM("Dark Fragment") >= 1 then
					replicated.Remotes.CommF_:InvokeServer("soulGuitarBuy", true)
				elseif not (GetM("Ectoplasm") <= 250) then
					if GetM("Dark Fragment") < 1 then
						if _G.AutoMatSoul and World2 then
							local Darkbeard = GetConnectionEnemies("Darkbeard")

							if Darkbeard then
								while true do
									task.wait()
									t9.Kill(Darkbeard, _G.AutoMatSoul)

									if _G.AutoMatSoul then
										break
									elseif Darkbeard.Humanoid.Health <= 0 then
										break
									end
								end
							else
								_tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625))
							end
						else
							replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
						end

						if not GetConnectionEnemies("Darkbeard") then
							Hop()
						end
					elseif GetM("Bones") <= 500 then
						if _G.AutoMatSoul and World3 then
							local v806 = GetConnectionEnemies({
								"Reborn Skeleton",
								"Living Zombie",
								"Demonic Soul",
								"Posessed Mummy"
							})

							if v806 then
								while true do
									task.wait()
									t9.Kill(v806, _G.AutoMatSoul)

									if not _G.AutoMatSoul then
										break
									elseif v806.Humanoid.Health <= 0 or not v806.Parent or v806.Humanoid.Health <= 0 then
										break
									end
								end
							else
								_tp(CFrame.new(-9504.8564453125, 172.14292907714844, 6057.259765625))
							end
						else
							replicated.Remotes.CommF_:InvokeServer("TravelZou")
						end
					end
				elseif _G.AutoMatSoul and World2 then
					local v807 = GetConnectionEnemies({
						"Ship Deckhand",
						"Ship Engineer",
						"Ship Steward",
						"Ship Officer",
						"Arctic Warrior"
					})

					if v807 then
						while true do
							task.wait()
							t9.Kill(v807, _G.AutoMatSoul)

							if not _G.AutoMatSoul then
								break
							elseif not v807.Parent or v807.Humanoid.Health <= 0 then
								break
							end
						end
					else
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
					end
				else
					replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
				end
			end
		end)
	end
end)
GRP_Quests_Cursed_Dual_Katana = t15.Quests:AddLeftGroupbox("Cursed Dual Katana")

local v808 = GRP_Quests_Cursed_Dual_Katana:AddLabel("Quest Numbers :")

spawn(function()
	while wait(0.2) do
		if QuestYama_1 == true then
			v808:SetText("Quest Numbers : yama quest 1")
		elseif QuestYama_2 == true then
			v808:SetText("Quest Numbers : yama quest 2")
		elseif QuestYama_3 == true then
			v808:SetText("Quest Numbers : yama quest 3")
		elseif QuestTushita_1 == true then
			v808:SetText("Quest Numbers : tushita quest 1")
		elseif QuestTushita_2 == true then
			v808:SetText("Quest Numbers : tushita quest 2")
		elseif GetWP("Cursed Dual Katana") then
			v808:SetText("Quest Numbers : CDK done!!")
		end
	end
end)
Q = GRP_Quests_Cursed_Dual_Katana:AddToggle("Auto_Get_CDK_[_Last_Quest_]", {
	Text = "Auto Get CDK [ Last Quest ]",
	Default = false,
	Callback = function(p174)
		_G.CDK = p174
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.CDK then
				replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Good")
				replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Evil")
				replicated.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Boss")

				local v809 = GetConnectionEnemies("Cursed Skeleton Boss")

				if v809 then
					repeat
						wait()

						if plr.Character:FindFirstChild("Yama") then
							EquipWeapon("Yama")
						else
							if plr.Backpack:FindFirstChild("Yama") then
								EquipWeapon("Yama")
								_tp(v809.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))

								if not _G.CDK or not v809.Parent or v809.Humanoid.Health <= 0 then
									break
								end
							end

							if plr.Character:FindFirstChild("Tushita") then
								EquipWeapon("Tushita")
							elseif plr.Backpack:FindFirstChild("Tushita") then
								EquipWeapon("Tushita")
								_tp(v809.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))

								if not _G.CDK or not v809.Parent or v809.Humanoid.Health <= 0 then
									break
								end
							end
						end

						_tp(v809.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
					until not _G.CDK or not v809.Parent or v809.Humanoid.Health <= 0
				else
					_tp(CFrame.new(-12318.193359375, 601.95184326171875, -6538.662109375))
					wait(0.5)
					_tp(workspace.Map.Turtle.Cursed.BossDoor.CFrame)
				end
			end
		end)
	end
end)

do
	Q = GRP_Quests_Cursed_Dual_Katana:AddToggle("Auto_Yama_CDK", {
		Text = "Auto Yama CDK",
		Default = false,
		Callback = function(p175)
			_G.CDK_YM = p175
		end
	})
end

spawn(function()
	while wait() do
		pcall(function()
			if _G.CDK_YM then
				if tostring(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")) ~= "opened" then
					replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
					replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
				elseif replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Finished == nil then
					replicated.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
					replicated.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
				elseif replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Finished == false then
					if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == -3 then
						QuestYama_1 = true
						QuestYama_2 = false
						QuestYama_3 = false

						repeat
							task.wait()

							if workspace.Enemies:FindFirstChild("Forest Pirate") then
								if GetConnectionEnemies("Forest Pirate") then
									_tp(workspace.Enemies:FindFirstChild("Forest Pirate").HumanoidRootPart.CFrame)
								end
							else
								_tp(CFrame.new(-13223.521484375, 428.19381713867188, -7766.06787109375))
							end
						until not (tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 1 and _G.CDK_YM)
					elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == -4 then
						QuestYama_1 = false
						QuestYama_2 = true
						QuestYama_3 = false

						for _, child in pairs(game:GetService("Players").LocalPlayer.QuestHaze:GetChildren()) do
							for k, v1 in pairs(t7) do
								if string.find(k, child.Name) and child.Value > 0 then
									if (v1.Position - Root.Position).Magnitude <= 1000 then
										if workspace.Enemies:FindFirstChild(k) then
											for _, child2 in pairs(workspace.Enemies:GetChildren()) do
												if child2:FindFirstChild("HumanoidRootPart") and child2:FindFirstChild("Humanoid") and child2:FindFirstChild("Humanoid").Health > 0 and child2:FindFirstChild("HazeESP") then
													while true do
														wait()
														t9.Kill(child2, _G.CDK_YM)

														if not _G.CDK_YM then
															break
														end

														if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 2 and child2:FindFirstChild("HazeESP") then
															if not (child2.Humanoid.Health <= 0) then
																continue
															end
														end

														break
													end
												end
											end

											continue
										end
									end

									_tp(v1)
								end
							end
						end
					elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == -5 then
						QuestYama_1 = false
						QuestYama_2 = false
						QuestYama_3 = true

						if workspace.Map:FindFirstChild("HellDimension") and (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 1000 then
							for k in pairs(workspace.Map.HellDimension.Exit:GetChildren()) do
								if tonumber(k) == 2 then
									while true do
										task.wait()
										Root.CFrame = workspace.Map.HellDimension.Exit.CFrame

										if not _G.CDK_YM then
											break
										elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == 3 then
											break
										end
									end
								end
							end

							EquipWeapon(_G.SelectWeapon)

							if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 3 then
								while true do
									task.wait()

									repeat
										task.wait()
										_tp(workspace.Map.HellDimension.Torch1.Particles.CFrame)

										for _, descendant in pairs(workspace.Map.HellDimension:GetDescendants()) do
											if descendant:IsA("ProximityPrompt") then
												fireproximityprompt(descendant)
											end
										end
									until (workspace.Map.HellDimension.Torch1.Particles.Position - Root.Position).Magnitude < 5

									wait(2)
									_G.T1Yama = true

									if _G.CDK_YM and not _G.T1Yama then
										if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 3 then
											continue
										end
									end

									break
								end

								while true do
									task.wait()

									repeat
										task.wait()
										_tp(workspace.Map.HellDimension.Torch2.Particles.CFrame)

										for _, descendant in pairs(workspace.Map.HellDimension:GetDescendants()) do
											if descendant:IsA("ProximityPrompt") then
												fireproximityprompt(descendant)
											end
										end
									until (workspace.Map.HellDimension.Torch2.Particles.Position - Root.Position).Magnitude < 5

									wait(2)
									_G.T2Yama = true

									if not (_G.T2Yama or _G.CDK_YM == false) then
										if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 3 then
											continue
										end
									end

									break
								end

								while true do
									wait()

									repeat
										task.wait()
										_tp(workspace.Map.HellDimension.Torch3.Particles.CFrame)

										for _, descendant in pairs(workspace.Map.HellDimension:GetDescendants()) do
											if descendant:IsA("ProximityPrompt") then
												fireproximityprompt(descendant)
											end
										end
									until (workspace.Map.HellDimension.Torch3.Particles.Position - Root.Position).Magnitude < 5

									wait(2)
									_G.T3Yama = true

									if not (_G.T3Yama or _G.CDK_YM == false) then
										if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 3 then
											continue
										end
									end

									break
								end
							end

							for _, child in pairs(workspace.Enemies:GetChildren()) do
								if (child:FindFirstChild("HumanoidRootPart").Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 300 and child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") then
									if child:FindFirstChild("Humanoid").Health > 0 then
										while true do
											task.wait()
											t9.Kill(child, _G.CDK_YM)

											if not _G.CDK_YM or child.Humanoid.Health <= 0 or not child.Parent then
												break
											elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == 3 then
												break
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end)
	end
end)

do
	spawn(function()
		while wait() do
			pcall(function()
				if _G.CDK_YM then
					if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == -5 then
						if not workspace.Map:FindFirstChild("HellDimension") or (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude > 1000 then
							local v825 = GetConnectionEnemies("Soul Reaper")

							if v825 then
								while true do
									task.wait()
									_tp(v825.HumanoidRootPart.CFrame)

									if not (v825.Humanoid.Health <= 0) and _G.CDK_YM and v825.Parent then
										if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 3 then
											if not workspace.Map:FindFirstChild("HellDimension") or not ((Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 1000) then
												continue
											end
										end

										break
									end

									break
								end
							elseif plr.Backpack:FindFirstChild("Hallow Essence") then
								repeat
									_tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
									task.wait()
								until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - Root.Position).Magnitude <= 8

								EquipWeapon("Hallow Essence")
							else
								if plr.Character:FindFirstChild("Hallow Essence") then
									repeat
										_tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
										task.wait()
									until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - Root.Position).Magnitude <= 8

									EquipWeapon("Hallow Essence")

									return
								end

								local ok4 = not replicated:FindFirstChild("Soul Reaper")

								if not ok4 then
									ok4 = not (replicated:FindFirstChild("Soul Reaper").Humanoid.Health > 0)
								end

								if ok4 then
									if replicated.Remotes.CommF_:InvokeServer("Bones", "Check") < 50 then
										if workspace.Enemies:FindFirstChild("Soul Reaper") then
											replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)

											return
										end

										if replicated:FindFirstChild("Soul Reaper") then
											replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)

											return
										end

										if workspace.Map:FindFirstChild("HellDimension") then
											replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)

											return
										end

										local ok = workspace.Enemies:FindFirstChild("Reborn Skeleton")

										if not ok then
											ok = workspace.Enemies:FindFirstChild("Living Zombie")
										end

										local ok2 = ok

										if not ok2 then
											ok2 = workspace.Enemies:FindFirstChild("Domenic Soul")
										end

										local ok3 = ok2

										if not ok3 then
											ok3 = workspace.Enemies:FindFirstChild("Posessed Mummy")
										end

										if ok3 then
											for _, child in pairs(workspace.Enemies:GetChildren()) do
												if (child.Name == "Reborn Skeleton" or child.Name == "Living Zombie" or child.Name == "Demonic Soul" or child.Name == "Posessed Mummy") and child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") and child:FindFirstChild("Humanoid").Health > 0 then
													while true do
														task.wait()
														t9.Kill(child, _G.CDK_YM)

														if not _G.CDK_YM then
															break
														elseif child.Humanoid.Health <= 0 or not child.Parent then
															break
														end
													end
												end
											end
										else
											_tp(CFrame.new(-9515.2255859375, 164.0062255859375, 5785.38330078125))
										end
									else
										replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
									end
								else
									_tp(replicated:FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame)
								end
							end
						end
					end
				end
			end)
		end
	end)
end

Q = GRP_Quests_Cursed_Dual_Katana:AddToggle("Auto_Tushita_CDK", {
	Text = "Auto Tushita CDK",
	Default = false,
	Callback = function(p176)
		_G.CDK_TS = p176
	end
})
spawn(function()
	while wait() do
		pcall(function()
			if _G.CDK_TS then
				if tostring(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")) ~= "opened" then
					wait(0.7)
					replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
					wait(0.3)
					replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
				elseif replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Finished == nil then
					replicated.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Good")
				elseif replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Finished == false then
					if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == -3 then
						QuestTushita_1 = true
						QuestTushita_2 = false
						QuestTushita_3 = false

						while true do
							wait()
							_tp(CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875))

							if not ((CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3) and _G.CDK_TS then
								if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 1 then
									break
								end
							else
								break
							end
						end

						if (CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							wait(0.7)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"), "Check")
							wait(0.5)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
						end

						wait(1)

						while true do
							wait()
							_tp(CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125))

							if not ((CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3) and _G.CDK_TS then
								if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 1 then
									break
								end
							else
								break
							end
						end

						if (CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							wait(0.7)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"), "Check")
							wait(0.5)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
						end

						wait(1)

						while true do
							wait()
							_tp(CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625))

							if not ((CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3) and _G.CDK_TS then
								if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 1 then
									break
								end
							else
								break
							end
						end

						if (CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							wait(0.7)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"), "Check")
							wait(0.5)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
						end

						wait(1)
					elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == -4 then
						QuestTushita_1 = false
						QuestTushita_2 = true
						QuestTushita_3 = false

						while true do
							wait()
							_G.AutoRaidCastle = true

							if not _G.CDK_TS then
								break
							elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 2 then
								break
							end
						end

						_G.AutoRaidCastle = false
					elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == -5 then
						QuestTushita_1 = false
						QuestTushita_2 = false
						QuestTushita_3 = true

						if workspace.Enemies:FindFirstChild("Cake Queen") then
							for _, child in pairs(workspace.Enemies:GetChildren()) do
								if child.Name == "Cake Queen" and child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") then
									if child.Humanoid.Health > 0 then
										while true do
											wait()
											t9.Kill(child, _G.CDK_TS)

											if not _G.CDK_TS or not child.Parent or child.Humanoid.Health <= 0 then
												break
											elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 3 then
												break
											end
										end
									end
								end
							end
						else
							local ok = not replicated:FindFirstChild("Cake Queen")

							if not ok then
								ok = not (replicated:FindFirstChild("Cake Queen").Humanoid.Health > 0)
							end

							if ok then
								if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - workspace.Map.HeavenlyDimension.Spawn.Position).Magnitude <= 1000 then
									for k in pairs(workspace.Map.HeavenlyDimension.Exit:GetChildren()) do
										Ex = k
									end

									if Ex == 2 then
										while true do
											wait()
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.HeavenlyDimension.Exit.CFrame

											if not _G.CDK_TS then
												break
											elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 3 then
												break
											end
										end
									end

									repeat
										wait()

										repeat
											wait()
											_tp(CFrame.new(-22529.6171875, 5275.77392578125, 3873.5712890625))

											for _, descendant in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") then
													fireproximityprompt(descendant)
												end
											end
										until (CFrame.new(-22529.6171875, 5275.77392578125, 3873.5712890625).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5

										wait(2)
										_G.DoneT1 = true
									until not _G.CDK_TS or _G.DoneT1

									repeat
										wait()

										repeat
											wait()
											_tp(CFrame.new(-22637.291015625, 5281.365234375, 3749.28857421875))

											for _, descendant in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") then
													fireproximityprompt(descendant)
												end
											end
										until (CFrame.new(-22637.291015625, 5281.365234375, 3749.28857421875).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5

										wait(2)
										_G.DoneT2 = true
									until _G.DoneT2 or _G.CDK_TS == false

									repeat
										wait()

										repeat
											task.wait()
											_tp(CFrame.new(-22791.14453125, 5277.16552734375, 3764.570068359375))

											for _, descendant in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") then
													fireproximityprompt(descendant)
												end
											end
										until (CFrame.new(-22791.14453125, 5277.16552734375, 3764.570068359375).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5

										wait(2)
										_G.DoneT3 = true
									until _G.DoneT3 or _G.CDK_TS == false

									for _, child in pairs(workspace.Enemies:GetChildren()) do
										if (child:FindFirstChild("HumanoidRootPart").Position - CFrame.new(-22695.7012, 5270.93652, 3814.42847, 0.11794927, 3.32185834e-08, 0.99301964, -8.73070718e-08, 1, -2.30819008e-08, -0.99301964, -8.3975138e-08, 0.11794927).Position).Magnitude <= 300 and child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") and child:FindFirstChild("Humanoid").Health > 0 then
											while true do
												wait()
												t9.Kill(child, _G.CDK_TS)

												if not _G.CDK_TS then
													break
												elseif child.Humanoid.Health <= 0 or not child.Parent then
													break
												end
											end
										end
									end
								end
							else
								_tp(replicated:FindFirstChild("Cake Queen").HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
							end
						end
					end
				end
			end
		end)
	end
end)
GRP_Quests_True_Triple_Katana_Sword = t15.Quests:AddLeftGroupbox("True Triple Katana Sword")
GRP_Quests_True_Triple_Katana_Sword:AddButton({
	Text = "Buy Legendary Sword",
	Func = function()
		for i = 1, 3 do
			replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", tostring(i))
			task.wait(0.3)
		end
	end
})
GRP_Quests_True_Triple_Katana_Sword:AddButton({
	Text = "Buy True Triple Katana Sword",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("MysteriousMan", "2")
	end
})
Q = GRP_Quests_True_Triple_Katana_Sword:AddToggle("Tween_to_Legendary_Sword_Dealer", {
	Text = "Tween to Legendary Sword Dealer",
	Default = false,
	Callback = function(p177)
		_G.Tp_LgS = p177
	end
})
spawn(function()
	while wait(Sec) do
		if _G.Tp_LgS then
			pcall(function()
				for _, child in pairs(replicated.NPCs:GetChildren()) do
					if child.Name == "Legendary Sword Dealer " then
						_tp(child.HumanoidRootPart.CFrame)
					end
				end
			end)
		end
	end
end)
GRP_Quests_Pole_God_Enal_s = t15.Quests:AddLeftGroupbox("Pole / God Enal's")
Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Pole_V1", {
	Text = "Auto Pole V1",
	Default = false,
	Callback = function(p178)
		_G.AutoPole = p178
	end
})
spawn(function()
	while wait(Sec) do
		if _G.AutoPole then
			pcall(function()
				local v847 = GetConnectionEnemies("Thunder God")

				if v847 then
					while true do
						task.wait()
						t9.Kill(v847, _G.AutoPole)

						if not _G.AutoPole or not v847.Parent then
							break
						elseif v847.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188))
				end
			end)
		end
	end
end)
Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Pole_V2_[Beta]", {
	Text = "Auto Pole V2 [Beta]",
	Default = false,
	Callback = function(p179)
		_G.AutoPoleV2 = p179
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.AutoPoleV2 then
					if not GetBP("Pole (1st Form)") then
						replicated.Remotes.CommF_:InvokeServer("LoadItem", "Pole (1st Form)")
					end

					if not GetBP("Pole (2nd Form)") then
						replicated.Remotes.CommF_:InvokeServer("LoadItem", "Pole (2nd Form)")
					end

					if GetBP("Pole (1st Form)") and GetBP("Pole (1st Form)").Level.Value <= 179 then
						_G.Level = true
					elseif GetBP("Pole (1st Form)") and GetBP("Pole (1st Form)").Level.Value >= 180 then
						_G.Level = false
					end

					if not GetBP("Rumble Fruit") then
						return
					end

					local ok2 = not GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("Z")

					if not ok2 then
						ok2 = not GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("X")
					end

					local ok3 = ok2

					if not ok3 then
						ok3 = not GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("C")
					end

					local ok4 = ok3

					if not ok4 then
						ok4 = not GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("V")
					end

					local ok5 = ok4

					if not ok5 then
						ok5 = not GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("F")
					end

					if ok5 then
						local ok = replicated.Remotes.CommF_:InvokeServer("Awakener", "Check") == nil

						if not ok then
							ok = replicated.Remotes.CommF_:InvokeServer("Awakener", "Check") == 0
						end

						if ok then
							_G.SelectChip = "Rumble"

							local response = replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)

							if response then
								response:Stop()
							end

							_G.Raiding = true
							_G.Auto_Awakener = true
						end
					else
						_G.SelectChip = nil
						_G.Raiding = false
						_G.Auto_Awakener = false

						if plr.Data.Fragments.Value >= 5000 then
							replicated.Remotes.CommF_:InvokeServer("Thunder God", "Talk")
							wait(Sec)
							replicated.Remotes.CommF_:InvokeServer("Thunder God", "Sure")
						end
					end
				end
			end)
		end
	end)
end

GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Saw_Sword", {
	Text = "Auto Saw Sword",
	Default = false,
	Callback = function(p180)
		_G.AutoSaw = p180
	end
})

do
	spawn(function()
		while wait(0.2) do
			pcall(function()
				if _G.AutoSaw then
					local v854 = GetConnectionEnemies("The Saw")

					if v854 then
						while true do
							task.wait()
							t9.Kill(v854, _G.AutoSaw)

							if _G.AutoSaw == false then
								break
							elseif v854.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906))
					end
				end
			end)
		end
	end)
end

Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Saber_Sword", {
	Text = "Auto Saber Sword",
	Default = false,
	Callback = function(p181)
		_G.AutoSaber = p181
	end
})
spawn(function()
	while wait(0.2) do
		pcall(function()
			if _G.AutoSaber and plr.Data.Level.Value >= 200 then
				if not plr.Backpack:FindFirstChild("Saber") then
					if not plr.Character:FindFirstChild("Saber") then
						if workspace.Map.Jungle.Final.Part.Transparency ~= 0 then
							local ok2 = workspace.Enemies:FindFirstChild("Saber Expert")

							if not ok2 then
								ok2 = replicated:FindFirstChild("Saber Expert")
							end

							if ok2 then
								for _, child in pairs(workspace.Enemies:GetChildren()) do
									if child.Name == "Saber Expert" and t9.Alive(child) then
										while true do
											task.wait()
											t9.Kill(child, _G.AutoSaber)

											if child.Humanoid.Health <= 0 then
												break
											elseif _G.AutoSaber == false then
												break
											end
										end

										if child.Humanoid.Health <= 0 then
											replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
										end
									end
								end
							else
								_tp(CFrame.new(-1401.85046, 29.9773273, 8.81916237, 0.85820812, 8.76083845e-08, 0.513301849, -8.55007443e-08, 1, -2.77243419e-08, -0.513301849, -2.00944328e-08, 0.85820812))
							end
						elseif workspace.Map.Jungle.QuestPlates.Door.Transparency == 0 then
							if (CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09, -0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724, -4.39869794e-08, 0.37091279).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 100 then
								_tp(plr.Character.HumanoidRootPart.CFrame)
								wait(0.5)
								plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate1.Button.CFrame
								wait(0.5)
								plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate2.Button.CFrame
								wait(0.5)
								plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate3.Button.CFrame
								wait(0.5)
								plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate4.Button.CFrame
								wait(0.5)
								plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate5.Button.CFrame
								wait(0.5)
							else
								_tp(CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09, -0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724, -4.39869794e-08, 0.37091279))
							end
						elseif workspace.Map.Desert.Burn.Part.Transparency == 0 then
							if plr.Backpack:FindFirstChild("Torch") then
								EquipWeapon("Torch")
								firetouchinterest(plr.Character.Torch.Handle, workspace.Map.Desert.Burn.Fire, 0)
								firetouchinterest(plr.Character.Torch.Handle, workspace.Map.Desert.Burn.Fire, 1)
								_tp(CFrame.new(1114.61475, 5.04679728, 4350.22803, -0.648466587, -1.28799094e-09, 0.761243105, -5.70652914e-10, 1, 1.20584542e-09, -0.761243105, 3.47544882e-10, -0.648466587))
							elseif plr.Character:FindFirstChild("Torch") then
								EquipWeapon("Torch")
								firetouchinterest(plr.Character.Torch.Handle, workspace.Map.Desert.Burn.Fire, 0)
								firetouchinterest(plr.Character.Torch.Handle, workspace.Map.Desert.Burn.Fire, 1)
								_tp(CFrame.new(1114.61475, 5.04679728, 4350.22803, -0.648466587, -1.28799094e-09, 0.761243105, -5.70652914e-10, 1, 1.20584542e-09, -0.761243105, 3.47544882e-10, -0.648466587))

								return
							else
								_tp(CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551, -0.167722285, -0.0449818149, 0.17364943, 0.951244235, 0.254912198, 3.42372805e-05, -0.258850515, 0.965917408))
							end
						elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan") ~= 0 then
							replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "GetCup")
							wait(0.5)
							EquipWeapon("Cup")
							wait(0.5)
							replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "FillCup", plr.Character.Cup)
							wait(Sec)
							replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
						elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == nil then
							replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
						elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 0 then
							local ok = workspace.Enemies:FindFirstChild("Mob Leader")

							if not ok then
								ok = replicated:FindFirstChild("Mob Leader")
							end

							if ok then
								_tp(CFrame.new(-2967.59521, -4.91089821, 5328.70703, 0.342208564, -0.0227849055, 0.939347804, 0.0251603816, 0.999569714, 0.0150796166, -0.939287126, 0.0184739735, 0.342634559))

								for _, child in pairs(workspace.Enemies:GetChildren()) do
									if child.Name == "Mob Leader" and t9.Alive(child) then
										while true do
											task.wait()
											t9.Kill(child, _G.AutoSaber)

											if child.Humanoid.Health <= 0 then
												break
											elseif _G.AutoSaber == false then
												break
											end
										end
									end
								end
							end
						elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 1 then
							replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
							EquipWeapon("Relic")
							_tp(CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-09, 0.481375456, 2.53851997e-08, 1, -5.79995607e-08, -0.481375456, 6.30572643e-08, 0.876514494))
						end
					end
				end
			end
		end)
	end
end)
Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Cybrog", {
	Text = "Auto Cybrog",
	Default = false,
	Callback = function(p182)
		_G.AutoColShad = p182
	end
})
spawn(function()
	while wait(0.2) do
		if _G.AutoColShad then
			pcall(function()
				local Cyborg = GetConnectionEnemies("Cyborg")

				if Cyborg then
					while true do
						task.wait()
						t9.Kill(Cyborg, _G.AutoColShad)

						if _G.AutoColShad == false then
							break
						elseif not Cyborg.Parent or Cyborg.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813))
				end
			end)
		end
	end
end)
Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Usoap's_Hat", {
	Text = "Auto Usoap's Hat",
	Default = false,
	Callback = function(p183)
		_G.AutoGetUsoap = p183
	end
})
spawn(function()
	while task.wait(Sec) do
		pcall(function()
			if _G.AutoGetUsoap then
				for _, child in pairs(workspace.Characters:GetChildren()) do
					if child.Name ~= plr.Name and child.Humanoid.Health > 0 and child:FindFirstChild("HumanoidRootPart") and child.Parent and (Root.Position - child.HumanoidRootPart.Position).Magnitude <= 230 then
						while true do
							task.wait()
							EquipWeapon(_G.SelectWeapon)
							_tp(child.HumanoidRootPart.CFrame * CFrame.new(1, 1, 2))

							if _G.AutoGetUsoap == false then
								break
							elseif child.Humanoid.Health <= 0 or not child.Parent or not child:FindFirstChild("HumanoidRootPart") or not child:FindFirstChild("Humanoid") then
								break
							end
						end
					end
				end
			end
		end)
	end
end)
Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Bisento_V2", {
	Text = "Auto Bisento V2",
	Default = false,
	Callback = function(p184)
		_G.Greybeard = p184
	end
})
spawn(function()
	while wait(Sec) do
		if _G.Greybeard then
			pcall(function()
				if GetWP("Bisento") then
					if GetWP("Bisento") then
						replicated.Remotes.CommF_:InvokeServer("LoadItem", "Bisento")

						local Greybeard = GetConnectionEnemies("Greybeard")

						if Greybeard then
							while true do
								wait()
								t9.Kill(Greybeard, _G.Greybeard)

								if _G.Greybeard == false then
									break
								elseif not Greybeard.Parent or Greybeard.Humanoid.Health <= 0 then
									break
								end
							end
						else
							_tp(CFrame.new(-5023.38330078125, 28.652032852172852, 4332.3818359375))
						end
					end
				else
					replicated.Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
				end
			end)
		end
	end
end)
Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Warden_Sword", {
	Text = "Auto Warden Sword",
	Default = false,
	Callback = function(p185)
		_G.WardenBoss = p185
	end
})
spawn(function()
	while wait(0.1) do
		if _G.WardenBoss then
			local exitTo

			repeat
				pcall(function()
					local v866 = GetConnectionEnemies("Chief Warden")

					if v866 then
						while true do
							wait()
							t9.Kill(v866, _G.WardenBoss)

							if _G.WardenBoss == false then
								break
							elseif not v866.Parent or v866.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, -0.00062915677, 0.939684749, 0.00191645394, 0.999998152, -2.80422337e-05, -0.939682961, 0.00181045406, 0.342041939))
					end
				end)
				exitTo = nil

				while wait(0.1) do
					if _G.WardenBoss then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)

do
	Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Marine_Coat", {
		Text = "Auto Marine Coat",
		Default = false,
		Callback = function(p186)
			_G.MarinesCoat = p186
		end
	})
end

spawn(function()
	while wait(0.1) do
		if _G.MarinesCoat then
			pcall(function()
				local v867 = GetConnectionEnemies("Vice Admiral")

				if v867 then
					while true do
						wait()
						t9.Kill(v867, _G.MarinesCoat)

						if _G.MarinesCoat == false then
							break
						elseif not v867.Parent or v867.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375))
				end
			end)
		end
	end
end)

do
	Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Swan_Coat", {
		Text = "Auto Swan Coat",
		Default = false,
		Callback = function(p187)
			_G.SwanCoat = p187
		end
	})
end

do
	spawn(function()
		while wait(0.1) do
			if _G.SwanCoat then
				pcall(function()
					local Swan = GetConnectionEnemies("Swan")

					if Swan then
						while true do
							wait()
							t9.Kill(Swan, _G.SwanCoat)

							if _G.SwanCoat == false then
								break
							elseif not Swan.Parent or Swan.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812))
					end
				end)
			end
		end
	end)
end

GRP_Quests_Rengoku_Sword = t15.Quests:AddLeftGroupbox("Rengoku Sword")
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Rengoku_Sword", {
	Text = "Auto Rengoku Sword",
	Default = false,
	Callback = function(p188)
		_G.IceBossRen = p188
	end
})
spawn(function()
	pcall(function()
		while wait(0.1) do
			if _G.IceBossRen then
				local v869 = GetConnectionEnemies("Awakened Ice Admiral")

				if v869 then
					while true do
						task.wait()
						t9.Kill(v869, _G.IceBossRen)

						if _G.IceBossRen == false then
							break
						elseif not v869.Parent or v869.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813))
				end
			end
		end
	end)
end)
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Key_Rengoku", {
	Text = "Auto Key Rengoku",
	Default = false,
	Callback = function(p189)
		_G.KeysRen = p189
	end
})
spawn(function()
	while wait(0.1) do
		pcall(function()
			if _G.KeysRen then
				if plr.Backpack:FindFirstChild(t1[3]) then
					EquipWeapon(t1[3])
					wait(0.1)
					_tp(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))
				else
					if plr.Character:FindFirstChild(t1[3]) then
						EquipWeapon(t1[3])
						wait(0.1)
						_tp(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))

						return
					end

					local v870 = GetConnectionEnemies(t1)

					if not v870 then
						_tp(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188))

						return
					end

					while true do
						task.wait()
						t9.Kill(v870, _G.KeysRen)

						if plr.Backpack:FindFirstChild(t1[3]) then
							break
						elseif _G.KeysRen == false or not v870.Parent or v870.Humanoid.Health <= 0 then
							break
						end
					end

					return
				end
			end
		end)
	end
end)
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Dragon_Trident", {
	Text = "Auto Dragon Trident",
	Default = false,
	Callback = function(p190)
		_G.AutoTridentW2 = p190
	end
})
spawn(function()
	while wait(0.1) do
		pcall(function()
			if _G.AutoTridentW2 then
				local v871 = GetConnectionEnemies("Tide Keeper")

				if v871 then
					while true do
						task.wait()
						t9.Kill(v871, _G.AutoTridentW2)

						if _G.AutoTridentW2 == false then
							break
						elseif not v871.Parent or v871.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188))
				end
			end
		end)
	end
end)

do
	Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Long_Sword", {
		Text = "Auto Long Sword",
		Default = false,
		Callback = function(p191)
			_G.LongsWord = p191
		end
	})
end

spawn(function()
	while wait(0.1) do
		pcall(function()
			if _G.LongsWord then
				local Diamond = GetConnectionEnemies("Diamond")

				if Diamond then
					while true do
						task.wait()
						t9.Kill(Diamond, _G.LongsWord)

						if _G.LongsWord == false then
							break
						elseif not Diamond.Parent or Diamond.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407))
				end
			end
		end)
	end
end)
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Black_Spikey", {
	Text = "Auto Black Spikey",
	Default = false,
	Callback = function(p192)
		_G.BlackSpikey = p192
	end
})

do
	spawn(function()
		while wait(0.1) do
			if _G.BlackSpikey then
				pcall(function()
					local Jeremy = GetConnectionEnemies("Jeremy")

					if Jeremy then
						while true do
							wait()
							t9.Kill(Jeremy, _G.BlackSpikey)

							if _G.BlackSpikey == false then
								break
							elseif not Jeremy.Parent or Jeremy.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109))
					end
				end)
			end
		end
	end)
end

do
	Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Dark_Blade_V3", {
		Text = "Auto Dark Blade V3",
		Default = false,
		Callback = function(p193)
			_G.DarkBladev3 = p193
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.DarkBladev3 and World2 then
				if not GetBP("Dark Blade") then
					replicated.Remotes.CommF_:InvokeServer("LoadItem", "Dark Blade")
				end

				if not (GetBP("Fist of Darkness") > 1) then
					_G.AutoFarmChest = true
				elseif workspace.Enemies:FindFirstChild("Darkbeard") then
					if GetConnectionEnemies("Darkbeard") and GetBP("Fist of Darkness") >= 1 then
						while true do
							wait()
							_tp(CFrame.new(-5719.36376953125, 48.505905151367188, -782.9759521484375))

							if not _G.DarkBladev3 then
								break
							elseif Root.Position == CFrame.new(-5719.36376953125, 48.505905151367188, -782.9759521484375).Position then
								break
							end
						end

						fireclickdetector(workspace.Map.GraveIsland.Mountain.Rocks.Button.ClickDetector)
					end
				else
					_tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
				end
			end
		end)
	end
end)

do
	Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Midnight_Blade", {
		Text = "Auto Midnight Blade",
		Default = false,
		Callback = function(p194)
			_G.AutoEcBoss = p194
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.AutoEcBoss then
				if GetM("Ectoplasm") >= 99 then
					replicated.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 3)
				elseif GetM("Ectoplasm") <= 99 then
					local v874 = GetConnectionEnemies("Cursed Captain")

					if v874 then
						while true do
							wait()
							t9.Kill(v874, _G.AutoEcBoss)

							if not _G.AutoEcBoss then
								break
							elseif not v874.Parent or v874.Humanoid.Health <= 0 then
								break
							end
						end
					else
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
						wait(0.5)
						_tp(CFrame.new(916.928589, 181.092773, 33422))
					end
				end
			end
		end)
	end
end)
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Darkbeard", {
	Text = "Auto Darkbeard",
	Default = false,
	Callback = function(p195)
		_G.Auto_Def_DarkCoat = p195
	end
})
spawn(function()
	while wait(0.1) do
		if _G.Auto_Def_DarkCoat then
			pcall(function()
				local ok = not GetBP("Fist of Darkness")

				if not ok then
					ok = workspace.Enemies:FindFirstChild("Darkbeard")
				end

				if not ok then
					_tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
				elseif GetConnectionEnemies("Darkbeard") then
					local Darkbeard = GetConnectionEnemies("Darkbeard")

					if Darkbeard then
						while true do
							wait()
							t9.Kill(Darkbeard, _G.Auto_Def_DarkCoat)

							if _G.Auto_Def_DarkCoat == false then
								break
							elseif not Darkbeard.Parent or Darkbeard.Humanoid.Helath <= 0 then
								break
							end
						end
					end
				elseif not (GetBP("Fist of Darkness") or GetConnectionEnemies("Darkbeard")) then
					while true do
						wait(0.1)
						_G.AutoFarmChest = true

						if not _G.Auto_Def_DarkCoat then
							break
						elseif GetBP("Fist of Darkness") or GetConnectionEnemies("Darkbeard") then
							break
						end
					end

					_G.AutoFarmChest = false
				end
			end)
		end
	end
end)
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Unlocked_DonSwan", {
	Text = "Auto Unlocked DonSwan",
	Default = false,
	Callback = function(p196)
		_G.Auto_DonAcces = p196
	end
})
spawn(function()
	while wait(0.1) do
		if _G.Auto_DonAcces then
			pcall(function()
				if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil and plr.Data.Level.Value >= 1500 then
					FruitPrice = {}
					FruitStore = {}

					local next_ = next
					local response, v879 = replicated:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits")

					for _, v1 in next_, response, v879 do
						if v1.Price >= 1000000 then
							table.insert(FruitPrice, v1.Name)
						end
					end

					for _, v1 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventoryFruits")) do
						for k, v2 in pairs(v1) do
							if k == "Name" then
								table.insert(FruitStore, v2)
							end
						end

						replicated.Remotes.CommF_:InvokeServer("Cousin", "Buy")

						for _, v2 in pairs(FruitPrice) do
							for _, v3 in pairs(FruitStore) do
								if v2 == v3 then
									if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
										_G.StoreF = false

										if plr.Backpack:FindFirstChild(FruitStore) then
											replicated.Remotes.CommF_:InvokeServer("TalkTrevor", "1")
											replicated.Remotes.CommF_:InvokeServer("TalkTrevor", "2")
											replicated.Remotes.CommF_:InvokeServer("TalkTrevor", "3")
										else
											replicated.Remotes.CommF_:InvokeServer("LoadFruit", tostring(v2))
										end
									end
								end
							end
						end

						if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
							_G.StoreF = true
							_G.Auto_DonAcces = false
						end
					end
				end
			end)
		end
	end
end)
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Swan_Glasses", {
	Text = "Auto Swan Glasses",
	Default = false,
	Callback = function(p197)
		_G.Auto_SwanGG = p197
	end
})
spawn(function()
	while wait(0.2) do
		if _G.Auto_SwanGG then
			local exitTo

			repeat
				pcall(function()
					local v891 = GetConnectionEnemies("Don Swan")

					if v891 then
						while true do
							wait()
							t9.Kill(v891, _G.Auto_SwanGG)

							if _G.Auto_SwanGG == false then
								break
							elseif not v891.Parent or v891.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875))
					end
				end)
				exitTo = nil

				while wait(0.2) do
					if _G.Auto_SwanGG then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)
GRP_Quests_Cavender_Twin_Hooks_Bigmom = t15.Quests:AddLeftGroupbox("Cavender + Twin Hooks + Bigmom")

do
	Q = GRP_Quests_Cavender_Twin_Hooks_Bigmom:AddToggle("Auto_Bigmom", {
		Text = "Auto Bigmom",
		Default = false,
		Callback = function(p198)
			_G.AutoBigmom = p198
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.AutoBigmom then
			pcall(function()
				local v892 = GetConnectionEnemies("Cake Queen")

				if v892 then
					while true do
						task.wait()
						t9.Kill(v892, _G.AutoBigmom)

						if not _G.AutoBigmom then
							break
						elseif not v892.Parent or v892.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(-709.31329345703125, 381.6005859375, -11011.396484375))
				end
			end)
		end
	end
end)

do
	Q = GRP_Quests_Cavender_Twin_Hooks_Bigmom:AddToggle("Auto_Canvendish_Sword", {
		Text = "Auto Canvendish Sword",
		Default = false,
		Callback = function(p199)
			_G.Auto_Cavender = p199
			ender = v
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Auto_Cavender then
					local v893 = GetConnectionEnemies("Beautiful Pirate")

					if v893 then
						while true do
							wait()
							t9.Kill(v893, _G.Auto_Cavender)

							if not _G.Auto_Cavender then
								break
							elseif v893.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(5283.609375, 22.56223487854, -110.78285217285))
					end
				end
			end)
		end
	end)
end

Q = GRP_Quests_Cavender_Twin_Hooks_Bigmom:AddToggle("Auto_Twin_Hooks", {
	Text = "Auto Twin Hooks",
	Default = false,
	Callback = function(p200)
		_G.TwinHook = p200
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.TwinHook then
					local v894 = GetConnectionEnemies("Captain Elephant")

					if v894 then
						while true do
							wait()
							t9.Kill(v894, _G.TwinHook)

							if not _G.TwinHook then
								break
							elseif v894.Humanoid.Health <= 0 then
								break
							end
						end
					else
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
						wait(0.2)
						_tp(CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125))
					end
				end
			end)
		end
	end)
end

Q = GRP_Quests_Cavender_Twin_Hooks_Bigmom:AddToggle("Auto_Serpent_Bow", {
	Text = "Auto Serpent Bow",
	Default = false,
	Callback = function(p201)
		_G.AutoSerpentBow = p201
	end
})
spawn(function()
	while wait(Sec) do
		if _G.AutoSerpentBow then
			local v895 = GetConnectionEnemies("Hydra Leader")

			if not v895 then
				local exitTo

				repeat
					_tp(CFrame.new(5821.89794921875, 1019.0950927734375, -73.719230651855469))
					exitTo = nil

					while wait(Sec) do
						if _G.AutoSerpentBow then
							local v897 = GetConnectionEnemies("Hydra Leader")

							if not v897 then
								exitTo = 1

								break
							end

							while true do
								wait()
								t9.Kill(v897, _G.AutoSerpentBow)

								if not _G.AutoSerpentBow then
									break
								elseif not v897.Parent or v897.Humanoid.Health <= 0 then
									break
								end
							end
						end
					end
				until exitTo ~= 1

				return
			end

			while true do
				wait()
				t9.Kill(v895, _G.AutoSerpentBow)

				if not _G.AutoSerpentBow then
					break
				elseif not v895.Parent or v895.Humanoid.Health <= 0 then
					break
				end
			end
		end
	end
end)

do
	Q = GRP_Quests_Cavender_Twin_Hooks_Bigmom:AddToggle("Auto_Lei_Accessory", {
		Text = "Auto Lei Accessory",
		Default = false,
		Callback = function(p202)
			_G.AutoKilo = p202
		end
	})
end

do
	spawn(function()
		while wait(0.2) do
			if _G.AutoKilo then
				pcall(function()
					local v898 = GetConnectionEnemies("Kilo Admiral")

					if v898 then
						while true do
							task.wait()
							t9.Kill(v898, _G.AutoKilo)

							if not _G.AutoKilo then
								break
							elseif not v898.Parent or v898.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125))
					end
				end)
			end
		end
	end)
end

GRP_Quests_Buso_Aura_Colours = t15.Quests:AddLeftGroupbox("Buso/Aura Colours")
Q = GRP_Quests_Buso_Aura_Colours:AddToggle("Auto_Teleport_Barista_Cousin", {
	Text = "Auto Teleport Barista Cousin",
	Default = false,
	Callback = function(p203)
		_G.Tp_MasterA = p203
	end
})

do
	spawn(function()
		while wait() do
			if _G.Tp_MasterA then
				pcall(function()
					for _, child in pairs(replicated.NPCs:GetChildren()) do
						if child.Name == "Barista Cousin" then
							_tp(child.HumanoidRootPart.CFrame)
						end
					end
				end)
			end
		end
	end)
end

do
	GRP_Quests_Buso_Aura_Colours:AddButton({
		Text = "Buy Buso Colors",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("ColorsDealer", "2")
		end
	})
end

Q = GRP_Quests_Buso_Aura_Colours:AddToggle("Auto_Rainbow_Colors", {
	Text = "Auto Rainbow Colors",
	Default = false,
	Callback = function(p204)
		_G.Auto_Rainbow_Haki = p204
	end
})
spawn(function()
	pcall(function()
		while wait(Sec) do
			if _G.Auto_Rainbow_Haki then
				if plr.PlayerGui.Main.Quest.Visible == false then
					if not _G.GetQFast then
						Rainbow1 = CFrame.new(-11892.0703125, 930.57672119141, -8760.1591796875)

						if plr.Character.HumanoidRootPart.CFrame ~= Rainbow1 then
							_tp(Rainbow1)
						elseif plr.Character.HumanoidRootPart.CFrame == Rainbow1 then
							wait(1)
							replicated.Remotes.CommF_:InvokeServer("HornedMan", "Bet")
						end
					elseif plr.PlayerGui.Main.Quest.Visible == false then
						replicated.Remotes.CommF_:InvokeServer("HornedMan", "Bet")
					end
				elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Stone") then
					local Stone = GetConnectionEnemies("Stone")

					if Stone then
						while true do
							wait()
							t9.Kill(Stone, _G.Auto_Rainbow_Haki)

							if _G.Auto_Rainbow_Haki == false then
								break
							elseif Stone.Humanoid.Health <= 0 or not Stone.Parent or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						_tp(CFrame.new(-1086.11621, 38.8425903, 6768.71436, 0.0231462717, -0.592676699, 0.805107772, 2.03251839e-05, 0.805323839, 0.592835128, -0.999732077, -0.0137055516, 0.0186523199))
					end
				elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Hydra Leader") then
					local v902 = GetConnectionEnemies("Hydra Leader")

					if v902 then
						while true do
							task.wait()
							t9.Kill(v902, _G.Auto_Rainbow_Haki)

							if _G.Auto_Rainbow_Haki == false then
								break
							elseif v902.Humanoid.Health <= 0 or not v902.Parent or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625))

						local vector3 = Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625)
						local cFrame = CFrame.new(5821.89794921875, 1019.0950927734375, -73.719230651855469)

						if plr.Character.HumanoidRootPart.CFrame.Position == vector3 then
							_tp(cFrame)
						end
					end
				elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Kilo Admiral") then
					local v905 = GetConnectionEnemies("Kilo Admiral")

					if v905 then
						while true do
							task.wait()
							t9.Kill(v905, _G.Auto_Rainbow_Haki)

							if _G.Auto_Rainbow_Haki == false then
								break
							elseif v905.Humanoid.Health <= 0 or not v905.Parent or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						_tp(CFrame.new(2877.61743, 423.558685, -7207.31006, -0.989591599, -0, -0.143904909, -0, 1.00000012, -0, 0.143904924, 0, -0.989591479))
					end
				elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") then
					local v906 = GetConnectionEnemies("Captain Elephant")

					if v906 then
						while true do
							task.wait()
							t9.Kill(v906, _G.Auto_Rainbow_Haki)

							if _G.Auto_Rainbow_Haki == false then
								break
							elseif v906.Humanoid.Health <= 0 or not v906.Parent or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						local vector3 = Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375)
						local cFrame = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125)

						if plr.Character.HumanoidRootPart.CFrame.Position ~= vector3 then
							replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
						elseif plr.Character.HumanoidRootPart.CFrame.Position == vector3 then
							_tp(cFrame)
						end
					end
				elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Beautiful Pirate") then
					local v909 = GetConnectionEnemies("Captain Elephant")

					if v909 then
						while true do
							task.wait()
							t9.Kill(v909, _G.Auto_Rainbow_Haki)

							if _G.Auto_Rainbow_Haki == false then
								break
							elseif v909.Humanoid.Health <= 0 or not v909.Parent or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5314.54638671875, 22.562219619750977, -127.06755065917969))
					end
				end
			end
		end
	end)
end)
Q = GRP_Quests_Buso_Aura_Colours:AddToggle("Accept_Rainbow_Quest_Faster", {
	Text = "Accept Rainbow Quest Faster",
	Default = false,
	Callback = function(p205)
		_G.GetQFast = p205
	end
})
GRP_Quests_Instinct_Observation = t15.Quests:AddLeftGroupbox("Instinct / Observation")

do
	Q = GRP_Quests_Instinct_Observation:AddToggle("Auto_Farm_Observation", {
		Text = "Auto Farm Observation",
		Default = false,
		Callback = function(p206)
			_G.obsFarm = p206
		end
	})
end

spawn(function()
	while wait(0.2) do
		pcall(function()
			if _G.obsFarm then
				replicated.Remotes.CommE:FireServer("Ken", true)

				if plr:GetAttribute("KenDodgesLeft") == 0 then
					KenTest = false
				elseif plr:GetAttribute("KenDodgesLeft") > 0 then
					replicated.Remotes.CommE:FireServer("Ken", true)
					KenTest = true
				end
			end
		end)
	end
end)
spawn(function()
	while wait(0.2) do
		pcall(function()
			if _G.obsFarm then
				if not World1 then
					if not World2 then
						if World3 then
							if not workspace.Enemies:FindFirstChild("Venomous Assailant") then
								_tp(CFrame.new(4530.3540039063, 656.75695800781, -131.60952758789))
							elseif KenTest then
								while true do
									wait()
									_tp(workspace.Enemies:FindFirstChild("Venomous Assailant").HumanoidRootPart.CFrame * CFrame.new(3, 0, 0))

									if _G.obsFarm == false then
										break
									elseif KenTest == false then
										break
									end
								end
							else
								while true do
									wait()
									_tp(workspace.Enemies:FindFirstChild("Venomous Assailant").HumanoidRootPart.CFrame * CFrame.new(0, 50, 0))

									if _G.obsFarm == false then
										break
									elseif KenTest then
										break
									end
								end
							end
						end
					elseif not workspace.Enemies:FindFirstChild("Lava Pirate") then
						_tp(CFrame.new(-5478.39209, 15.9775667, -5246.9126))
					elseif KenTest then
						while true do
							wait()
							plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Lava Pirate").HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)

							if _G.obsFarm == false then
								break
							elseif KenTest == false then
								break
							end
						end
					else
						while true do
							wait()
							plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Lava Pirate").HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)

							if _G.obsFarm == false then
								break
							elseif KenTest then
								break
							end
						end
					end
				elseif not workspace.Enemies:FindFirstChild("Galley Captain") then
					_tp(CFrame.new(5533.29785, 88.1079102, 4852.3916))
				elseif KenTest then
					while true do
						wait()
						plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Galley Captain").HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)

						if _G.obsFarm == false then
							break
						elseif KenTest == false then
							break
						end
					end
				else
					while true do
						wait()
						plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Galley Captain").HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)

						if _G.obsFarm == false then
							break
						elseif KenTest then
							break
						end
					end
				end
			end
		end)
	end
end)

do
	Q = GRP_Quests_Instinct_Observation:AddToggle("Auto_Observation_V2", {
		Text = "Auto Observation V2",
		Default = false,
		Callback = function(p207)
			_G.AutoKenVTWO = p207
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.AutoKenVTWO then
			pcall(function()
				local cFrame = CFrame.new(-12444.78515625, 332.40396118164, -7673.1806640625)
				local cFrame2 = CFrame.new(-10920.125, 624.20275878906, -10266.995117188)
				local cFrame3 = CFrame.new(-13277.568359375, 370.34185791016, -7821.1572265625)
				local cFrame4 = CFrame.new(-13493.12890625, 318.89553833008, -8373.7919921875)

				if plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Defeat 50 Forest Pirates") then
					local v914 = GetConnectionEnemies("Forest Pirate")

					if v914 then
						while true do
							wait()
							t9.Kill(v914, _G.AutoKenVTWO)

							if not _G.AutoKenVTWO then
								break
							elseif v914.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						_tp(cFrame3)
					end
				elseif plr.PlayerGui.Main.Quest.Visible == true then
					local v915 = GetConnectionEnemies("Captain Elephant")

					if v915 then
						while true do
							wait()
							t9.Kill(v915, _G.AutoKenVTWO)

							if not _G.AutoKenVTWO then
								break
							elseif v915.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						_tp(cFrame4)
					end
				elseif plr.PlayerGui.Main.Quest.Visible == false then
					replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
					wait(0.1)
					replicated.Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
				end

				local Backpack, ok, Backpack2

				if replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 2 then
					_tp(CFrame.new(-12513.51953125, 340.11373901367188, -9873.048828125))

					if plr.Backpack:FindFirstChild("Fruit Bowl") then
						if plr.Character:FindFirstChild("Fruit Bowl") then
							return
						end
					end

					if GetBP("Fruit Bowl") then
						Backpack = plr.Backpack
						ok = not Backpack:FindFirstChild("Banana")

						if not ok then
							Backpack2 = plr.Backpack
							ok = not Backpack2:FindFirstChild("Apple")
						end
					elseif not GetBP("Apple") then
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))

						for _, descendant in pairs(workspace:GetDescendants()) do
							if descendant.Name == "Apple" then
								descendant.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 10)
								wait()
								firetouchinterest(plr.Character.HumanoidRootPart, descendant.Handle, 0)
								wait()
							end
						end

						Backpack = plr.Backpack
						ok = not Backpack:FindFirstChild("Banana")

						if not ok then
							Backpack2 = plr.Backpack
							ok = not Backpack2:FindFirstChild("Apple")
						end
					elseif GetBP("Banana") then
						if GetBP("Pineapple") then
							Backpack = plr.Backpack
							ok = not Backpack:FindFirstChild("Banana")

							if not ok then
								Backpack2 = plr.Backpack
								ok = not Backpack2:FindFirstChild("Apple")
							end
						else
							_tp(CFrame.new(-712.8272705078125, 98.577049255371094, 5711.9541015625))

							for _, descendant in pairs(workspace:GetDescendants()) do
								if descendant.Name == "Pineapple" then
									descendant.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 10)
									wait()
									firetouchinterest(plr.Character.HumanoidRootPart, descendant.Handle, 0)
									wait()
								end
							end

							Backpack = plr.Backpack
							ok = not Backpack:FindFirstChild("Banana")

							if not ok then
								Backpack2 = plr.Backpack
								ok = not Backpack2:FindFirstChild("Apple")
							end
						end
					else
						_tp(CFrame.new(2286.0078125, 73.133918762207031, -7159.80908203125))

						for _, descendant in pairs(workspace:GetDescendants()) do
							if descendant.Name == "Banana" then
								descendant.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 10)
								wait()
								firetouchinterest(plr.Character.HumanoidRootPart, descendant.Handle, 0)
								wait()
							end
						end

						Backpack = plr.Backpack
						ok = not Backpack:FindFirstChild("Banana")

						if not ok then
							Backpack2 = plr.Backpack
							ok = not Backpack2:FindFirstChild("Apple")
						end
					end
				else
					if plr.Backpack:FindFirstChild("Fruit Bowl") then
						if plr.Character:FindFirstChild("Fruit Bowl") then
							return
						end
					end

					if GetBP("Fruit Bowl") then
						Backpack = plr.Backpack
						ok = not Backpack:FindFirstChild("Banana")

						if not ok then
							Backpack2 = plr.Backpack
							ok = not Backpack2:FindFirstChild("Apple")
						end
					elseif not GetBP("Apple") then
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))

						for _, descendant in pairs(workspace:GetDescendants()) do
							if descendant.Name == "Apple" then
								descendant.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 10)
								wait()
								firetouchinterest(plr.Character.HumanoidRootPart, descendant.Handle, 0)
								wait()
							end
						end

						Backpack = plr.Backpack
						ok = not Backpack:FindFirstChild("Banana")

						if not ok then
							Backpack2 = plr.Backpack
							ok = not Backpack2:FindFirstChild("Apple")
						end
					elseif GetBP("Banana") then
						if GetBP("Pineapple") then
							Backpack = plr.Backpack
							ok = not Backpack:FindFirstChild("Banana")

							if not ok then
								Backpack2 = plr.Backpack
								ok = not Backpack2:FindFirstChild("Apple")
							end
						else
							_tp(CFrame.new(-712.8272705078125, 98.577049255371094, 5711.9541015625))

							for _, descendant in pairs(workspace:GetDescendants()) do
								if descendant.Name == "Pineapple" then
									descendant.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 10)
									wait()
									firetouchinterest(plr.Character.HumanoidRootPart, descendant.Handle, 0)
									wait()
								end
							end

							Backpack = plr.Backpack
							ok = not Backpack:FindFirstChild("Banana")

							if not ok then
								Backpack2 = plr.Backpack
								ok = not Backpack2:FindFirstChild("Apple")
							end
						end
					else
						_tp(CFrame.new(2286.0078125, 73.133918762207031, -7159.80908203125))

						for _, descendant in pairs(workspace:GetDescendants()) do
							if descendant.Name == "Banana" then
								descendant.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 10)
								wait()
								firetouchinterest(plr.Character.HumanoidRootPart, descendant.Handle, 0)
								wait()
							end
						end

						Backpack = plr.Backpack
						ok = not Backpack:FindFirstChild("Banana")

						if not ok then
							Backpack2 = plr.Backpack
							ok = not Backpack2:FindFirstChild("Apple")
						end
					end
				end

				local ok3 = ok

				if not ok3 then
					ok3 = not plr.Backpack:FindFirstChild("Pineapple")
				end

				local ok2

				if not ok3 then
					repeat
						wait()
						_tp(cFrame)
						ok2 = _G.AutoKenVTWO

						if not ok2 then
							ok2 = plr.Character.HumanoidRootPart.CFrame == cFrame

							if ok2 then
								break
							end
						end
					until ok2
					-- (could not be recovered)
				end

				if plr:FindFirstChild("Banana") then
					if plr:FindFirstChild("Apple") then
						if plr:FindFirstChild("Pineapple") then
							repeat
								wait()
								_tp(cFrame)
								ok2 = _G.AutoKenVTWO or plr.Character.HumanoidRootPart.CFrame == cFrame
							until ok2

							replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
						end
					end
				end

				if not plr.Backpack:FindFirstChild("Fruit Bowl") then
					if not plr.Character:FindFirstChild("Fruit Bowl") then
						return
					end
				end

				if plr.Character.HumanoidRootPart.CFrame ~= cFrame2 then
					_tp(cFrame2)

					return
				end

				if plr.Character.HumanoidRootPart.CFrame ~= cFrame2 then
					return
				end

				replicated.Remotes.CommF_:InvokeServer("KenTalk2", "Start")
				wait(0.1)
				replicated.Remotes.CommF_:InvokeServer("KenTalk2", "Buy")
			end)
		end
	end
end)
Bartilo = GRP_Quests_Instinct_Observation:AddToggle("Auto_Done_Bartilo_Quest", {
	Text = "Auto Done Bartilo Quest",
	Default = false,
	Callback = function(p208)
		_G.Bartilo_Quest = p208
	end
})
spawn(function()
	while wait(0.1) do
		pcall(function()
			if _G.Bartilo_Quest and Lv >= 850 then
				local Quest = plr.PlayerGui.Main.Quest

				if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 0 then
					_G.Level = false

					if Quest.Visible == true then
						if GetConnectionEnemies("Swan Pirate") then
							local v934 = GetConnectionEnemies(t3)

							if v934 then
								repeat
									task.wait()

									if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirate") then
										t9.Kill(v934, _G.Bartilo_Quest)
									else
										replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
									end
								until _G.Bartilo_Quest == false or not v934.Parent or v934.Humanoid.Health <= 0 or Quest.Visible == false or not v934:FindFirstChild("HumanoidRootPart")
							end
						else
							_tp(CFrame.nee(970.369446, 142.653198, 1217.3667, 0.162079468, -4.85452638e-08, -0.986777723, 1.03357589e-08, 1, -4.74980872e-08, 0.986777723, -2.50063148e-09, 0.162079468))
						end
					else
						while true do
							wait()
							_tp(CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312))

							if (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 20 then
								break
							elseif _G.Bartilo_Quest == false then
								break
							end
						end

						if (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 1 then
							replicated.Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1)
						end
					end
				elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 1 then
					_G.Level = false

					local Jeremy = GetConnectionEnemies("Jeremy")

					if Jeremy then
						while true do
							task.wait()
							t9.Kill(Jeremy, _G.Bartilo_Quest)

							if _G.Bartilo_Quest == false then
								break
							elseif not Jeremy.Parent or Jeremy.Humanoid.Health <= 0 or Quest.Visible == false or not Jeremy:FindFirstChild("HumanoidRootPart") then
								break
							end
						end
					else
						_tp(CFrame.new(2158.97412, 449.056244, 705.411682, -0.754199564, -4.17389057e-09, -0.656645238, -4.47752875e-08, 1, 4.50709301e-08, 0.656645238, 6.3393955e-08, -0.754199564))
					end
				elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 2 then
					while true do
						wait()
						_tp(CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456))

						if (CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 1 then
							break
						elseif _G.Bartilo_Quest == false then
							break
						end
					end

					wait(0.5)
					plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate1.CFrame
					wait(0.5)
					plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate2.CFrame
					wait(0.5)
					plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate3.CFrame
					wait(0.5)
					plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate4.CFrame
					wait(0.5)
					plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate5.CFrame
					wait(0.5)
					plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate6.CFrame
					wait(0.5)
					plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate7.CFrame
					wait(0.5)
					plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate8.CFrame
					wait(2.5)
				end
			end
		end)
	end
end)
CitizenQ = GRP_Quests_Instinct_Observation:AddToggle("Auto_Done_Citizen_Quest", {
	Text = "Auto Done Citizen Quest",
	Default = false,
	Callback = function(p209)
		_G.CitizenQuest = p209
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.CitizenQuest then
				local ok2 = not (Lv >= 1800)

				if not ok2 then
					ok2 = replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBandits ~= false
				end

				if ok2 then
					local ok = not (Lv >= 1800)

					if not ok then
						ok = replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBoss ~= false
					end

					if not ok then
						local v938 = GetConnectionEnemies("Captain Elephant")

						if not plr.PlayerGui.Main.Quest.Visible or not string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") or plr.PlayerGui.Main.Quest.Visible ~= true then
							_tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))

							if (CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 4 then
								wait(1.5)
								replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
							end
						elseif v938 then
							while true do
								task.wait()
								t9.Kill(v938, _G.CitizenQuest)

								if _G.CitizenQuest == false then
									break
								elseif v938.Humanoid.Health <= 0 or not v938.Parent or plr.PlayerGui.Main.Quest.Visible == false then
									break
								end
							end
						else
							_tp(CFrame.new(-13374.889648438, 421.27752685547, -8225.208984375))
						end
					elseif Lv >= 1800 then
						if replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 2 then
							_tp(CFrame.new(-12512.138671875, 340.39279174805, -9872.8203125))
						end
					end
				elseif string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Forest Pirate") and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and plr.PlayerGui.Main.Quest.Visible == true then
					local v939 = GetConnectionEnemies("Forest Pirate")

					if v939 then
						while true do
							task.wait()
							t9.Kill(v939, _G.CitizenQuest)

							if _G.CitizenQuest == false then
								break
							elseif not v939.Parent or v939.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						_tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))
					end
				else
					_tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))

					if (Vector3.new(-12443.8671875, 332.40396118164, -7675.4892578125) - plr.Character.HumanoidRootPart.Position).Magnitude <= 30 then
						wait(1.5)
						replicated.Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
					end
				end
			end
		end)
	end
end)
Q = GRP_Quests_Instinct_Observation:AddToggle("Auto_Training_Dummy", {
	Text = "Auto Training Dummy",
	Default = false,
	Callback = function(p210)
		_G.DummyMan = p210
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.DummyMan then
				pcall(function()
					if plr.PlayerGui.Main.Quest.Visible == false then
						replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack({ "ArenaTrainer" }))
					else
						local v940 = GetConnectionEnemies("Training Dummy")

						if v940 then
							while true do
								wait()
								t9.Kill(v940, _G.DummyMan)

								if not _G.DummyMan then
									break
								elseif not v940.Parent or v940.Humanoid.Health <= 0 then
									break
								end
							end
						else
							_tp(CFrame.new(3688.005126953125, 12.746943473815918, 170.20953369140625))
						end
					end
				end)
			end
		end
	end)
end

GRP_Quests_Fighting_Melee_Styles = t15.Quests:AddLeftGroupbox("Fighting Melee Styles")

do
	SuperHuman = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_Superhuman", {
		Text = "Auto Superhuman",
		Default = false,
		Callback = function(p211)
			_G.Auto_SuperHuman = p211
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Auto_SuperHuman then
					local Value = plr.Data.Beli.Value
					local Value2 = plr.Data.Fragments.Value

					if plr:FindFirstChild("WeaponAssetCache") and not GetBP("Superhuman") then
						if GetBP("Black Leg") then
							if GetBP("Black Leg") and GetBP("Black Leg").Level.Value < 299 then
								_G.Level = true
							elseif GetBP("Black Leg") and GetBP("Black Leg").Level.Value >= 300 then
								_G.Level = false
							end
						elseif Value >= 150000 then
							replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg")
						end

						if GetBP("Electro") then
							if GetBP("Electro") and GetBP("Electro").Level.Value < 299 then
								_G.Level = true
							elseif GetBP("Electro") and GetBP("Electro").Level.Value >= 300 then
								_G.Level = false
							end
						elseif Value >= 500000 then
							replicated.Remotes.CommF_:InvokeServer("BuyElectro")
						end

						if GetBP("Fishman Karate") then
							if GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value < 299 then
								_G.Level = true
							elseif GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value >= 300 then
								_G.Level = false
							end
						elseif Value >= 750000 then
							replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
						end

						if GetBP("Dragon Claw") then
							if GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value < 299 then
								_G.Level = true
							elseif GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value >= 300 then
								_G.Level = false
							end
						elseif Value2 >= 1500 then
							replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
						end

						replicated.Remotes.CommF_:InvokeServer("BuySuperhuman")
					end
				end
			end)
		end
	end)
end

DeathStep = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_DeathStep", {
	Text = "Auto DeathStep",
	Default = false,
	Callback = function(p212)
		_G.AutoDeathStep = p212
	end
})
spawn(function()
	while wait(Sec) do
		if _G.AutoDeathStep then
			pcall(function()
				if plr:FindFirstChild("WeaponAssetCache") and not GetBP("Death Step") then
					if not GetBP("Black Leg") then
						replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg")
					end

					if GetBP("Black Leg") and GetBP("Black Leg").Level.Value >= 400 then
						replicated.Remotes.CommF_:InvokeServer("BuyDeathStep")
						_G.Level = false
					elseif GetBP("Black Leg") and GetBP("Black Leg").Level.Value < 399 then
						_G.Level = true
					end

					if (GetBP("Black Leg") or GetBP("Black Leg").Level.Value >= 400) and workspace.Map.IceCastle.Hall.LibraryDoor.PhoeyuDoor.Transparency == 0 then
						if GetBP("Library Key") then
							while true do
								wait()
								_tp(CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375))

								if not _G.AutoDeathStep then
									break
								elseif Root.Position == CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375).Position then
									break
								end
							end

							if Root.CFrame == CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375) then
								replicated.Remotes.CommF_:InvokeServer("BuyDeathStep")
							end
						elseif not GetBP("Library Key") then
							local v943 = GetConnectionEnemies("Awakened Ice Admiral")

							if v943 then
								while true do
									wait()
									t9.Kill(v943, _G.AutoDeathStep)

									if not v943.Parent then
										break
									elseif v943.Humanoid.Health <= 0 or _G.AutoDeathStep == false or GetBP("Library Key") or GetBP("Death Step") then
										break
									end
								end
							else
								_tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813))
							end
						end
					end
				end
			end)
		end
	end
end)

do
	SharkManV2 = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_Sharkman_Karate", {
		Text = "Auto Sharkman Karate",
		Default = false,
		Callback = function(p213)
			_G.Auto_SharkMan_Karate = p213
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.Auto_SharkMan_Karate then
			pcall(function()
				if plr:FindFirstChild("WeaponAssetCache") and not GetBP("Sharkman Karate") then
					if not GetBP("Fishman Karate") then
						replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
					end

					if GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value >= 400 then
						replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
						_G.Level = false
					elseif GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value < 399 then
						_G.Level = true
					end

					if GetBP("Fishman Karate") or GetBP("Fishman Karate").Level.Value >= 400 then
						if not GetBP("Water Key") then
							if not GetBP("Water Key") then
								local v944 = GetConnectionEnemies("Tide Keeper")

								if v944 then
									while true do
										wait()
										t9.Kill(v944, _G.Auto_SharkMan_Karate)

										if not v944.Parent then
											break
										elseif v944.Humanoid.Health <= 0 or _G.Auto_SharkMan_Karate == false or GetBP("Water Key") or GetBP("Sharkman Karate") then
											break
										end
									end
								else
									_tp(CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625))
								end
							end
						elseif string.find(replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate"), "keys") and GetBP("Water Key") then
							while true do
								wait()
								_tp(CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365))

								if not _G.Auto_SharkMan_Karate then
									break
								elseif Root.Position == CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365).Position then
									break
								end
							end

							replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
						end
					end
				end
			end)
		end
	end
end)

do
	ElectricClaw = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_ElectricClaw", {
		Text = "Auto ElectricClaw",
		Default = false,
		Callback = function(p214)
			_G.Auto_Electric_Claw = p214
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.Auto_Electric_Claw then
			pcall(function()
				if plr:FindFirstChild("WeaponAssetCache") then
					if not GetBP("Electro") then
						replicated.Remotes.CommF_:InvokeServer("BuyElectro")
					end

					if GetBP("Electro") and GetBP("Electro").Level.Value >= 400 then
						if replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start") == nil then
							notween(CFrame.new(-12548, 337, -7481))
						end

						replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw")
					elseif GetBP("Electro") and GetBP("Electro").Level.Value < 400 then
						while true do
							_G.AutoFarm_Bone = true
							wait()

							if not _G.Auto_Electric_Claw then
								break
							elseif GetBP("Electric Claw") then
								break
							end
						end

						_G.AutoFarm_Bone = false
					end
				end
			end)
		end
	end
end)
DragonTalon = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_DragonTalon", {
	Text = "Auto DragonTalon",
	Default = false,
	Callback = function(p215)
		_G.AutoDragonTalon = p215
	end
})
spawn(function()
	while wait(Sec) do
		if _G.AutoDragonTalon then
			pcall(function()
				if plr:FindFirstChild("WeaponAssetCache") then
					if not GetBP("Dragon Claw") then
						replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
					end

					if GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value >= 400 then
						replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
						replicated.Remotes.CommF_:InvokeServer("BuyDragonTalon")
					elseif GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value < 400 then
						while true do
							_G.AutoFarm_Bone = true
							wait()

							if not _G.AutoDragonTalon then
								break
							elseif GetBP("Dragon Talon") then
								break
							end
						end

						_G.AutoFarm_Bone = false
					end
				end
			end)
		end
	end
end)
Godhuman = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_Godhuman", {
	Text = "Auto Godhuman",
	Default = false,
	Callback = function(p216)
		_G.Auto_God_Human = p216
	end
})

do
	spawn(function()
		while wait() do
			pcall(function()
				if _G.Auto_God_Human then
					if replicated.Remotes.CommF_:InvokeServer("BuyGodhuman", true) ~= "Bring me 20 Fish Tails, 20 Magma Ore, 10 Dragon Scales and 10 Mystic Droplets." then
						if replicated.Remotes.CommF_:InvokeServer("BuyGodhuman", true) == 3 then
							return nil
						end

						replicated.Remotes.CommF_:InvokeServer("BuyGodhuman")
					elseif GetM("Dragon Scale") ~= false and not (GetM("Dragon Scale") < 10) then
						if GetM("Fish Tail") ~= false and not (GetM("Fish Tail") < 20) then
							if GetM("Mystic Droplet") == false or GetM("Mystic Droplet") < 10 then
								if World2 then
									Lv = 1425
									_G.Level = true
								else
									replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
								end
							elseif GetM("Magma Ore") == false or GetM("Magma Ore") < 20 then
								if World2 then
									Lv = 1175
									_G.Level = true
								else
									replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
								end
							end
						elseif World3 then
							Lv = 1775
							_G.Level = true
						else
							replicated.Remotes.CommF_:InvokeServer("TravelZou")
						end
					elseif World3 then
						Lv = 1575
						_G.Level = true
					else
						replicated.Remotes.CommF_:InvokeServer("TravelZou")
					end
				end
			end)
		end
	end)
end

do
	SanguineArt = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_SanguineArt", {
		Text = "Auto SanguineArt",
		Default = false,
		Callback = function(p217)
			_G.Snaguine = p217
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.Snaguine then
			pcall(function()
				if not GetBP("Sanguine Art") then
					replicated.Remotes.CommF_:InvokeServer("Sanguine Art")
				end

				if GetBP("Sanguine Art") then
					replicated.Remotes.CommF_:InvokeServer("BuySanguineArt")
				else
					if GetM("Leviathan Heart") >= 1 then
						print("Completed!!")
					elseif World3 then
						_G.DangerSc = "Lv Infinite"
						_G.SailBoats = true
					else
						_G.SailBoats = false
					end

					if GetM("Vampire Fang") <= 19 then
						if World2 then
							local Vampire = GetConnectionEnemies("Vampire")

							if Vampire then
								while true do
									task.wait()
									t9.Kill(Vampire, _G.Snaguine)

									if not _G.Snaguine then
										break
									elseif Vampire.Humanoid.Health <= 0 or not Vampire.Parent then
										break
									end
								end
							else
								_tp(CFrame.new(-6041.29248046875, 6.4027109146118164, -1304.63330078125))
							end
						else
							replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
						end
					end

					if GetM("Vampire Fang") >= 20 then
						if GetM("Demonic Wisp") <= 19 then
							if World3 then
								local v946 = GetConnectionEnemies("Demonic Soul")

								if v946 then
									while true do
										task.wait()
										t9.Kill(v946, _G.Snaguine)

										if not _G.Snaguine then
											break
										elseif v946.Humanoid.Health <= 0 or not v946.Parent then
											break
										end
									end
								else
									_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
								end
							else
								replicated.Remotes.CommF_:InvokeServer("TravelZou")
							end
						end
					end

					if GetM("Vampire Fang") >= 20 and GetM("Demonic Wisp") >= 20 and GetM("Dark Fragment") <= 1 then
						if not World2 then
							replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
						elseif GetConnectionEnemies("Darkbeard") then
							while true do
								task.wait()
								t9.Kill(black, _G.Snaguine)

								if _G.Snaguine then
									break
								elseif black.Humanoid.Health <= 0 or not black.Parent then
									break
								end
							end
						else
							_tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625))
						end
					end
				end
			end)
		end
	end
end)
GRP_Race_Mystic_Island_Full_Moon = t15.Race:AddLeftGroupbox("Mystic Island / Full Moon")

do
	local v947 = GRP_Race_Mystic_Island_Full_Moon:AddLabel("")
	local v948 = GRP_Race_Mystic_Island_Full_Moon:AddLabel("")

	spawn(function()
		while wait(0.2) do
			if not workspace.Map:FindFirstChild("MysticIsland") then
				if not workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") then
					v948:SetText("Mirage Island : False")

					continue
				end
			end

			v948:SetText("Mirage Island : True")
		end
	end)
	spawn(function()
		while wait(0.2) do
			pcall(function()
				local v949 = Getmoon()

				if v949 == "http://www.roblox.com/asset/?id=9709135895" then
					v947:SetText("Moon : 0 / 8")
				elseif v949 == "http://www.roblox.com/asset/?id=9709139597" then
					v947:SetText("Moon : 1 / 8")
				elseif v949 == "http://www.roblox.com/asset/?id=9709143733" then
					v947:SetText("Moon : 2 / 8")
				elseif v949 == "http://www.roblox.com/asset/?id=9709149052" then
					v947:SetText("Moon : 3 / 8 [ Next Night ]")
				elseif v949 == "http://www.roblox.com/asset/?id=9709149431" then
					v947:SetText("Moon : 4 / 8 [ Full Moon ]")
				elseif v949 == "http://www.roblox.com/asset/?id=9709149680" then
					v947:SetText("Moon : 5 / 8 [ Last Night ]")
				elseif v949 == "http://www.roblox.com/asset/?id=9709150086" then
					v947:SetText("Moon : 6 / 8")
				elseif v949 == "http://www.roblox.com/asset/?id=9709150401" then
					v947:SetText("Moon : 7 / 8")
				end
			end)
		end
	end)
end

GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Find_Mirage_Island", {
	Text = "Auto Find Mirage Island",
	Default = false,
	Callback = function(p218)
		_G.FindMirage = p218
	end
})
spawn(function()
	while wait() do
		if _G.FindMirage then
			pcall(function()
				if workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island", true) then
					_tp(workspace.Map:FindFirstChild("MysticIsland").Center.CFrame * CFrame.new(0, 300, 0))
				else
					local v950 = CheckBoat()

					if v950 then
						if plr.Character.Humanoid.Sit == false then
							_tp(v950.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
						else
							while true do
								wait()

								local cFrame = CFrame.new(-10000000, 31, 37016.25)

								if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
									_tp(CFrame.new(-10000000, 150, 37016.25))
								else
									_tp(CFrame.new(-10000000, 31, 37016.25))
								end

								if _G.FindMirage and not ((cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10) then
									if not (workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") or plr.Character.Humanoid.Sit == false) then
										continue
									end
								end

								break
							end

							plr.Character.Humanoid.Sit = false
						end
					else
						local cFrame = CFrame.new(-16927.451, 9.086, 433.864)

						TeleportToTarget(cFrame)

						if (cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
						end
					end
				end
			end)
		end
	end
end)
GRP_Race_Mystic_Island_Full_Moon:AddToggle("Esp_Mirage_Island", {
	Text = "Esp Mirage Island",
	Default = false,
	Callback = function(p219)
		MirageIslandESP = p219

		if MirageIslandESP then
			task.spawn(function()
				while MirageIslandESP do
					UpdateIslandMirageESP()
					task.wait(1)
				end
			end)
		else
			UpdateIslandMirageESP()
		end
	end
})

do
	GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Tween_To_Mirage_Island", {
		Text = "Auto Tween To Mirage Island",
		Default = false,
		Callback = function(p220)
			_G.AutoMysticIsland = p220
		end
	})
end

spawn(function()
	while task.wait(0.1) do
		pcall(function()
			if _G.AutoMysticIsland then
				for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
					if child.Name == "Mirage Island" then
						topos(child.CFrame * CFrame.new(0, 333, 0))
					end
				end
			end
		end)
	end
end)
GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Tween_To_Highest_Point", {
	Text = "Auto Tween To Highest Point",
	Default = false,
	Callback = function(p221)
		_G.HighestMirage = p221
	end
})
spawn(function()
	while wait(Sec) do
		if _G.HighestMirage then
			pcall(function()
				if workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island", true) then
					_tp(workspace.Map:FindFirstChild("MysticIsland").Center.CFrame * CFrame.new(0, 400, 0))
				end
			end)
		end
	end
end)

do
	GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Collect_Gear", {
		Text = "Auto Collect Gear",
		Default = false,
		Callback = function(p222)
			_G.TPGEAR = p222
		end
	})
end

spawn(function()
	pcall(function()
		while wait(0.1) do
			if _G.TPGEAR then
				local pairs_ = pairs
				local MysticIsland = workspace.Map:FindFirstChild("MysticIsland")

				for _, child in pairs_(MysticIsland:GetChildren()) do
					if child.Name == "Part" and child.ClassName == "MeshPart" then
						_tp(child.CFrame)
					end
				end
			end
		end
	end)
end)
GRP_Race_Mystic_Island_Full_Moon:AddToggle("Change_Transparency_can_see", {
	Text = "Change Transparency can see",
	Default = false,
	Callback = function(p223)
		_G.can = p223
	end
})
spawn(function()
	pcall(function()
		while wait(Sec) do
			if _G.can then
				local pairs_ = pairs
				local MysticIsland = workspace.Map:FindFirstChild("MysticIsland")

				for _, child in pairs_(MysticIsland:GetChildren()) do
					if child.Name == "Part" then
						if child.ClassName == "MeshPart" then
							child.Transparency = 0
						else
							child.Transparency = 1
						end
					end
				end
			end
		end
	end)
end)
GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Tween_Advanced_Fruit_Dealer", {
	Text = "Auto Tween Advanced Fruit Dealer",
	Default = false,
	Callback = function(p224)
		_G.Addealer = p224
	end
})
spawn(function()
	while wait() do
		if _G.Addealer then
			pcall(function()
				for _, child in pairs(replicated.NPCs:GetChildren()) do
					if child.Name == "Advanced Fruit Dealer" then
						_tp(child.HumanoidRootPart.CFrame)
					end
				end
			end)
		end
	end
end)
GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Collect_Mirage_Chest", {
	Text = "Auto Collect Mirage Chest",
	Default = false,
	Callback = function(p225)
		_G.FarmChestM = p225
	end
})
spawn(function()
	while wait(0.2) do
		if _G.FarmChestM then
			pcall(function()
				local ok2 = workspace.Map:FindFirstChild("MysticIsland").Chests:FindFirstChild("DiamondChest")

				if not ok2 then
					ok2 = workspace.Map:FindFirstChild("MysticIsland").Chests:FindFirstChild("FragChest")
				end

				if ok2 then
					local CollectionService = game:GetService("CollectionService")
					local LocalPlayer = game:GetService("Players").LocalPlayer
					local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

					if not Character then
						return
					end

					local Position = Character:GetPivot().Position
					local tagged = CollectionService:GetTagged("_ChestTagged")
					local huge = math.huge
					local v972
					local n5 = 1
					local v974 = #tagged
					local v975, exitTo, v977, v978, Magnitude

					if true then
						if n5 <= v974 then
							repeat
								v977 = n5
								exitTo = nil

								while true do
									v978 = tagged[v977]
									Magnitude = (v978:GetPivot().Position - Position).Magnitude

									if (not SelectedIsland or v978:IsDescendantOf(SelectedIsland)) and not v978:GetAttribute("IsDisabled") and Magnitude < huge then
										huge = Magnitude
										v972 = v978
									end

									v975 += nil

									if not (nil <= 0) then
										exitTo = 1

										break
									elseif v975 >= nil then
										v977 = n5

										continue
									end

									break
								end
							until exitTo ~= 1 or not (v975 <= nil)

							if v972 then
								_tp(v972:GetPivot())
							end
						end
					else
						if not (n5 >= v974) then
							return
						end

						local exitTo2

						while true do
							v977 = n5
							v978 = tagged[v977]
							Magnitude = (v978:GetPivot().Position - Position).Magnitude

							if (not SelectedIsland or v978:IsDescendantOf(SelectedIsland)) and not v978:GetAttribute("IsDisabled") and Magnitude < huge then
								huge = Magnitude
								v972 = v978
							end

							v975 += nil

							if not (nil <= 0) then
								exitTo2 = 1

								break
							elseif v975 >= nil then
								continue
							end

							break
						end

						if exitTo2 == 1 and v975 <= nil then
							repeat
								v977 = n5
								exitTo = nil

								while true do
									v978 = tagged[v977]
									Magnitude = (v978:GetPivot().Position - Position).Magnitude

									if (not SelectedIsland or v978:IsDescendantOf(SelectedIsland)) and not v978:GetAttribute("IsDisabled") and Magnitude < huge then
										huge = Magnitude
										v972 = v978
									end

									v975 += nil

									if not (nil <= 0) then
										exitTo = 1

										break
									elseif v975 >= nil then
										v977 = n5

										continue
									end

									break
								end
							until exitTo ~= 1 or not (v975 <= nil)

							if v972 then
								_tp(v972:GetPivot())
							end
						elseif v972 then
							_tp(v972:GetPivot())
						end
					end
				end
			end)
		end
	end
end)
GRP_Race_Mystic_Island_Full_Moon:AddButton({
	Text = "Talk With Stone",
	Func = function()
		local CommF_ = replicated:WaitForChild("Remotes"):WaitForChild("CommF_")

		CommF_:InvokeServer("RaceV4Progress", "Begin")
		CommF_:InvokeServer("RaceV4Progress", "Check")
		CommF_:InvokeServer("RaceV4Progress", "Teleport")
	end
})
GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Look_At_Moon", {
	Text = "Auto Look At Moon",
	Default = false,
	Callback = function(p226)
		_G.Auto_Mink = p226
	end
})
MoveCamtoMoon = function()
	workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, Lighting:GetMoonDirection() + workspace.CurrentCamera.CFrame.Position)
	plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, Lighting:GetMoonDirection() + plr.Character.HumanoidRootPart.CFrame.Position)
end
task.spawn(function()
	while task.wait() do
		if LookM then
			local exitTo

			repeat
				MoveCamtoMoon()
				wait(0.1)
				replicated.Remotes.CommE:FireServer("ActivateAbility")
				exitTo = nil

				while task.wait() do
					if LookM then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)

do
	GRP_Race_Mystic_Island_Full_Moon:AddToggle("Look_Moon_+_Auto_V3", {
		Text = "Look Moon + Auto V3",
		Default = false,
		Callback = function(p227)
			LookMV3 = p227
		end
	})
end

MoveCamtoMoon = function()
	local moonDirection = Lighting:GetMoonDirection()

	workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + moonDirection)
	plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, plr.Character.HumanoidRootPart.Position + moonDirection)
end

do
	task.spawn(function()
		while task.wait(0.1) do
			if LookMV3 then
				MoveCamtoMoon()
				replicated.Remotes.CommE:FireServer("ActivateAbility")
				UIS:SendKeyEvent(true, "T", true, game)
				wait(0.5)
				UIS:SendKeyEvent(false, "T", true, game)
			end
		end
	end)
end

GRP_Race_Upgrade_Races_V2_And_V3 = t15.Race:AddLeftGroupbox("Upgrade Races V2 And V3")

do
	RaceMink = GRP_Race_Upgrade_Races_V2_And_V3:AddToggle("Auto_Upgrade_Mink", {
		Text = "Auto Upgrade Mink",
		Default = false,
		Callback = function(p228)
			_G.Auto_Mink = p228
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Mink then
				if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") ~= 2 then
					if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 0 then
						replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
					elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 1 then
						local ok2 = plr.Backpack:FindFirstChild("Flower 1")

						if not ok2 then
							ok2 = plr.Character:FindFirstChild("Flower 1")
						end

						if ok2 then
							local ok = plr.Backpack:FindFirstChild("Flower 2")

							if not ok then
								ok = plr.Character:FindFirstChild("Flower 2")
							end

							if not ok then
								_tp(workspace.Flower2.CFrame)
							elseif not plr.Backpack:FindFirstChild("Flower 3") then
								if not plr.Character:FindFirstChild("Flower 3") then
									local v986 = GetConnectionEnemies("Swan Pirate")

									if v986 then
										while true do
											wait()
											t9.Kill(v986, _G.Auto_Mink)

											if GetBP("Flower 3") then
												break
											elseif not v986.Parent or v986.Humanoid.Health <= 0 or _G.Auto_Mink == false then
												break
											end
										end
									else
										_tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
									end
								end
							end
						else
							_tp(workspace.Flower1.CFrame)
						end
					elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 2 then
						replicated.Remotes.CommF_:InvokeServer("Alchemist", "3")
					end
				elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 0 then
					replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
				elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 1 then
					_G.AutoFarmChest = true
				else
					_G.AutoFarmChest = false
				end
			end
		end)
	end
end)
RaceHuman = GRP_Race_Upgrade_Races_V2_And_V3:AddToggle("Auto_Upgrade_Human", {
	Text = "Auto Upgrade Human",
	Default = false,
	Callback = function(p229)
		_G.Auto_Human = p229
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Auto_Human then
					if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") ~= -2 then
						if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 0 then
							replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
						elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 1 then
							local ok2 = plr.Backpack:FindFirstChild("Flower 1")

							if not ok2 then
								ok2 = plr.Character:FindFirstChild("Flower 1")
							end

							if ok2 then
								local ok = plr.Backpack:FindFirstChild("Flower 2")

								if not ok then
									ok = plr.Character:FindFirstChild("Flower 2")
								end

								if not ok then
									_tp(workspace.Flower2.CFrame)
								elseif not plr.Backpack:FindFirstChild("Flower 3") then
									if not plr.Character:FindFirstChild("Flower 3") then
										local v989 = GetConnectionEnemies("Swan Pirate")

										if v989 then
											while true do
												wait()
												t9.Kill(v989, _G.Auto_Human)

												if plr.Backpack:FindFirstChild("Flower 3") then
													break
												elseif not v989.Parent or v989.Humanoid.Health <= 0 or _G.Auto_Human == false then
													break
												end
											end
										else
											_tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
										end
									end
								end
							else
								_tp(workspace.Flower1.CFrame)
							end
						elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 2 then
							replicated.Remotes.CommF_:InvokeServer("Alchemist", "3")
						end
					elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 0 then
						replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
					elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 1 then
						local v990 = GetConnectionEnemies(t4[1])

						if v990 then
							while true do
								wait()
								t9.Kill(v990, _G.Auto_Human)

								if v990.Humanoid.Health <= 0 then
									break
								elseif not v990.Parent or not _G.Auto_Human then
									break
								end
							end
						else
							_tp(CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625))
						end

						local v991 = GetConnectionEnemies(t4[2])

						if v991 then
							while true do
								wait()
								t9.Kill(v991, _G.Auto_Human)

								if v991.Humanoid.Health <= 0 then
									break
								elseif not v991.Parent or not _G.Auto_Human then
									break
								end
							end
						else
							_tp(CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109))
						end

						local v992 = GetConnectionEnemies(t4[3])

						if v992 then
							while true do
								wait()
								t9.Kill(v992, _G.Auto_Human)

								if v992.Humanoid.Health <= 0 then
									break
								elseif not v992.Parent or not _G.Auto_Human then
									break
								end
							end
						else
							_tp(CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407))
						end
					end
				end
			end)
		end
	end)
end

RaceSky = GRP_Race_Upgrade_Races_V2_And_V3:AddToggle("Auto_Upgrade_Angel", {
	Text = "Auto Upgrade Angel",
	Default = false,
	Callback = function(p230)
		_G.Auto_Skypiea = p230
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Skypiea then
				if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") ~= -2 then
					if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 0 then
						replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
					elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 1 then
						local ok2 = plr.Backpack:FindFirstChild("Flower 1")

						if not ok2 then
							ok2 = plr.Character:FindFirstChild("Flower 1")
						end

						if ok2 then
							local ok = plr.Backpack:FindFirstChild("Flower 2")

							if not ok then
								ok = plr.Character:FindFirstChild("Flower 2")
							end

							if not ok then
								_tp(workspace.Flower2.CFrame)
							elseif not plr.Backpack:FindFirstChild("Flower 3") then
								if not plr.Character:FindFirstChild("Flower 3") then
									local v995 = GetConnectionEnemies("Swan Pirate")

									if v995 then
										while true do
											wait()
											t9.Kill(v995, _G.Auto_Skypiea)

											if plr.Backpack:FindFirstChild("Flower 3") then
												break
											elseif not v995.Parent or v995.Humanoid.Health <= 0 or _G.Auto_Skypiea == false then
												break
											end
										end
									else
										_tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
									end
								end
							end
						else
							_tp(workspace.Flower1.CFrame)
						end
					elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 2 then
						replicated.Remotes.CommF_:InvokeServer("Alchemist", "3")
					end
				elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 0 then
					replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
				elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 1 then
					for _, child in pairs(game.Players:GetChildren()) do
						if child.Name ~= plr.Name and tostring(child.Data.Race.Value) == "Skypiea" then
							while true do
								task.wait()
								_tp(child.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(math.rad(-45), 0, 0))

								if child.Humanoid.Health <= 0 then
									break
								elseif _G.Auto_Skypiea == false then
									break
								end
							end
						end
					end
				end
			end
		end)
	end
end)
RaceFish = GRP_Race_Upgrade_Races_V2_And_V3:AddToggle("Auto_Upgrade_FishMan", {
	Text = "Auto Upgrade FishMan",
	Default = false,
	Callback = function(p231)
		_G.Auto_Fish = p231
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Auto_Fish then
					if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") ~= -2 then
						if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 0 then
							replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
						elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 1 then
							local ok2 = plr.Backpack:FindFirstChild("Flower 1")

							if not ok2 then
								ok2 = plr.Character:FindFirstChild("Flower 1")
							end

							if ok2 then
								local ok = plr.Backpack:FindFirstChild("Flower 2")

								if not ok then
									ok = plr.Character:FindFirstChild("Flower 2")
								end

								if not ok then
									_tp(workspace.Flower2.CFrame)
								elseif not plr.Backpack:FindFirstChild("Flower 3") then
									if not plr.Character:FindFirstChild("Flower 3") then
										local v1000 = GetConnectionEnemies("Swan Pirate")

										if v1000 then
											while true do
												wait()
												t9.Kill(v1000, _G.Auto_Fish)

												if plr.Backpack:FindFirstChild("Flower 3") then
													break
												elseif not v1000.Parent or v1000.Humanoid.Health <= 0 or _G.Auto_Fish == false then
													break
												end
											end
										else
											_tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
										end
									end
								end
							else
								_tp(workspace.Flower1.CFrame)
							end
						elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 2 then
							replicated.Remotes.CommF_:InvokeServer("Alchemist", "3")
						end
					elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 0 then
						replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
					elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 1 then
						warn("Sea Beast Soon")
					end
				end
			end)
		end
	end)
end

GRP_Race_Trials_Quest_V4 = t15.Race:AddLeftGroupbox("Trials Quest V4")

do
	local v1001 = GRP_Race_Trials_Quest_V4:AddLabel("")

	spawn(function()
		pcall(function()
			while wait(0.2) do
				v1001:SetText("Tiers - V4 : " .. " " .. plr.Data.Race.C.Value)
			end
		end)
	end)
end

PullLv = GRP_Race_Trials_Quest_V4:AddToggle("Auto_Pull_Lever", {
	Text = "Auto Pull Lever",
	Default = false,
	Callback = function(p232)
		_G.Lver = p232
	end
})
spawn(function()
	while wait(Sec) do
		if _G.Lver then
			pcall(function()
				for _, descendant in pairs(workspace.Map["Temple of Time"]:GetDescendants()) do
					if descendant.Name == "ProximityPrompt" then
						fireproximityprompt(descendant, math.huge)
					end
				end
			end)
		end
	end
end)

do
	Train = GRP_Race_Trials_Quest_V4:AddToggle("Auto_Train_V4", {
		Text = "Auto Train V4",
		Default = false,
		Callback = function(p233)
			_G.AcientOne = p233
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.AcientOne then
				local t40 = {
					"Reborn Skeleton",
					"Living Zombie",
					"Demonic Soul",
					"Posessed Mummy"
				}

				for i = 1, #t40 do
					if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then
						vim1:SendKeyEvent(true, "Y", true, game)
						replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
						vim1:SendKeyEvent(false, "Y", true, game)
						_tp(CFrame.new(-8987.041015625, 215.862060546875, 5886.71044921875))
					elseif plr.Character:FindFirstChild("RaceTransformed").Value == false then
						local v1006 = GetConnectionEnemies(t40)

						if v1006 then
							while true do
								wait()
								t9.Kill(v1006, _G.AcientOne)

								if _G.AcientOne == false then
									break
								elseif v1006.Humanoid.Health <= 0 or not v1006.Parent then
									break
								end
							end
						else
							_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
						end
					end
				end
			end
		end)
	end
end)
GRP_Race_Trials_Quest_V4:AddButton({
	Text = "Teleport to Temple of Time",
	Func = function()
		if plr.Character then
			if plr.Character:FindFirstChild("HumanoidRootPart") then
				local cFrame = CFrame.new(-7754.033203125, 2998.953857421875, -404.75357055664062)

				_tp(cFrame)
			end
		end
	end
})

do
	GRP_Race_Trials_Quest_V4:AddButton({
		Text = "Teleport to Ancient One",
		Func = function()
			if plr.Character then
				if plr.Character:FindFirstChild("HumanoidRootPart") then
					local cFrame = CFrame.new(-5071.541015625, 314.5412902832, -3151.1098632812)

					_tp(cFrame)
				end
			end
		end
	})
end

GRP_Race_Trials_Quest_V4:AddButton({
	Text = "Teleport to Ancient Clock",
	Func = function()
		if plr.Character then
			if plr.Character:FindFirstChild("HumanoidRootPart") then
				local cFrame = CFrame.new(-12471.169921875, 374.94024658203, -7551.677734375)

				_tp(cFrame)
			end
		end
	end
})

do
	Doors = GRP_Race_Trials_Quest_V4:AddToggle("Auto_Teleport_to_Race_Doors", {
		Text = "Auto Teleport to Race Doors",
		Default = false,
		Callback = function(p234)
			_G.TPDoor = p234
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.TPDoor then
					if tostring(plr.Data.Race.Value) == "Mink" then
						_tp(CFrame.new(29020.66015625, 14889.4267578125, -379.26828002929688))
					elseif tostring(plr.Data.Race.Value) == "Fishman" then
						_tp(CFrame.new(28224.056640625, 14889.4267578125, -210.58720397949219))
					elseif tostring(plr.Data.Race.Value) == "Cyborg" then
						_tp(CFrame.new(28492.4140625, 14894.4267578125, -422.11001586914062))
					elseif tostring(plr.Data.Race.Value) == "Skypiea" then
						_tp(CFrame.new(28967.408203125, 14918.0751953125, 234.31198120117188))
					elseif tostring(plr.Data.Race.Value) == "Ghoul" then
						_tp(CFrame.new(28672.720703125, 14889.1279296875, 454.59616088867188))
					elseif tostring(plr.Data.Race.Value) == "Human" then
						_tp(CFrame.new(29237.294921875, 14889.4267578125, -206.94955444335938))
					end
				end
			end)
		end
	end)
end

do
	Trials = GRP_Race_Trials_Quest_V4:AddToggle("Auto_Complete_Trial_Race", {
		Text = "Auto Complete Trial Race",
		Default = false,
		Callback = function(p235)
			_G.Complete_Trials = p235
		end
	})
end

GetSeaBeastTrial = function()
	if not workspace.Map:FindFirstChild("FishmanTrial") then
		return nil
	end

	if workspace._WorldOrigin.Locations:FindFirstChild("Trial of Water") then
		FishmanTrial = workspace._WorldOrigin.Locations:FindFirstChild("Trial of Water")
	end

	if FishmanTrial then
		local next_ = next
		local children, v1012 = workspace.SeaBeasts:GetChildren()

		for _, v1 in next_, children, v1012 do
			if v1:FindFirstChild("HumanoidRootPart") and (v1.HumanoidRootPart.Position - FishmanTrial.Position).Magnitude <= 1500 and v1.Health.Value > 0 then
				return v1
			end
		end
	end
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Complete_Trials then
					if tostring(plr.Data.Race.Value) == "Mink" then
						notween(workspace.Map.MinkTrial.Ceiling.CFrame * CFrame.new(0, -20, 0))
					end
				end
			end)
		end
	end)
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Complete_Trials and tostring(plr.Data.Race.Value) == "Fishman" and GetSeaBeastTrial() then
					while true do
						task.wait()
						spawn(function()
							_tp(CFrame.new(GetSeaBeastTrial().HumanoidRootPart.Position.X, game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y + 300, GetSeaBeastTrial().HumanoidRootPart.Position.Z))
						end)
						MousePos = GetSeaBeastTrial().HumanoidRootPart.Position
						Useskills("Melee", "Z")
						Useskills("Melee", "X")
						Useskills("Melee", "C")
						wait(0.1)
						Useskills("Sword", "Z")
						Useskills("Sword", "X")
						wait(0.1)
						Useskills("Blox Fruit", "Z")
						Useskills("Blox Fruit", "X")
						Useskills("Blox Fruit", "C")
						wait(0.1)
						Useskills("Gun", "Z")
						Useskills("Gun", "X")

						if _G.Complete_Trials == false then
							break
						elseif not GetSeaBeastTrial() then
							break
						end
					end
				end
			end)
		end
	end)
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Complete_Trials and tostring(plr.Data.Race.Value) == "Cyborg" then
				_tp(workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0, 500, 0))
			end
		end)
	end
end)
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Complete_Trials and tostring(plr.Data.Race.Value) == "Skypiea" then
				notween(workspace.Map.SkyTrial.Model.FinishPart.CFrame)
			end
		end)
	end
end)

do
	spawn(function()
		while wait(0.1) do
			pcall(function()
				if _G.Complete_Trials and (tostring(plr.Data.Race.Value) == "Human" or tostring(plr.Data.Race.Value) == "Ghoul") then
					local v1015 = GetConnectionEnemies({
						"Ancient Vampire",
						"Ancient Zombie"
					})

					if v1015 then
						while true do
							wait()
							t9.Kill(v1015, _G.Complete_Trials)

							if _G.Complete_Trials == false then
								break
							elseif not v1015.Parent or v1015.Humanoid.Health <= 0 then
								break
							end
						end
					end
				end
			end)
		end
	end)
end

do
	AutoKill = GRP_Race_Trials_Quest_V4:AddToggle("Auto_Kill_Player_After_Trial", {
		Text = "Auto Kill Player After Trial",
		Default = false,
		Callback = function(p236)
			_G.Defeating = p236
		end
	})
end

spawn(function()
	while task.wait(Sec) do
		pcall(function()
			if _G.Defeating then
				for _, child in pairs(workspace.Characters:GetChildren()) do
					if child.Name ~= plr.Name and child.Humanoid.Health > 0 and child:FindFirstChild("HumanoidRootPart") and child.Parent and (Root.Position - child.HumanoidRootPart.Position).Magnitude <= 250 then
						while true do
							task.wait()
							EquipWeapon(_G.SelectWeapon)
							_tp(child.HumanoidRootPart.CFrame * CFrame.new(0, 0, 15))
							sethiddenproperty(plr, "SimulationRadius", math.huge)

							if _G.Defeating == false then
								break
							elseif child.Humanoid.Health <= 0 or not child.Parent or not child:FindFirstChild("HumanoidRootPart") or not child:FindFirstChild("Humanoid") then
								break
							end
						end
					end
				end
			end
		end)
	end
end)
GRP_Prehistoric_Dojo_Quest = t15.Prehistoric:AddLeftGroupbox("Dojo Quest")
GRP_Prehistoric_Dojo_Quest:AddButton({
	Text = "Dojo Quest",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438, -334.96499633789062))
		_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))
	end
})
DojoQ = GRP_Prehistoric_Dojo_Quest:AddToggle("Auto_Dojo_Trainer", {
	Text = "Auto Dojo Trainer",
	Default = false,
	Callback = function()
	end
})

do
	printBeltName = function(p237)
		if type(p237) == "table" and p237.Quest.BeltName then
			return p237.Quest.BeltName
		end
	end
end

spawn(function()
	while wait(Sec) do
		if _G.Dojoo then
			pcall(function()
				local response = replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
					NPC = "Dojo Trainer",
					Command = "RequestQuest"
				} }))
				local v1019 = printBeltName(response)

				if debug == false and not (response or v1019) then
					_tp(CFrame.new(5865.0234375, 1208.3154296875, 871.15185546875))
					debug = true
				elseif debug == true and (CFrame.new(5865.0234375, 1208.3154296875, 871.15185546875).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 50 then
					if v1019 == "White" then
						local v1020 = GetConnectionEnemies("Skull Slayer")

						if v1020 then
							while true do
								task.wait()
								t9.Kill(v1020, _G.Dojoo)

								if not response then
									break
								elseif not _G.Dojoo or not t9.Alive(v1020) then
									break
								end
							end
						else
							_tp(CFrame.new(-16759.58984375, 71.283767700195312, 1595.3399658203125))
						end
					elseif v1019 == "Yellow" then
						while true do
							task.wait()
							_G.SeaBeast1 = true
							_G.TerrorShark = true
							_G.Shark = true
							_G.Piranha = true
							_G.MobCrew = true
							_G.FishBoat = true
							_G.SailBoats = true

							if not _G.Dojoo then
								break
							elseif not response then
								break
							end
						end

						_G.SeaBeast1 = false
						_G.TerrorShark = false
						_G.Shark = false
						_G.Piranha = false
						_G.MobCrew = false
						_G.FishBoat = false
						_G.SailBoats = false
					elseif v1019 == "Green" then
						while true do
							task.wait()
							_G.SailBoats = true

							if not _G.Dojoo then
								break
							elseif not response then
								break
							end
						end

						_G.SailBoats = false
					elseif v1019 == "Purple" then
						while true do
							task.wait()
							_G.FarmEliteHunt = true

							if not _G.Dojoo then
								break
							elseif not response then
								break
							end
						end

						_G.FarmEliteHunt = false
					elseif v1019 == "Red" then
						while true do
							task.wait()
							_G.SailBoats = true
							_G.FishBoat = true

							if not _G.Dojoo then
								break
							elseif not response then
								break
							end
						end

						_G.SailBoats = false
						_G.FishBoat = false
					elseif v1019 == "Black" then
						repeat
							task.wait()

							local ActivationPrompt

							if workspace.Map:FindFirstChild("PrehistoricIsland") then
								_G.Prehis_Find = true
								ActivationPrompt = workspace.Map.PrehistoricIsland.Core.ActivationPrompt

								if ActivationPrompt:FindFirstChild("ProximityPrompt", true) then
									_G.Prehis_Skills = false
									_G.Prehis_Find = true
								else
									_G.Prehis_Skills = true
									_G.Prehis_Find = false
								end
							elseif workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then
								_G.Prehis_Find = true
								ActivationPrompt = workspace.Map.PrehistoricIsland.Core.ActivationPrompt

								if ActivationPrompt:FindFirstChild("ProximityPrompt", true) then
									_G.Prehis_Skills = false
									_G.Prehis_Find = true
								else
									_G.Prehis_Skills = true
									_G.Prehis_Find = false
								end

								if not _G.Dojoo or not response then
									break
								end
							else
								_G.Prehis_Find = true
								_G.Prehis_Skills = false
							end
						until not _G.Dojoo or not response

						_G.Prehis_Find = false
						_G.Prehis_Skills = false
					elseif v1019 == "Orange" or v1019 == "Blue" then
						return nil
					end
				end

				if not response then
					debug = false
					replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
						NPC = "Dojo Trainer",
						Command = "ClaimQuest"
					} }))
				end
			end)
		end
	end
end)
BlazeEM = GRP_Prehistoric_Dojo_Quest:AddToggle("Auto_Dragon_Hunter", {
	Text = "Auto Dragon Hunter",
	Default = false,
	Callback = function(p238)
		_G.FarmBlazeEM = p238
	end
})

do
	checkQuesta = function()
		local t41 = { {
			Context = "Check"
		} }
		local response

		pcall(function()
			game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack({ {
				Context = "RequestQuest"
			} }))
		end)

		local _ = pcall(function()
			response = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack(t41))
		end)
		local v1026 = false
		local v1027
		local v1028
		local n6

		if response and response.Text then
			v1026 = true

			local Text = response.Text

			if string.find(tostring(Text), "Defeat") then
				n6 = 1

				local v1031 = string.sub(tostring(Text), 8, 9)

				v1027 = tonumber(v1031)

				for _, v1 in pairs({
					"Hydra Enforcer",
					"Venomous Assailant"
				}) do
					if string.find(Text, v1) then
						v1028 = v1

						break
					end
				end
			elseif string.find(tostring(Text), "Destroy") then
				v1027 = 10
				n6 = 2
				v1028 = nil
			end
		end

		return v1026, v1028, v1027, n6
	end
end

BackTODoJo = function()
	for _, child in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Notifications:GetChildren()) do
		if child.Name == "NotificationTemplate" and string.find(child.Text, "Head back to the Dojo to complete more tasks") then
			return true
		end
	end

	return false
end

do
	DragonMobClear = function(p239, p240, p241)
		if workspace.Enemies:FindFirstChild(p240) then
			for _, child in pairs(workspace.Enemies:GetChildren()) do
				if child.Name == p240 and t9.Alive(child) and p239 then
					t9.Kill(child, p239)
				end
			end
		else
			_tp(p241)
		end
	end
end

do
	spawn(function()
		while wait() do
			if _G.FarmBlazeEM then
				pcall(function()
					local v1038, v1039, _, v1041 = checkQuesta()

					if v1038 ~= true or BackTODoJo() then
						_tp(CFrame.new(5813, 1208, 884))
						DragonMobClear(false, nil, nil)
					elseif v1041 == 1 then
						if v1039 == "Hydra Enforcer" or v1039 == "Venomous Assailant" then
							while true do
								wait()
								DragonMobClear(true, v1039, CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))

								if not _G.FarmBlazeEM then
									break
								elseif BackTODoJo() then
									break
								end
							end
						end
					elseif v1041 == 2 then
						if workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true) then
							repeat
								wait()
								spawn(function()
									_tp(workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).CFrame * CFrame.new(4, 0, 0))
								end)

								if (workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).Position - Root.Position).Magnitude <= 200 then
									MousePos = workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).Position
									Useskills("Melee", "Z")
									Useskills("Melee", "X")
									Useskills("Melee", "C")
									wait(0.5)
									Useskills("Sword", "Z")
									Useskills("Sword", "X")
									wait(0.5)
									Useskills("Blox Fruit", "Z")
									Useskills("Blox Fruit", "X")
									Useskills("Blox Fruit", "C")
									wait(0.5)
									Useskills("Gun", "Z")
									Useskills("Gun", "X")
								end
							until not _G.FarmBlazeEM or BackTODoJo()
						end
					end
				end)
			end
		end
	end)
end

spawn(function()
	while wait(0.1) do
		if _G.FarmBlazeEM then
			pcall(function()
				if workspace.EmberTemplate:FindFirstChild("Part") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.EmberTemplate.Part.CFrame
				end
			end)
		end
	end
end)
GRP_Prehistoric_Drago_Trial = t15.Prehistoric:AddLeftGroupbox("Drago Trial")
GetQuestDracoLevel = function()
	return replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
		NPC = "Dragon Wizard",
		Command = "Upgrade"
	} }))
end
Toggle = GRP_Prehistoric_Drago_Trial:AddToggle("Tween_To_Upgrade_Droco_Trial", {
	Text = "Tween To Upgrade Droco Trial",
	Default = false,
	Callback = function(p242)
		_G.UPGDrago = p242
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.UPGDrago then
				if GetQuestDracoLevel() == false then
					return nil
				end

				if GetQuestDracoLevel() == true then
					if (CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375).Position - Root.Position).Magnitude >= 300 then
						_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))
					else
						_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))
						replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
							NPC = "Dragon Wizard",
							Command = "Upgrade"
						} }))
					end
				end
			end
		end)
	end
end)
Toggle = GRP_Prehistoric_Drago_Trial:AddToggle("Auto_Drago_(V1)", {
	Text = "Auto Drago (V1)",
	Default = false,
	Callback = function(p243)
		_G.DragoV1 = p243
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.DragoV1 and GetM("Dragon Egg") <= 0 then
				while true do
					wait()
					_G.Prehis_Find = true
					_G.Prehis_Skills = true
					_G.Prehis_DE = true

					if not _G.DragoV1 then
						break
					elseif GetM("Dragon Egg") >= 1 then
						break
					end
				end

				_G.Prehis_Find = false
				_G.Prehis_Skills = false
				_G.Prehis_DE = false
			end
		end)
	end
end)
fireflower = GRP_Prehistoric_Drago_Trial:AddToggle("Auto_Drago_(V2)", {
	Text = "Auto Drago (V2)",
	Default = false,
	Callback = function(p244)
		_G.AutoFireFlowers = p244
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoFireFlowers then
				local FireFlowers = workspace:FindFirstChild("FireFlowers")
				local v1043 = GetConnectionEnemies("Forest Pirate")

				if v1043 then
					while true do
						wait()
						t9.Kill(v1043, _G.AutoFireFlowers)

						if not _G.AutoFireFlowers then
							break
						elseif not v1043.Parent or v1043.Humanoid.Health <= 0 or FireFlowers then
							break
						end
					end
				else
					_tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))
				end

				if FireFlowers then
					for _, child in pairs(FireFlowers:GetChildren()) do
						if child:IsA("Model") and child.PrimaryPart then
							local Position = child.PrimaryPart.Position

							if (Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 then
								vim1:SendKeyEvent(true, "E", true, game)
								wait(1.5)
								vim1:SendKeyEvent(false, "E", true, game)
							else
								_tp(CFrame.new(Position))
							end
						end
					end
				end
			end
		end
	end)
end

Toggle = GRP_Prehistoric_Drago_Trial:AddToggle("Auto_Drago_(V3)", {
	Text = "Auto Drago (V3)",
	Default = false,
	Callback = function(p245)
		_G.DragoV3 = p245
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.DragoV3 then
				repeat
					wait()
					_G.DangerSc = "Lv Infinite"
					_G.SailBoats = true
					_G.TerrorShark = true
				until not _G.DragoV3

				_G.DangerSc = "Lv 1"
				_G.SailBoats = false
				_G.TerrorShark = false
			end
		end)
	end
end)

do
	Toggle = GRP_Prehistoric_Drago_Trial:AddToggle("Auto_Relic_Drago_Trial_[Beta]", {
		Text = "Auto Relic Drago Trial [Beta]",
		Default = false,
		Callback = function(p246)
			_G.Relic123 = p246
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.Relic123 then
			pcall(function()
				if workspace.Map:FindFirstChild("DracoTrial") then
					replicated.Remotes.DracoTrial:InvokeServer()
					wait(0.5)

					while true do
						wait()
						_tp(CFrame.new(-39934.9765625, 10685.359375, 22999.34375))

						if not _G.Relic123 then
							break
						elseif Root.Position == CFrame.new(-39934.9765625, 10685.359375, 22999.34375).Position then
							break
						end
					end

					while true do
						wait()
						_tp(CFrame.new(-40511.25390625, 9376.4013671875, 23458.37890625))

						if not _G.Relic123 then
							break
						elseif Root.Position == CFrame.new(-40511.25390625, 9376.4013671875, 23458.37890625).Position then
							break
						end
					end

					wait(2.5)

					while true do
						wait()
						_tp(CFrame.new(-39914.65625, 10685.384765625, 23000.177734375))

						if not _G.Relic123 then
							break
						elseif Root.Position == CFrame.new(-39914.65625, 10685.384765625, 23000.177734375).Position then
							break
						end
					end

					while true do
						wait()
						_tp(CFrame.new(-40045.83203125, 9376.3984375, 22791.287109375))

						if not _G.Relic123 then
							break
						elseif Root.Position == CFrame.new(-40045.83203125, 9376.3984375, 22791.287109375).Position then
							break
						end
					end

					wait(2.5)

					while true do
						wait()
						_tp(CFrame.new(-39908.5, 10685.4052734375, 22990.04296875))

						if not _G.Relic123 then
							break
						elseif Root.Position == CFrame.new(-39908.5, 10685.4052734375, 22990.04296875).Position then
							break
						end
					end

					while true do
						wait()
						_tp(CFrame.new(-39609.5, 9376.400390625, 23472.94335975))

						if not _G.Relic123 then
							break
						elseif Root.Position == CFrame.new(-39609.5, 9376.400390625, 23472.94335975).Position then
							break
						end
					end
				else
					local TrialTeleport = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")

					if TrialTeleport then
						if TrialTeleport:IsA("Part") then
							_tp(CFrame.new(TrialTeleport.Position))
						end
					end
				end
			end)
		end
	end
end)
Toggle = GRP_Prehistoric_Drago_Trial:AddToggle("Auto_Train_Drago_v4", {
	Text = "Auto Train Drago v4",
	Default = false,
	Callback = function(p247)
		_G.TrainDrago = p247
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.TrainDrago then
					local t42 = {
						"Venomous Assailant",
						"Hydra Enforcer"
					}

					for i = 1, #t42 do
						if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then
							vim1:SendKeyEvent(true, "Y", true, game)
							replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
							vim1:SendKeyEvent(false, "Y", true, game)
							_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
						elseif plr.Character:FindFirstChild("RaceTransformed").Value == false then
							local v1050 = GetConnectionEnemies(t42)

							if v1050 then
								while true do
									wait()
									t9.Kill(v1050, _G.TrainDrago)

									if _G.TrainDrago == false then
										break
									elseif v1050.Humanoid.Health <= 0 or not v1050.Parent then
										break
									end
								end
							else
								_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
							end
						end
					end
				end
			end)
		end
	end)
end

dragoTpVolcano = GRP_Prehistoric_Drago_Trial:AddToggle("Tween_to_Drago_Trials", {
	Text = "Tween to Drago Trials",
	Default = false,
	Callback = function(p248)
		_G.TpDrago_Prehis = p248
	end
})
spawn(function()
	while wait(Sec) do
		if _G.TpDrago_Prehis then
			local TrialTeleport = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")

			if TrialTeleport and TrialTeleport:IsA("Part") then
				_tp(CFrame.new(TrialTeleport.Position))
			end
		end
	end
end)
bdrago = GRP_Prehistoric_Drago_Trial:AddToggle("Swap_Drago_Race", {
	Text = "Swap Drago Race",
	Default = false,
	Callback = function(p249)
		_G.BuyDrago = p249
	end
})
spawn(function()
	while wait(Sec) do
		if _G.BuyDrago then
			pcall(function()
				if (CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375).Position - Root.Position).Magnitude >= 300 then
					_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))
				else
					_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))
					replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
						NPC = "Dragon Wizard",
						Command = "DragonRace"
					} }))
				end
			end)
		end
	end
end)
UpTalon = GRP_Prehistoric_Drago_Trial:AddToggle("Upgrade_Dragon_Talon_With_Uzoth", {
	Text = "Upgrade Dragon Talon With Uzoth",
	Default = false,
	Callback = function(p250)
		_G.DT_Uzoth = p250
	end
})
spawn(function()
	while wait(Sec) do
		if _G.DT_Uzoth then
			local cFrame = CFrame.new(5661.89014, 1211.31909, 864.836731, 0.811413169, -1.36805838e-08, -0.584473014, 4.75227395e-08, 1, 4.25682458e-08, 0.584473014, -6.23161966e-08, 0.811413169)

			_tp(cFrame)

			if (cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 25 then
				replicated.Modules.Net["RF/InteractDragonQuest"]:InvokeServer({
					NPC = "Uzoth",
					Command = "Upgrade"
				})
			end
		end
	end
end)
GRP_Prehistoric_Volcanic_Crafting = t15.Prehistoric:AddLeftGroupbox("Volcanic Crafting")
GRP_Prehistoric_Volcanic_Crafting:AddButton({
	Text = "Craft Dragonheart",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonheart")
	end
})
GRP_Prehistoric_Volcanic_Crafting:AddButton({
	Text = "Craft Dragonstorm",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonstorm")
	end
})
GRP_Prehistoric_Volcanic_Crafting:AddButton({
	Text = "Craft Dino Hood",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "DinoHood")
	end
})
GRP_Prehistoric_Volcanic_Crafting:AddButton({
	Text = "Craft T-Rex Skull",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "TRexSkull")
	end
})
GRP_Prehistoric_Prehistoric_Island = t15.Prehistoric:AddLeftGroupbox("Prehistoric Island")

local v1053 = GRP_Prehistoric_Prehistoric_Island:AddLabel("")

spawn(function()
	while wait(0.2) do
		if not workspace.Map:FindFirstChild("PrehistoricIsland") then
			if not workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then
				v1053:SetText("Prehistoric Island : False")

				continue
			end
		end

		v1053:SetText("Prehistoric Island : True")
	end
end)
GRP_Prehistoric_Prehistoric_Island:AddButton({
	Text = "Craft Volcanic Magnet",
	Func = function()
		replicated.Modules.Net["RF/Craft"]:InvokeServer("PossibleHardcode", "Volcanic Magnet")
	end
})

do
	GRP_Prehistoric_Prehistoric_Island:AddToggle("Craft_Volcanic_Magnet", {
		Text = "Craft Volcanic Magnet",
		Default = false,
		Callback = function(p251)
			_G.Prehis_Find = p251
		end
	})
end

task.spawn(function()
	local rfCraft = game:GetService("ReplicatedStorage").Modules.Net["RF/Craft"]

	while task.wait(0.3) do
		if getgenv().AutoCraftVolcanic then
			pcall(function()
				rfCraft:InvokeServer("PossibleHardcode", "Volcanic Magnet")
			end)
			getgenv().AutoCraftVolcanic = false
		end
	end
end)
GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Find_Prehistoric_Island", {
	Text = "Auto Find Prehistoric Island",
	Default = false,
	Callback = function(p252)
		_G.Prehis_Find = p252
	end
})

do
	local u1055

	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Prehis_Find then
					local Character = plr.Character

					if not Character then
						return
					end

					local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character:FindFirstChild("Humanoid")

					if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then
						return
					end

					local PrehistoricIsland = workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island", true)

					if PrehistoricIsland then
						local HeadTeleport = PrehistoricIsland:FindFirstChild("HeadTeleport", true) or PrehistoricIsland:FindFirstChild("Teleport_Head", true) or PrehistoricIsland:FindFirstChild("Head", true)

						if HeadTeleport then
							local CFrame_ = HeadTeleport.CFrame
							local v1062 = CFrame_.Position - CFrame_.LookVector * 40 + Vector3.new(0, 20, 0)

							if (v1062 - HumanoidRootPart.Position).Magnitude > 30 then
								_tp(CFrame.new(v1062))
							end
						else
							local Position = PrehistoricIsland.CFrame.Position

							_tp(CFrame.new(Position - (Position - HumanoidRootPart.Position).Unit * 250 + Vector3.new(0, 60, 0)))
						end
					else
						local v1064 = CheckBoat()

						if not v1064 then
							local cFrame = CFrame.new(-16927.451, 9.086, 433.864)

							TeleportToTarget(cFrame)

							if (cFrame.Position - HumanoidRootPart.Position).Magnitude <= 10 then
								replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat or "Guardian")
							end

							return
						end

						if Humanoid.Sit == false then
							_tp(v1064.VehicleSeat.CFrame * CFrame.new(0, 1, 0))

							return
						end

						local cFrame = CFrame.new(-10000000, 31, 37016.25)

						u1055 = cFrame

						if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
							_tp(CFrame.new(-10000000, 150, 37016.25))
						else
							_tp(cFrame)
						end
					end
				end
			end)
		end
	end)
end

GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Start_Prehistoric_Event", {
	Text = "Auto Start Prehistoric Event",
	Default = false,
	Callback = function(p253)
		_G.AutoStartPrehistoric = p253
	end
})
spawn(function()
	while wait() do
		if _G.AutoStartPrehistoric then
			pcall(function()
				if workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island", true) then
					if workspace.Map:FindFirstChild("PrehistoricIsland", true) then
						local ActivationPrompt = workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt", true)

						if ActivationPrompt and ActivationPrompt:FindFirstChild("ProximityPrompt") then
							if plr:DistanceFromCharacter(ActivationPrompt.CFrame.Position) <= 150 then
								fireproximityprompt(ActivationPrompt.ProximityPrompt, math.huge)
								vim1:SendKeyEvent(true, "E", true, game)
								wait(1.5)
								vim1:SendKeyEvent(false, "E", true, game)
							end

							_tp(ActivationPrompt.CFrame)
						end
					end
				end
			end)
		end
	end
end)
GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Patch_Prehistoric_Event", {
	Text = "Auto Patch Prehistoric Event",
	Default = false,
	Callback = function(p254)
		_G.Prehis_Skills = p254
	end
})
spawn(function()
	while wait(0.3) do
		if _G.Prehis_Skills then
			pcall(function()
				local PrehistoricIsland = workspace.Map:FindFirstChild("PrehistoricIsland")

				if not PrehistoricIsland then
					return
				end

				for _, descendant in pairs(PrehistoricIsland:GetDescendants()) do
					if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
						if descendant.Name:lower():find("lava") then
							descendant:Destroy()
						end
					end
				end

				local Core = PrehistoricIsland:FindFirstChild("Core")

				if Core then
					local InteriorLava = Core:FindFirstChild("InteriorLava")

					if InteriorLava then
						InteriorLava:Destroy()
					end
				end

				local TrialTeleport = PrehistoricIsland:FindFirstChild("TrialTeleport")

				for _, descendant in pairs(PrehistoricIsland:GetDescendants()) do
					if descendant.Name == "TouchInterest" and (not TrialTeleport or not descendant:IsDescendantOf(TrialTeleport)) then
						descendant.Parent:Destroy()
					end
				end
			end)
		end
	end
end)
spawn(function()
	while wait(Sec) do
		if _G.Prehis_Skills then
			pcall(function()
				local v1076 = GetConnectionEnemies("Lava Golem")

				if v1076 and v1076:FindFirstChild("Humanoid") then
					while true do
						wait(0.1)
						t9.Kill(v1076, true)
						v1076.Humanoid:ChangeState(15)

						if not _G.Prehis_Skills then
							break
						elseif not v1076.Parent or v1076.Humanoid.Health <= 0 then
							break
						end
					end
				end
			end)
		end
	end
end)
spawn(function()
	while wait(Sec) do
		if _G.Prehis_Skills then
			pcall(function()
				local PrehistoricIsland = workspace.Map:FindFirstChild("PrehistoricIsland")

				if not PrehistoricIsland then
					return
				end

				local Core = PrehistoricIsland:FindFirstChild("Core")

				if not Core then
					return
				end

				local VolcanoRocks = Core:FindFirstChild("VolcanoRocks")

				if not VolcanoRocks then
					return
				end

				for _, child in pairs(VolcanoRocks:GetChildren()) do
					local VFXLayer = child:FindFirstChild("VFXLayer")
					local At0 = VFXLayer and VFXLayer:FindFirstChild("At0")
					local Glow = At0 and At0:FindFirstChild("Glow")

					if Glow and Glow.Enabled then
						repeat
							wait(0.1)
							_tp(VFXLayer.CFrame)

							if plr:DistanceFromCharacter(VFXLayer.CFrame.Position) <= 150 then
								MousePos = VFXLayer.CFrame.Position
								Useskills("Melee", "Z")
								wait(0.4)
								Useskills("Melee", "X")
								wait(0.4)
								Useskills("Melee", "C")
								wait(0.4)
								Useskills("Blox Fruit", "Z")
								wait(0.4)
								Useskills("Blox Fruit", "X")
								wait(0.4)
								Useskills("Blox Fruit", "C")
							end
						until not _G.Prehis_Skills or not Glow.Enabled
					end
				end
			end)
		end
	end
end)

do
	Kaura = GRP_Prehistoric_Prehistoric_Island:AddToggle("Kill_Aura", {
		Text = "Kill Aura",
		Default = false,
		Callback = function(p255)
			_G.KillAuraFull = p255
		end
	})
end

spawn(function()
	while task.wait(2) do
		if _G.KillAuraFull then
			pcall(function()
				local LocalPlayer = game.Players.LocalPlayer
				local Character = LocalPlayer.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart then
					return
				end

				sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)

				for _, child in pairs(workspace.Enemies:GetChildren()) do
					if child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") and (child.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude <= 500 and child.Humanoid.Health > 0 then
						child.Humanoid.Health = 0
						child.HumanoidRootPart.CanCollide = false
						child:BreakJoints()
					end
				end
			end)
		end
	end
end)
Vocan = GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Collect_Dino_Bones", {
	Text = "Auto Collect Dino Bones",
	Default = false,
	Callback = function(p256)
		_G.Prehis_DB = p256
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Prehis_DB then
				if workspace:FindFirstChild("DinoBone") then
					for _, child in pairs(workspace:GetChildren()) do
						if child.Name == "DinoBone" then
							_tp(child.CFrame)
						end
					end
				end
			end
		end)
	end
end)
Vocan = GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Collect_Dragon_Eggs", {
	Text = "Auto Collect Dragon Eggs",
	Default = false,
	Callback = function(p257)
		_G.Prehis_DE = p257
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Prehis_DE then
				if workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg") then
					_tp(workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg").Molten.CFrame)
					fireproximityprompt(workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs.DragonEgg.Molten.ProximityPrompt, 30)
				end
			end
		end)
	end
end)
Toggle = GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Reset_When_Complete_Volcano", {
	Text = "Auto Reset When Complete Volcano",
	Default = false,
	Callback = function(p258)
		_G.ResetPH = p258
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.ResetPH then
					local TrialTeleport = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")

					if TrialTeleport and TrialTeleport:FindFirstChild("TouchInterest") then
						plr.Character.Humanoid.Health = 0
					elseif workspace:FindFirstChild("DinoBone") then
						for _, child in pairs(workspace:GetChildren()) do
							if child.Name == "DinoBone" then
								_tp(child.CFrame)
							end
						end
					end
				end
			end)
		end
	end)
end

GRP_SeaEvent_Sea_Event_Setting_Sail = t15.SeaEvent:AddLeftGroupbox("Sea Event / Setting Sail")
getgenv().SetSpeedBoat = 300
spawn(function()
	game:GetService("RunService").RenderStepped:Connect(function()
		if getgenv().SpeedBoat then
			local LocalPlayer = game:GetService("Players").LocalPlayer

			if LocalPlayer.Character then
				if LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Sit then
					for _, child in pairs(game:GetService("Workspace").Boats:GetChildren()) do
						local VehicleSeat = child:FindFirstChildWhichIsA("VehicleSeat")

						if VehicleSeat then
							VehicleSeat.MaxSpeed = getgenv().SetSpeedBoat
						end
					end
				end
			end
		end
	end)
end)
GRP_SeaEvent_Sea_Event_Setting_Sail:AddButton({
	Text = "Remove Lighting Effect",
	Func = function()
		pcall(function()
			game.Lighting.BaseAtmosphere:Destroy()
		end)
	end
})
GRP_SeaEvent_Sea_Event_Setting_Sail:AddToggle("Ship_Speed_Modifier", {
	Text = "Ship Speed Modifier",
	Default = false,
	Callback = function(p259)
		getgenv().SpeedBoat = p259
	end
})

do
	GRP_SeaEvent_Sea_Event_Setting_Sail:AddSlider({
		Text = "Ship Speed",
		Min = 0,
		Max = 1000,
		Default = 300,
		Rounding = 0,
		Callback = function(p260)
			getgenv().SetSpeedBoat = p260
		end
	})
end

GRP_SeaEvent_Sea_Event_Setting_Sail:AddToggle("Auto_Press_W", {
	Text = "Auto Press W",
	Default = false,
	Callback = function(p261)
		getgenv().AutoPressW = p261
	end
})
spawn(function()
	while wait() do
		pcall(function()
			if getgenv().AutoPressW then
				if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == true then
					game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", true, game)
					task.wait(0.1)
					game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", true, game)
				end
			end
		end)
	end
end)
GRP_SeaEvent_Sea_Event_Setting_Sail:AddToggle("No_Clip_Ship", {
	Text = "No Clip Ship",
	Default = false,
	Callback = function(p262)
		getgenv().NoClipShip = p262
	end
})
spawn(function()
	while wait() do
		pcall(function()
			for _, child in pairs(game:GetService("Workspace").Boats:GetChildren()) do
				for _, descendant in pairs(child:GetDescendants()) do
					if descendant:IsA("BasePart") then
						if getgenv().NoClipShip or getgenv().FindPrehistoric then
							descendant.CanCollide = false
						else
							descendant.CanCollide = true
						end
					end
				end
			end
		end)
	end
end)
GRP_SeaEvent_Crafting_Items = t15.SeaEvent:AddLeftGroupbox("Crafting Items")
GRP_SeaEvent_Crafting_Items:AddButton({
	Text = "Craft SharkTooth",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkTooth")
	end
})
GRP_SeaEvent_Crafting_Items:AddButton({
	Text = "Craft TerrorJaw",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "TerrorJaw")
	end
})

do
	GRP_SeaEvent_Crafting_Items:AddButton({
		Text = "Craft SharkAnchor",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkAnchor")
		end
	})
end

GRP_SeaEvent_Crafting_Items:AddButton({
	Text = "Craft LeviathanCrown",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanCrown")
	end
})

do
	GRP_SeaEvent_Crafting_Items:AddButton({
		Text = "Craft LeviathanShield",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanShield")
		end
	})
end

GRP_SeaEvent_Crafting_Items:AddButton({
	Text = "Craft LeviathanBoat",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanBoat")
	end
})
GRP_SeaEvent_Crafting_Items:AddButton({
	Text = "Craft LegendaryScroll",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LegendaryScroll")
	end
})

do
	GRP_SeaEvent_Crafting_Items:AddButton({
		Text = "Craft MythicalScroll",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "MythicalScroll")
		end
	})
end

GRP_SeaEvent_Choose_Sea_Event = t15.SeaEvent:AddLeftGroupbox("Choose Sea Event")
Q = GRP_SeaEvent_Choose_Sea_Event:AddDropdown("Select_Boats", {
	Text = "Select Boats",
	Values = {
		"Guardian",
		"PirateGrandBrigade",
		"MarineGrandBrigade",
		"PirateBrigade",
		"MarineBrigade",
		"PirateSloop",
		"MarineSloop",
		"Beast Hunter"
	},
	Default = 1,
	Callback = function(p263)
		_G.SelectedBoat = p263
	end
})
GRP_SeaEvent_Choose_Sea_Event:AddButton({
	Text = "Buy Boats",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
	end
})
Q = GRP_SeaEvent_Choose_Sea_Event:AddDropdown("Select_Sea_Level", {
	Text = "Select Sea Level",
	Values = {
		"Lv 1",
		"Lv 2",
		"Lv 3",
		"Lv 4",
		"Lv 5",
		"Lv 6",
		"Lv Infinite"
	},
	Default = 1,
	Callback = function(p264)
		_G.DangerSc = p264
	end
})
Q = GRP_SeaEvent_Choose_Sea_Event:AddToggle("Auto_Sail_Boat", {
	Text = "Auto Sail Boat",
	Default = false,
	Callback = function(p265)
		_G.SailBoats = p265
	end
})
spawn(function()
	while wait() do
		if _G.SailBoats then
			pcall(function()
				local v1103 = CheckBoat()

				if not v1103 and (not CheckShark() or not _G.Shark) and (not CheckTerrorShark() or not _G.TerrorShark) and (not CheckFishCrew() or not _G.MobCrew) and (not CheckPiranha() or not _G.Piranha) and (not CheckEnemiesBoat() or not _G.FishBoat) and (not CheckSeaBeast() or not _G.SeaBeast1) and (not _G.PGB or not CheckPirateGrandBrigade()) and (not _G.HCM or not CheckHauntedCrew()) and (not _G.Leviathan1 or not CheckLeviathan()) then
					local cFrame = CFrame.new(-16927.451, 9.086, 433.864)

					TeleportToTarget(cFrame)

					if (cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
						replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
					end
				elseif v1103 and (not CheckShark() or not _G.Shark) and (not CheckTerrorShark() or not _G.TerrorShark) and (not CheckFishCrew() or not _G.MobCrew) and (not CheckPiranha() or not _G.Piranha) and (not CheckEnemiesBoat() or not _G.FishBoat) and (not CheckSeaBeast() or not _G.SeaBeast1) and (not _G.PGB or not CheckPirateGrandBrigade()) then
					if (not _G.HCM or not CheckHauntedCrew()) and (not _G.Leviathan1 or not CheckLeviathan()) then
						if plr.Character.Humanoid.Sit == false then
							_tp(v1103.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
						else
							if _G.DangerSc == "Lv 1" then
								CFrameSelectedZone = CFrame.new(-21998.375, 30.0006084, -682.309143)
							elseif _G.DangerSc == "Lv 2" then
								CFrameSelectedZone = CFrame.new(-26779.5215, 30.0005474, -822.858032)
							elseif _G.DangerSc == "Lv 3" then
								CFrameSelectedZone = CFrame.new(-31171.957, 30.0001011, -2256.93774)
							elseif _G.DangerSc == "Lv 4" then
								CFrameSelectedZone = CFrame.new(-34054.6875, 30.2187767, -2560.12012)
							elseif _G.DangerSc == "Lv 5" then
								CFrameSelectedZone = CFrame.new(-38887.5547, 30.0004578, -2162.99023)
							elseif _G.DangerSc == "Lv 6" then
								CFrameSelectedZone = CFrame.new(-44541.7617, 30.0003204, -1244.8584)
							elseif _G.DangerSc == "Lv Infinite" then
								CFrameSelectedZone = CFrame.new(-10000000, 31, 37016.25)
							end

							while true do
								wait()

								if (_G.FishBoat or not CheckEnemiesBoat()) and (_G.PGB or not CheckPirateGrandBrigade()) and (_G.TerrorShark or not CheckTerrorShark()) then
									_tp(CFrameSelectedZone)
								else
									_tp(CFrameSelectedZone * CFrame.new(0, 150, 0))
								end

								if _G.SailBoats ~= false and (not CheckShark() or not _G.Shark) and (not CheckTerrorShark() or not _G.TerrorShark) and (not CheckFishCrew() or not _G.MobCrew) and (not CheckPiranha() or not _G.Piranha) and (not CheckSeaBeast() or not _G.SeaBeast1) and (not CheckEnemiesBoat() or not _G.FishBoat) and (not _G.Leviathan1 or not CheckLeviathan()) and (not _G.HCM or not CheckHauntedCrew()) and (not _G.PGB or not CheckPirateGrandBrigade()) then
									if plr.Character:WaitForChild("Humanoid").Sit ~= false then
										continue
									end
								end

								break
							end

							plr.Character.Humanoid.Sit = false
						end
					end
				end
			end)
		end
	end
end)

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				for _, child in pairs(workspace.Boats:GetChildren()) do
					for _, descendant in pairs(child:GetDescendants()) do
						if descendant:IsA("BasePart") then
							if _G.SailBoats or _G.Prehis_Find or _G.FindMirage or _G.SailBoat_Hydra or _G.AutofindKitIs then
								descendant.CanCollide = false
							else
								descendant.CanCollide = true
							end
						end
					end
				end
			end)
		end
	end)
end

GRP_SeaEvent_Entity_Sea_Event = t15.SeaEvent:AddLeftGroupbox("Entity Sea Event")

do
	GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Shark", {
		Text = "Auto Shark",
		Default = false,
		Callback = function(p266)
			_G.Shark = p266
		end
	})
end

GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Piranha", {
	Text = "Auto Piranha",
	Default = false,
	Callback = function(p267)
		_G.Piranha = p267
	end
})
GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Terror_Shark", {
	Text = "Auto Terror Shark",
	Default = false,
	Callback = function(p268)
		_G.TerrorShark = p268
	end
})
GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Fish_Crew_Member", {
	Text = "Auto Fish Crew Member",
	Default = false,
	Callback = function(p269)
		_G.MobCrew = p269
	end
})
GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Haunted_Crew_Member", {
	Text = "Auto Haunted Crew Member",
	Default = false,
	Callback = function(p270)
		_G.HCM = p270
	end
})
GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Attack_PirateGrandBrigade", {
	Text = "Auto Attack PirateGrandBrigade",
	Default = false,
	Callback = function(p271)
		_G.PGB = p271
	end
})
GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Attack_Fish_Boat", {
	Text = "Auto Attack Fish Boat",
	Default = false,
	Callback = function(p272)
		_G.FishBoat = p272
	end
})

do
	GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Attack_Sea_Beast", {
		Text = "Auto Attack Sea Beast",
		Default = false,
		Callback = function(p273)
			_G.SeaBeast1 = p273
		end
	})
end

do
	spawn(function()
		while wait() do
			pcall(function()
				if _G.Shark then
					local t43 = { "Shark" }

					if CheckShark() then
						for _, child in pairs(workspace.Enemies:GetChildren()) do
							if table.find(t43, child.Name) and t9.Alive(child) then
								while true do
									task.wait()
									t9.Kill(child, _G.Shark)

									if _G.Shark == false then
										break
									elseif not child.Parent or child.Humanoid.Health <= 0 then
										break
									end
								end
							end
						end
					end
				end

				if _G.TerrorShark then
					local t44 = { "Terrorshark" }

					if CheckTerrorShark() then
						for _, child in pairs(workspace.Enemies:GetChildren()) do
							if table.find(t44, child.Name) and t9.Alive(child) then
								while true do
									task.wait()
									t9.KillSea(child, _G.TerrorShark)

									if _G.TerrorShark == false then
										break
									elseif not child.Parent or child.Humanoid.Health <= 0 then
										break
									end
								end
							end
						end
					end
				end

				if _G.Piranha then
					local t45 = { "Piranha" }

					if CheckPiranha() then
						for _, child in pairs(workspace.Enemies:GetChildren()) do
							if table.find(t45, child.Name) and t9.Alive(child) then
								while true do
									task.wait()
									t9.Kill(child, _G.Piranha)

									if _G.Piranha == false then
										break
									elseif not child.Parent or child.Humanoid.Health <= 0 then
										break
									end
								end
							end
						end
					end
				end

				if _G.MobCrew then
					local t46 = { "Fish Crew Member" }

					if CheckFishCrew() then
						for _, child in pairs(workspace.Enemies:GetChildren()) do
							if table.find(t46, child.Name) and t9.Alive(child) then
								while true do
									task.wait()
									t9.Kill(child, _G.MobCrew)

									if _G.MobCrew == false then
										break
									elseif not child.Parent or child.Humanoid.Health <= 0 then
										break
									end
								end
							end
						end
					end
				end

				if _G.HCM then
					local t47 = { "Haunted Crew Member" }

					if CheckHauntedCrew() then
						for _, child in pairs(workspace.Enemies:GetChildren()) do
							if table.find(t47, child.Name) and t9.Alive(child) then
								while true do
									task.wait()
									t9.Kill(child, _G.HCM)

									if _G.HCM == false then
										break
									elseif not child.Parent or child.Humanoid.Health <= 0 then
										break
									end
								end
							end
						end
					end
				end

				if _G.SeaBeast1 then
					if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
						for _, child in pairs(workspace.SeaBeasts:GetChildren()) do
							if child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Health") and child.Health.Value > 0 then
								repeat
									task.wait()
									spawn(function()
										_tp(CFrame.new(child.HumanoidRootPart.Position.X, game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y + 200, child.HumanoidRootPart.Position.Z))
									end)

									if plr:DistanceFromCharacter(child.HumanoidRootPart.CFrame.Position) <= 500 then
										AitSeaSkill_Custom = child.HumanoidRootPart.CFrame
										MousePos = AitSeaSkill_Custom.Position

										if CheckF() then
											weaponSc("Blox Fruit")
											Useskills("Blox Fruit", "Z")
											Useskills("Blox Fruit", "X")
											Useskills("Blox Fruit", "C")
										else
											Useskills("Melee", "Z")
											Useskills("Melee", "X")
											Useskills("Melee", "C")
											wait(0.1)
											Useskills("Sword", "Z")
											Useskills("Sword", "X")
											wait(0.1)
											Useskills("Blox Fruit", "Z")
											Useskills("Blox Fruit", "X")
											Useskills("Blox Fruit", "C")
											wait(0.1)
											Useskills("Gun", "Z")
											Useskills("Gun", "X")
										end
									end
								until _G.SeaBeast1 == false or not child:FindFirstChild("HumanoidRootPart") or not child.Parent or child.Health.Value <= 0
							end
						end
					end
				end

				if _G.Leviathan1 then
					if workspace.SeaBeasts:FindFirstChild("Leviathan") then
						for _, child in pairs(workspace.SeaBeasts:GetChildren()) do
							if child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Leviathan Segment") and child:FindFirstChild("Health") and child.Health.Value > 0 then
								repeat
									task.wait()
									spawn(function()
										_tp(CFrame.new(child.HumanoidRootPart.Position.X, game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y + 200, child.HumanoidRootPart.Position.Z))
									end)

									if plr:DistanceFromCharacter(child.HumanoidRootPart.CFrame.Position) <= 500 then
										MousePos = child:FindFirstChild("Leviathan Segment").Position

										if CheckF() then
											weaponSc("Blox Fruit")
											Useskills("Blox Fruit", "Z")
											Useskills("Blox Fruit", "X")
											Useskills("Blox Fruit", "C")
										else
											Useskills("Melee", "Z")
											Useskills("Melee", "X")
											Useskills("Melee", "C")
											wait(0.1)
											Useskills("Sword", "Z")
											Useskills("Sword", "X")
											wait(0.1)
											Useskills("Blox Fruit", "Z")
											Useskills("Blox Fruit", "X")
											Useskills("Blox Fruit", "C")
											wait(0.1)
											Useskills("Gun", "Z")
											Useskills("Gun", "X")
										end
									end
								until _G.Leviathan1 == false or not child:FindFirstChild("HumanoidRootPart") or not child.Parent or child.Health.Value <= 0
							end
						end
					end
				end

				if _G.FishBoat and CheckEnemiesBoat() then
					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if child:FindFirstChild("Health") and child.Health.Value > 0 and child:FindFirstChild("VehicleSeat") then
							repeat
								task.wait()
								spawn(function()
									if child.Name == "FishBoat" then
										_tp(child.Engine.CFrame * CFrame.new(0, -50, -25))
									end
								end)

								if plr:DistanceFromCharacter(child.Engine.CFrame.Position) <= 150 then
									AitSeaSkill_Custom = child.Engine.CFrame
									MousePos = AitSeaSkill_Custom.Position

									if CheckF() then
										weaponSc("Blox Fruit")
										Useskills("Blox Fruit", "Z")
										Useskills("Blox Fruit", "X")
										Useskills("Blox Fruit", "C")
									else
										Useskills("Melee", "Z")
										Useskills("Melee", "X")
										Useskills("Melee", "C")
										wait(0.1)
										Useskills("Sword", "Z")
										Useskills("Sword", "X")
										wait(0.1)
										Useskills("Blox Fruit", "Z")
										Useskills("Blox Fruit", "X")
										Useskills("Blox Fruit", "C")
										wait(0.1)
										Useskills("Gun", "Z")
										Useskills("Gun", "X")
									end
								end
							until _G.FishBoat == false or not child:FindFirstChild("VehicleSeat") or child.Health.Value <= 0
						end
					end
				end

				if _G.PGB and CheckPirateGrandBrigade() then
					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if child:FindFirstChild("Health") and child.Health.Value > 0 and child:FindFirstChild("VehicleSeat") then
							repeat
								task.wait()
								spawn(function()
									if child.Name == "PirateBrigade" then
										_tp(child.Engine.CFrame * CFrame.new(0, -30, -10))
									elseif child.Name == "PirateGrandBrigade" then
										_tp(child.Engine.CFrame * CFrame.new(0, -50, -50))
									end
								end)

								if plr:DistanceFromCharacter(child.Engine.CFrame.Position) <= 150 then
									AitSeaSkill_Custom = child.Engine.CFrame
									MousePos = AitSeaSkill_Custom.Position

									if CheckF() then
										weaponSc("Blox Fruit")
										Useskills("Blox Fruit", "Z")
										Useskills("Blox Fruit", "X")
										Useskills("Blox Fruit", "C")
									else
										Useskills("Melee", "Z")
										Useskills("Melee", "X")
										Useskills("Melee", "C")
										wait(0.1)
										Useskills("Sword", "Z")
										Useskills("Sword", "X")
										wait(0.1)
										Useskills("Blox Fruit", "Z")
										Useskills("Blox Fruit", "X")
										Useskills("Blox Fruit", "C")
										wait(0.1)
										Useskills("Gun", "Z")
										Useskills("Gun", "X")
									end
								end
							until _G.PGB == false or not child:FindFirstChild("VehicleSeat") or child.Health.Value <= 0
						end
					end
				end
			end)
		end
	end)
end

GRP_SeaEvent_Kitsune_Island_Event = t15.SeaEvent:AddLeftGroupbox("Kitsune Island / Event")

local v1132 = GRP_SeaEvent_Kitsune_Island_Event:AddLabel("")

spawn(function()
	while wait(0.2) do
		if not workspace.Map:FindFirstChild("KitsuneIsland") then
			if not workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") then
				v1132:SetText("Kitsune Island : False")

				continue
			end
		end

		v1132:SetText("Kitsune Island : True")
	end
end)
GRP_SeaEvent_Kitsune_Island_Event:AddToggle("Auto_Find_Kitsune_Island", {
	Text = "Auto Find Kitsune Island",
	Default = false,
	Callback = function(p274)
		_G.AutofindKitIs = p274
	end
})

do
	spawn(function()
		while wait() do
			if _G.AutofindKitIs then
				pcall(function()
					if workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island", true) then
						_tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame * CFrame.new(0, 500, 0))
					else
						local v1133 = CheckBoat()

						if v1133 then
							if plr.Character.Humanoid.Sit == false then
								_tp(v1133.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
							else
								local cFrame = CFrame.new(-10000000, 31, 37016.25)

								while true do
									wait()

									if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
										_tp(CFrame.new(-10000000, 150, 37016.25))
									else
										_tp(CFrame.new(-10000000, 31, 37016.25))
									end

									if _G.AutofindKitIs and not ((cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10) then
										if not (workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") or plr.Character.Humanoid.Sit == false) then
											continue
										end
									end

									break
								end

								plr.Character.Humanoid.Sit = false
							end
						else
							local cFrame = CFrame.new(-16927.451, 9.086, 433.864)

							TeleportToTarget(cFrame)

							if (cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
								replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
							end
						end
					end
				end)
			end
		end
	end)
end

do
	GRP_SeaEvent_Kitsune_Island_Event:AddToggle("Auto_Teleport_to_Shrine_Actived", {
		Text = "Auto Teleport to Shrine Actived",
		Default = false,
		Callback = function(p275)
			_G.tweenShrine = p275
		end
	})
end

spawn(function()
	while wait(0.1) do
		if _G.tweenShrine then
			pcall(function()
				local KitsuneIsland = workspace.Map:FindFirstChild("KitsuneIsland") or game.Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island")
				local ShrineActive = KitsuneIsland:FindFirstChild("ShrineActive")

				if ShrineActive then
					local next_ = next
					local descendants, v1140 = ShrineActive:GetDescendants()

					for _, v1 in next_, descendants, v1140 do
						if v1:IsA("BasePart") then
							if v1.Name:find("NeonShrinePart") then
								replicated.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()

								while true do
									wait()
									_tp(v1.CFrame * CFrame.new(0, 2, 0))

									if _G.tweenShrine == false then
										break
									elseif not KitsuneIsland then
										break
									end
								end
							end
						end
					end
				else
					_tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame * CFrame.new(0, 500, 0))
				end
			end)
		end
	end
end)
GRP_SeaEvent_Kitsune_Island_Event:AddToggle("Auto_Collect_Azure_Ember", {
	Text = "Auto Collect Azure Ember",
	Default = false,
	Callback = function(p276)
		_G.Collect_Ember = p276
	end
})
spawn(function()
	while wait(0.1) do
		if _G.Collect_Ember then
			pcall(function()
				if workspace:WaitForChild("AttachedAzureEmber") then
					notween(workspace:WaitForChild("EmberTemplate"):FindFirstChild("Part").CFrame)
				elseif workspace:WaitForChild("EmberTemplate") then
					notween(workspace:WaitForChild("EmberTemplate"):FindFirstChild("Part").CFrame)

					return
				else
					_tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame * CFrame.new(0, 500, 0))
					replicated.Modules.Net["RF/KitsuneStatuePray"]:InvokeServer()
				end
			end)
		end
	end
end)

do
	GRP_SeaEvent_Kitsune_Island_Event:AddToggle("Auto_Trade_Azure_Ember", {
		Text = "Auto Trade Azure Ember",
		Default = false,
		Callback = function(p277)
			_G.Trade_Ember = p277
		end
	})
end

spawn(function()
	while wait(0.1) do
		if _G.Trade_Ember then
			pcall(function()
				if workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island", true) then
					replicated.Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()
				end
			end)
		end
	end
end)
GRP_SeaEvent_Kitsune_Island_Event:AddButton({
	Text = "Trade Items Azure",
	Func = function()
		if replicated.Modules then
			if replicated.Modules.Net then
				local RFKitsuneStatuePray = replicated.Modules.Net:FindFirstChild("RF/KitsuneStatuePray")

				if RFKitsuneStatuePray then
					RFKitsuneStatuePray:InvokeServer()
				end
			end
		end
	end
})

do
	GRP_SeaEvent_Kitsune_Island_Event:AddButton({
		Text = "Talk with kitsune statue",
		Func = function()
			if replicated.Modules and replicated.Modules.Net then
				local RETouchKitsuneStatue = replicated.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue")

				if RETouchKitsuneStatue then
					RETouchKitsuneStatue:FireServer()
				end
			end
		end
	})
end

GRP_SeaEvent_Frozen_Dimension_Event = t15.SeaEvent:AddLeftGroupbox("Frozen Dimension Event")

local v1145 = GRP_SeaEvent_Frozen_Dimension_Event:AddLabel("")

spawn(function()
	pcall(function()
		while wait(0.2) do
			if workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") then
				v1145:SetText("Frozen Dimension : True")
			else
				v1145:SetText("Frozen Dimension : False")
			end
		end
	end)
end)

do
	local v1146 = GRP_SeaEvent_Frozen_Dimension_Event:AddLabel("")

	spawn(function()
		while wait(0.2) do
			pcall(function()
				local v1147 = string.match(replicated.Remotes.CommF_:InvokeServer("InfoLeviathan", "1"), "%d+")

				if v1147 then
					v1146:SetText("Spy Leviathan : " .. tostring(v1147))

					if tonumber(v1147) == 5 then
						v1146:SetText("Spy Leviathan : Already Done!!")
					end
				end
			end)
		end
	end)
end

GRP_SeaEvent_Frozen_Dimension_Event:AddButton({
	Text = "Buy Spy",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("InfoLeviathan", "2")
	end
})
GRP_SeaEvent_Frozen_Dimension_Event:AddToggle("Auto_Teleport_Frozen_Dimension", {
	Text = "Auto Teleport Frozen Dimension",
	Default = false,
	Callback = function(p278)
		_G.FrozenTP = p278
	end
})
spawn(function()
	while wait(0.1) do
		if _G.FrozenTP then
			pcall(function()
				if workspace.Map:FindFirstChild("LeviathanGate") then
					_tp(workspace.Map.LeviathanGate.CFrame)
					replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLeviathanGate")
				end
			end)
		end
	end
end)
GRP_SeaEvent_Frozen_Dimension_Event:AddToggle("Auto_Drive_To_Hydra_Island", {
	Text = "Auto Drive To Hydra Island",
	Default = false,
	Callback = function(p279)
		_G.SailBoat_Hydra = p279
	end
})
spawn(function()
	while wait() do
		if _G.SailBoat_Hydra then
			pcall(function()
				local v1148 = CheckBoat()

				if v1148 then
					if plr.Character.Humanoid.Sit == false then
						_tp(v1148.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
					else
						repeat
							wait()

							if CheckEnemiesBoat() or CheckPirateGrandBrigade() or CheckTerrorShark() then
								_tp(CFrame.new(5433, 150, 290))
							else
								_tp(CFrame.new(5433, 35, 290))
							end

							if _G.SailBoat_Hydra == false then
								break
							end
						until plr.Character:WaitForChild("Humanoid").Sit == false

						plr.Character.Humanoid.Sit = false
					end
				else
					local cFrame = CFrame.new(-16927.451, 9.086, 433.864)

					TeleportToTarget(cFrame)

					if (cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
						replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
					end
				end
			end)
		end
	end
end)
GRP_SeaEvent_Frozen_Dimension_Event:AddToggle("Auto_Attack_Leviathan", {
	Text = "Auto Attack Leviathan",
	Default = false,
	Callback = function(p280)
		_G.Leviathan1 = p280
	end
})
GRP_Esp_Esp = t15.Esp:AddLeftGroupbox("Esp")
isnil = function(p281)
	return p281 == nil
end

local LocalPlayer, ReplicatedStorage2

do
	local function v1152(p282)
		return math.floor(tonumber(p282) + 0.5)
	end

	Number = math.random(1, 1000000)
	LocalPlayer = game:GetService("Players").LocalPlayer
	ReplicatedStorage2 = game:GetService("ReplicatedStorage")

	local Team = LocalPlayer.Team

	EspPly = function()
		local children, v1155 = game.Players:GetChildren()

		for _, v1 in next, children, v1155 do
			pcall(function()
				if not isnil(v1.Character) then
					if PlayerEsp then
						local ok = isnil(v1.Character.Head)

						if not ok then
							ok = v1.Character.Head:FindFirstChild("NameEsp" .. Number)
						end

						if ok then
							if v1.Character.Head:FindFirstChild("NameEsp" .. Number) then
								v1.Character.Head["NameEsp" .. Number].TextLabel.Text = v1.Name .. " | " .. v1152((LocalPlayer.Character.Head.Position - v1.Character.Head.Position).Magnitude / 3) .. " M\nHealth : " .. v1152(v1.Character.Humanoid.Health * 100 / v1.Character.Humanoid.MaxHealth) .. "%"
							end
						else
							local BillboardGui = Instance.new("BillboardGui", v1.Character.Head)

							BillboardGui.Name = "NameEsp" .. Number
							BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
							BillboardGui.Size = UDim2.new(1, 200, 1, 30)
							BillboardGui.Adornee = v1.Character.Head
							BillboardGui.AlwaysOnTop = true

							local TextLabel = Instance.new("TextLabel", BillboardGui)

							TextLabel.Font = Enum.Font.Code
							TextLabel.FontSize = "Size14"
							TextLabel.TextWrapped = true
							TextLabel.Text = v1.Name .. " \n" .. v1152((LocalPlayer.Character.Head.Position - v1.Character.Head.Position).Magnitude / 3) .. " M"
							TextLabel.Size = UDim2.new(1, 0, 1, 0)
							TextLabel.TextYAlignment = "Top"
							TextLabel.BackgroundTransparency = 1
							TextLabel.TextStrokeTransparency = 0.5

							if v1.Team == Team then
								TextLabel.TextColor3 = Color3.new(0, 0, 254)
							else
								TextLabel.TextColor3 = Color3.new(255, 0, 0)
							end
						end
					elseif v1.Character.Head:FindFirstChild("NameEsp" .. Number) then
						v1.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
					end
				end
			end)
		end
	end
	LocationEsp = function()
		local children, v1162 = workspace._WorldOrigin.Locations:GetChildren()

		for _, v1 in next, children, v1162 do
			pcall(function()
				if not IslandESP then
					if v1:FindFirstChild("NameEsp") then
						v1:FindFirstChild("NameEsp"):Destroy()
					end
				elseif v1.Name ~= "Sea" then
					if v1:FindFirstChild("NameEsp") then
						v1.NameEsp.TextLabel.Text = v1.Name .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - v1.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", v1)

						BillboardGui.Name = "NameEsp"
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = v1
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = Enum.Font.Code
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(98, 252, 252)
						TextLabel.Text = v1.Name .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - v1.Position).Magnitude / 3) .. " M"
					end
				end
			end)
		end
	end
	DevEsp = function()
		local children, v1168 = workspace:GetChildren()

		for _, v1 in next, children, v1168 do
			pcall(function()
				if not DevilFruitESP then
					if v1:FindFirstChild("Handle") then
						if v1.Handle:FindFirstChild("NameEsp" .. Number) then
							v1.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
						end
					end
				elseif string.find(v1.Name, "Fruit") then
					if v1.Handle:FindFirstChild("NameEsp" .. Number) then
						v1.Handle["NameEsp" .. Number].TextLabel.Text = "[" .. v1.Name .. "]" .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - v1.Handle.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", v1.Handle)

						BillboardGui.Name = "NameEsp" .. Number
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = v1.Handle
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = Enum.Font.Code
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						TextLabel.Text = v1.Name .. " \n" .. v1152((LocalPlayer.Character.Head.Position - v1.Handle.Position).Magnitude / 3) .. " M"
					end
				end
			end)
		end
	end
	flowerEsp = function()
		for _, child in pairs(workspace:GetChildren()) do
			pcall(function()
				if child.Name == "Flower2" or child.Name == "Flower1" then
					if not FlowerESP then
						if child:FindFirstChild("NameEsp" .. Number) then
							child:FindFirstChild("NameEsp" .. Number):Destroy()
						end
					elseif child:FindFirstChild("NameEsp" .. Number) then
						child["NameEsp" .. Number].TextLabel.Text = child.Name .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - child.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", child)

						BillboardGui.Name = "NameEsp" .. Number
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = child
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = Enum.Font.Code
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(88, 214, 252)

						if child.Name == "Flower1" then
							TextLabel.Text = "Blue Flower" .. " \n" .. v1152((LocalPlayer.Character.Head.Position - child.Position).Magnitude / 3) .. " M"
						elseif child.Name == "Flower2" then
							TextLabel.Text = "Red Flower" .. " \n" .. v1152((LocalPlayer.Character.Head.Position - child.Position).Magnitude / 3) .. " M"
						end
					end
				end
			end)
		end
	end
	EventIslandEsp = function()
		for _, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
			pcall(function()
				if not EspEventIsland then
					if child:FindFirstChild("NameEsp") then
						child:FindFirstChild("NameEsp"):Destroy()
					end
				elseif child.Name == "Mirage Island" or child.Name == "Prehistoric Island" or child.Name == "Kitsune Island" then
					if child:FindFirstChild("NameEsp") then
						child.NameEsp.TextLabel.Text = child.Name .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - child.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", child)

						BillboardGui.Name = "NameEsp"
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = child
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = "Code"
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
						TextLabel.Text = child.Name .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - child.Position).Magnitude / 3) .. " M"
					end
				end
			end)
		end
	end
	gearEsp = function()
		local MysticIsland = workspace.Map:FindFirstChild("MysticIsland")

		for _, descendant in pairs(MysticIsland:GetDescendants()) do
			pcall(function()
				if not ESPGear then
					if descendant:FindFirstChild("NameEsp") then
						descendant:FindFirstChild("NameEsp"):Destroy()
					end
				elseif descendant.Name == "Part" and descendant.Material == Enum.Material.Neon then
					if descendant:FindFirstChild("NameEsp") then
						descendant.NameEsp.TextLabel.Text = "Gear" .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - descendant.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", descendant)

						BillboardGui.Name = "NameEsp"
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = descendant
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = "Code"
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
						TextLabel.Text = "Gear" .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - descendant.Position).Magnitude / 3) .. " M"
					end
				end
			end)
		end
	end
	AdvanFruitEsp = function()
		if advanEsp then
			for _, child in pairs(ReplicatedStorage2.NPCs:GetChildren()) do
				if child.Name == "Advanced Fruit Dealer" then
					if not workspace:FindFirstChild("Adv") then
						Adv = Instance.new("Part")
						Adv.Name = "Adv"
						Adv.Transparency = 1
						Adv.Size = Vector3.new(1, 1, 1)
						Adv.Anchored = true
						Adv.CanCollide = false
						Adv.Parent = workspace
						Adv.CFrame = child.HumanoidRootPart.CFrame
					elseif workspace:FindFirstChild("Adv") then
						if Adv:FindFirstChild("NameEsp") then
							Adv.NameEsp.TextLabel.Text = child.Name .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
						else
							local BillboardGui = Instance.new("BillboardGui", Adv)

							BillboardGui.Name = "NameEsp"
							BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
							BillboardGui.Size = UDim2.new(1, 200, 1, 30)
							BillboardGui.Adornee = Adv
							BillboardGui.AlwaysOnTop = true

							local TextLabel = Instance.new("TextLabel", BillboardGui)

							TextLabel.Font = "Code"
							TextLabel.FontSize = "Size14"
							TextLabel.TextWrapped = true
							TextLabel.Size = UDim2.new(1, 0, 1, 0)
							TextLabel.TextYAlignment = "Top"
							TextLabel.BackgroundTransparency = 1
							TextLabel.TextStrokeTransparency = 0.5
							TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
							TextLabel.Text = child.Name .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
						end
					end
				end
			end
		elseif workspace:FindFirstChild("Adv") then
			workspace:FindFirstChild("Adv"):Destroy()
		end
	end
	HakiClorEsp = function()
		if ColorEsp then
			for _, child in pairs(ReplicatedStorage2.NPCs:GetChildren()) do
				if child.Name == "Barista Cousin" then
					if not workspace:FindFirstChild("Gay") then
						Gay = Instance.new("Part")
						Gay.Name = "Gay"
						Gay.Transparency = 1
						Gay.Size = Vector3.new(1, 1, 1)
						Gay.Anchored = true
						Gay.CanCollide = false
						Gay.Parent = workspace
						Gay.CFrame = child.HumanoidRootPart.CFrame
					elseif workspace:FindFirstChild("Gay") then
						if Gay:FindFirstChild("NameEsp") then
							Gay.NameEsp.TextLabel.Text = child.Name .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
						else
							local BillboardGui = Instance.new("BillboardGui", Gay)

							BillboardGui.Name = "NameEsp"
							BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
							BillboardGui.Size = UDim2.new(1, 200, 1, 30)
							BillboardGui.Adornee = Gay
							BillboardGui.AlwaysOnTop = true

							local TextLabel = Instance.new("TextLabel", BillboardGui)

							TextLabel.Font = "Code"
							TextLabel.FontSize = "Size14"
							TextLabel.TextWrapped = true
							TextLabel.Size = UDim2.new(1, 0, 1, 0)
							TextLabel.TextYAlignment = "Top"
							TextLabel.BackgroundTransparency = 1
							TextLabel.TextStrokeTransparency = 0.5
							TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
							TextLabel.Text = child.Name .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
						end
					end
				end
			end
		elseif workspace:FindFirstChild("Gay") then
			workspace:FindFirstChild("Gay"):Destroy()
		end
	end
	LegenSword = function()
		if LegenS then
			for _, child in pairs(ReplicatedStorage2.NPCs:GetChildren()) do
				if child.Name == "Legendary Sword Dealer" then
					if not workspace:FindFirstChild("Lgd") then
						Lgd = Instance.new("Part")
						Lgd.Name = "Lgd"
						Lgd.Transparency = 1
						Lgd.Size = Vector3.new(1, 1, 1)
						Lgd.Anchored = true
						Lgd.CanCollide = false
						Lgd.Parent = workspace
						Lgd.CFrame = child.HumanoidRootPart.CFrame
					elseif workspace:FindFirstChild("Lgd") then
						if Lgd:FindFirstChild("NameEsp") then
							Lgd.NameEsp.TextLabel.Text = child.Name .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
						else
							local BillboardGui = Instance.new("BillboardGui", Lgd)

							BillboardGui.Name = "NameEsp"
							BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
							BillboardGui.Size = UDim2.new(1, 200, 1, 30)
							BillboardGui.Adornee = Lgd
							BillboardGui.AlwaysOnTop = true

							local TextLabel = Instance.new("TextLabel", BillboardGui)

							TextLabel.Font = "Code"
							TextLabel.FontSize = "Size14"
							TextLabel.TextWrapped = true
							TextLabel.Size = UDim2.new(1, 0, 1, 0)
							TextLabel.TextYAlignment = "Top"
							TextLabel.BackgroundTransparency = 1
							TextLabel.TextStrokeTransparency = 0.5
							TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
							TextLabel.Text = child.Name .. "   \n" .. v1152((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
						end
					end
				end
			end
		elseif workspace:FindFirstChild("Lgd") then
			workspace:FindFirstChild("Lgd"):Destroy()
		end
	end
end

ChestEsp = function()
	if ChestESP then
		local tagged = game:GetService("CollectionService"):GetTagged("_ChestTagged")

		for _, v1 in ipairs(tagged) do
			pcall(function()
				local Magnitude = (v1:GetPivot().Position - LocalPlayer.Character.Head.Position).Magnitude

				v1:GetFullName():gsub("[^%w_]", "_")

				local ChestEspAttachment = v1:FindFirstChild("ChestEspAttachment")

				if not ChestEspAttachment then
					local Attachment = Instance.new("Attachment")

					Attachment.Name = "ChestEspAttachment"
					Attachment.Parent = v1
					Attachment.Position = Vector3.new(0, 3, 0)

					local BillboardGui = Instance.new("BillboardGui")

					BillboardGui.Name = "NameEsp"
					BillboardGui.Size = UDim2.new(0, 200, 0, 30)
					BillboardGui.Adornee = Attachment
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.AlwaysOnTop = true
					BillboardGui.Parent = Attachment

					local TextLabel = Instance.new("TextLabel")

					TextLabel.Font = Enum.Font.Code
					TextLabel.TextSize = 14
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = Enum.TextYAlignment.Top
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
					TextLabel.Parent = BillboardGui
				end

				local NameEsp = ChestEspAttachment and ChestEspAttachment:FindFirstChild("NameEsp")

				if NameEsp then
					local v1207 = math.floor(Magnitude / 3)

					NameEsp.TextLabel.Text = string.format("[%s] %d M", v1.Name:gsub("Label", ""), v1207)
				end
			end)
		end
	else
		for _, v1 in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
			local ChestEspAttachment = v1:FindFirstChild("ChestEspAttachment")

			if ChestEspAttachment then
				ChestEspAttachment:Destroy()
			end
		end
	end
end
berriesEsp = function()
	if BerryEsp then
		local tagged = game:GetService("CollectionService"):GetTagged("BerryBush")

		for _, v1 in ipairs(tagged) do
			pcall(function()
				local Position = v1.Parent:GetPivot().Position

				for _, v2 in pairs(v1:GetAttributes()) do
					if v2 then
						local name = "BerryEspPart_" .. v2 .. "_" .. tostring(Position)
						local Part2 = workspace:FindFirstChild(name)

						if not Part2 then
							Part2 = Instance.new("Part")
							Part2.Name = name
							Part2.Transparency = 1
							Part2.Size = Vector3.new(1, 1, 1)
							Part2.Anchored = true
							Part2.CanCollide = false
							Part2.Parent = workspace
							Part2.CFrame = CFrame.new(Position)
						end

						if not Part2:FindFirstChild("NameEsp") then
							local BillboardGui = Instance.new("BillboardGui", Part2)

							BillboardGui.Name = "NameEsp"
							BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
							BillboardGui.Size = UDim2.new(0, 200, 0, 30)
							BillboardGui.Adornee = Part2
							BillboardGui.AlwaysOnTop = true

							local TextLabel = Instance.new("TextLabel", BillboardGui)

							TextLabel.Font = Enum.Font.Code
							TextLabel.TextSize = 14
							TextLabel.TextWrapped = true
							TextLabel.Size = UDim2.new(1, 0, 1, 0)
							TextLabel.TextYAlignment = Enum.TextYAlignment.Top
							TextLabel.BackgroundTransparency = 1
							TextLabel.TextStrokeTransparency = 0.5
							TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
						end

						local NameEsp = Part2:FindFirstChild("NameEsp")
						local v1222 = (LocalPlayer.Character.Head.Position - Position).Magnitude / 3

						if NameEsp then
							NameEsp.TextLabel.Text = "[" .. v2 .. "]" .. " " .. math.round(v1222) .. " M"
						end
					end
				end
			end)
		end
	else
		for _, child in ipairs(workspace:GetChildren()) do
			if child:IsA("Part") then
				if child.Name:match("BerryEspPart_.*") then
					child:Destroy()
				end
			end
		end
	end
end
GRP_Esp_Esp:AddToggle("Esp_Berry", {
	Text = "Esp Berry",
	Default = false,
	Callback = function(p283)
		BerryEsp = p283

		if p283 then
			task.spawn(function()
				while BerryEsp do
					berriesEsp()
					task.wait()
				end
			end)
		else
			for _, child in ipairs(workspace:GetChildren()) do
				if child:IsA("Part") then
					if child.Name:match("BerryEspPart_.*") then
						child:Destroy()
					end
				end
			end
		end
	end
})

do
	GRP_Esp_Esp:AddToggle("Esp_Player", {
		Text = "Esp Player",
		Default = false,
		Callback = function(p284)
			PlayerEsp = p284

			if p284 then
				task.spawn(function()
					while PlayerEsp do
						EspPly()
						task.wait()
					end
				end)
			else
				local next_ = next
				local children, v1229 = game.Players:GetChildren()

				for _, v1 in next_, children, v1229 do
					pcall(function()
						if not (isnil(v1.Character) or isnil(v1.Character.Head)) then
							if v1.Character.Head:FindFirstChild("NameEsp" .. Number) then
								v1.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
							end
						end
					end)
				end
			end
		end
	})
end

do
	GRP_Esp_Esp:AddToggle("Esp_Chest", {
		Text = "Esp Chest",
		Default = false,
		Callback = function(p285)
			ChestESP = p285

			if p285 then
				task.spawn(function()
					while ChestESP do
						ChestEsp()
						task.wait()
					end
				end)
			else
				for _, v1 in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
					local ChestEspAttachment = v1:FindFirstChild("ChestEspAttachment")

					if ChestEspAttachment then
						ChestEspAttachment:Destroy()
					end
				end
			end
		end
	})
end

GRP_Esp_Esp:AddToggle("Esp_Fruit", {
	Text = "Esp Fruit",
	Default = false,
	Callback = function(p286)
		DevilFruitESP = p286

		if p286 then
			task.spawn(function()
				while DevilFruitESP do
					DevEsp()
					task.wait()
				end
			end)
		else
			local next_ = next
			local children, v1237 = workspace:GetChildren()

			for _, v1 in next_, children, v1237 do
				pcall(function()
					if v1:FindFirstChild("Handle") then
						if v1.Handle:FindFirstChild("NameEsp" .. Number) then
							v1.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
						end
					end
				end)
			end
		end
	end
})
GRP_Esp_Esp:AddToggle("Esp_Island", {
	Text = "Esp Island",
	Default = false,
	Callback = function(p287)
		IslandESP = p287

		if p287 then
			task.spawn(function()
				while IslandESP do
					LocationEsp()
					task.wait()
				end
			end)
		else
			local next_ = next
			local children, v1242 = workspace._WorldOrigin.Locations:GetChildren()

			for _, v1 in next_, children, v1242 do
				pcall(function()
					if v1:FindFirstChild("NameEsp") then
						v1:FindFirstChild("NameEsp"):Destroy()
					end
				end)
			end
		end
	end
})

do
	GRP_Esp_Esp:AddToggle("Esp_Flower", {
		Text = "Esp Flower",
		Default = false,
		Callback = function(p288)
			FlowerESP = p288

			if p288 then
				task.spawn(function()
					while FlowerESP do
						flowerEsp()
						task.wait()
					end
				end)
			else
				for _, child in pairs(workspace:GetChildren()) do
					pcall(function()
						if (child.Name == "Flower2" or child.Name == "Flower1") and child:FindFirstChild("NameEsp" .. Number) then
							child:FindFirstChild("NameEsp" .. Number):Destroy()
						end
					end)
				end
			end
		end
	})
end

GRP_Esp_Esp:AddToggle("Esp_Legendary_Sword", {
	Text = "Esp Legendary Sword",
	Default = false,
	Callback = function(p289)
		LegenS = p289

		if p289 then
			task.spawn(function()
				while LegenS do
					LegenSword()
					task.wait()
				end
			end)
		elseif workspace:FindFirstChild("Lgd") then
			workspace:FindFirstChild("Lgd"):Destroy()
		end
	end
})

do
	GRP_Esp_Esp:AddToggle("Esp_Haki_Color", {
		Text = "Esp Haki Color",
		Default = false,
		Callback = function(p290)
			ColorEsp = p290

			if p290 then
				task.spawn(function()
					while ColorEsp do
						HakiClorEsp()
						task.wait()
					end
				end)
			elseif workspace:FindFirstChild("Gay") then
				workspace:FindFirstChild("Gay"):Destroy()
			end
		end
	})
end

GRP_Esp_Esp:AddToggle("Esp_Gear", {
	Text = "Esp Gear",
	Default = false,
	Callback = function(p291)
		ESPGear = p291

		if p291 then
			task.spawn(function()
				while ESPGear do
					gearEsp()
					task.wait()
				end
			end)
		else
			local pairs_ = pairs
			local MysticIsland = workspace.Map:FindFirstChild("MysticIsland")

			for _, descendant in pairs_(MysticIsland:GetDescendants()) do
				pcall(function()
					if descendant:FindFirstChild("NameEsp") then
						descendant:FindFirstChild("NameEsp"):Destroy()
					end
				end)
			end
		end
	end
})
GRP_Esp_Esp:AddToggle("Esp_SeaEvent_Island", {
	Text = "Esp SeaEvent Island",
	Default = false,
	Callback = function(p292)
		EspEventIsland = p292

		if p292 then
			task.spawn(function()
				while EspEventIsland do
					EventIslandEsp()
					task.wait()
				end
			end)
		else
			for _, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
				pcall(function()
					if child:FindFirstChild("NameEsp") then
						child:FindFirstChild("NameEsp"):Destroy()
					end
				end)
			end
		end
	end
})

do
	GRP_Esp_Esp:AddToggle("Esp_Advanced_Dealer", {
		Text = "Esp Advanced Dealer",
		Default = false,
		Callback = function(p293)
			advanEsp = p293

			if p293 then
				task.spawn(function()
					while advanEsp do
						AdvanFruitEsp()
						task.wait()
					end
				end)
			elseif workspace:FindFirstChild("Adv") then
				workspace:FindFirstChild("Adv"):Destroy()
			end
		end
	})
end

GRP_Raids_Fruits_Options = t15.Raids:AddLeftGroupbox("Fruits Options")

do
	local function v1253(p294)
		local v1254 = tostring(p294)
		local v1255

		repeat
			v1254, v1255 = v1254:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
		until v1255 == 0

		return v1254
	end
	local function v1256()
		local s21 = "Advance Fruit Stock\n"
		local ok, result = pcall(function()
			return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits", true)
		end)

		if ok and result then
			local v1260 = false

			for _, v1 in pairs(result) do
				if v1.OnSale then
					v1260 = true
					s21 ..= v1.Name .. " - $" .. v1253(v1.Price) .. "\n"
				end
			end

			if not v1260 then
				s21 ..= "- No fruit.\n"
			end
		else
			s21 ..= "- Error while retrieving data.\n"
		end

		local v1263 = s21 .. "\nNormal Fruit Stock\n"
		local ok2, result2 = pcall(function()
			return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
		end)

		if ok2 and result2 then
			local v1266 = false

			for _, v1 in pairs(result2) do
				if v1.OnSale then
					v1266 = true
					v1263 ..= v1.Name .. " - $" .. v1253(v1.Price) .. "\n"
				end
			end

			if not v1266 then
				v1263 ..= "- No fruit.\n"
			end
		else
			v1263 ..= "- Error while retrieving data.\n"
		end

		return v1263
	end

	local v1269 = GRP_Raids_Fruits_Options:AddLabel("Loading...")

	task.spawn(function()
		while task.wait(60) do
			pcall(function()
				v1269:SetText(v1256())
			end)
		end
	end)
	pcall(function()
		v1269:SetText(v1256())
	end)
end

RandomFF = GRP_Raids_Fruits_Options:AddToggle("Auto_Random_Fruit", {
	Text = "Auto Random Fruit",
	Default = false,
	Callback = function(p295)
		_G.Random_Auto = p295
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Random_Auto then
				ReplicatedStorage2.Remotes.CommF_:InvokeServer("Cousin", "Buy")
			end
		end)
	end
end)
DropF = GRP_Raids_Fruits_Options:AddToggle("Auto_Drop_Fruit", {
	Text = "Auto Drop Fruit",
	Default = false,
	Callback = function(p296)
		_G.DropFruit = p296
	end
})
spawn(function()
	while wait(Sec) do
		if _G.DropFruit then
			pcall(function()
				DropFruits()
			end)
		end
	end
end)

do
	StoredF = GRP_Raids_Fruits_Options:AddToggle("Auto_Store_Fruit", {
		Text = "Auto Store Fruit",
		Default = false,
		Callback = function(p297)
			_G.StoreF = p297
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.StoreF then
			pcall(function()
				UpdStFruit()
			end)
		end
	end
end)

do
	TwF = GRP_Raids_Fruits_Options:AddToggle("Auto_Tween_to_Fruit", {
		Text = "Auto Tween to Fruit",
		Default = false,
		Callback = function(p298)
			_G.TwFruits = p298
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.TwFruits then
			local exitTo

			repeat
				pcall(function()
					for _, child in pairs(workspace:GetChildren()) do
						if string.find(child.Name, "Fruit") then
							_tp(child.Handle.CFrame)
						end
					end
				end)
				exitTo = nil

				while wait(Sec) do
					if _G.TwFruits then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)
BringF = GRP_Raids_Fruits_Options:AddToggle("Auto_Collect_Fruit", {
	Text = "Auto Collect Fruit",
	Default = false,
	Callback = function(p299)
		_G.InstanceF = p299
	end
})
spawn(function()
	while wait(Sec) do
		if _G.InstanceF then
			local exitTo

			repeat
				pcall(function()
					collectFruits(_G.InstanceF)
				end)
				exitTo = nil

				while wait(Sec) do
					if _G.InstanceF then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)
GRP_Raids_Fruits_Options:AddDropdown("Select_Fruit_Shop", {
	Text = "Select Fruit Shop",
	Values = {
		"Rocket-Rocket",
		"Spin-Spin",
		"Blade-Blade",
		"Spring-Spring",
		"Bomb-Bomb",
		"Smoke-Smoke",
		"Spike-Spike",
		"Flame-Flame",
		"Ice-Ice",
		"Sand-Sand",
		"Dark-Dark",
		"Eagle-Eagle",
		"Diamond-Diamond",
		"Light-Light",
		"Rubber-Rubber",
		"Ghost-Ghost",
		"Magma-Magma",
		"Quake-Quake",
		"Buddha-Buddha",
		"Love-Love",
		"Creation-Creation",
		"Spider-Spider",
		"Sound-Sound",
		"Phoenix-Phoenix",
		"Portal-Portal",
		"Lightning-Lightning",
		"Pain-Pain",
		"Blizzard-Blizzard",
		"Gravity-Gravity",
		"T-Rex-T-Rex",
		"Mammoth-Mammoth",
		"Dough-Dough",
		"Shadow-Shadow",
		"Venom-Venom",
		"Gas-Gas",
		"Control-Control",
		"Spirit-Spirit",
		"Leopard-Leopard",
		"Yeti-Yeti",
		"Kitsune-Kitsune",
		"Dragon-Dragon"
	},
	Default = 1,
	Callback = function(p300)
		getgenv().SelectFruit = p300
	end
})
GRP_Raids_Fruits_Options:AddToggle("Auto_Buy_Fruit_Shop", {
	Text = "Auto Buy Fruit Shop",
	Default = false,
	Callback = function(p301)
		getgenv().AutoBuyFruitSniper = p301
	end
})
spawn(function()
	pcall(function()
		while wait() do
			if getgenv().AutoBuyFruitSniper then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit", getgenv().SelectFruit)
			end
		end
	end)
end)
GRP_Raids_Dungeon_Event_Raiding = t15.Raids:AddLeftGroupbox("Dungeon Event / Raiding")
Q = GRP_Raids_Dungeon_Event_Raiding:AddDropdown("Select_Chip", {
	Text = "Select Chip",
	Values = {
		"Flame",
		"Ice",
		"Quake",
		"Light",
		"Dark",
		"String",
		"Rumble",
		"Magma",
		"Human: Buddha",
		"Sand",
		"Bird: Phoenix",
		"Dough"
	},
	Default = 1,
	Callback = function(p302)
		_G.SelectChip = p302
	end
})
Q = GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Select_Dungeon_Chip", {
	Text = "Auto Select Dungeon Chip",
	Default = false,
	Callback = function(p303)
		_G.AutoSelectDungeon = p303
	end
})
GRP_Raids_Dungeon_Event_Raiding:AddToggle("Get_Fruit_In_Inventory_Below_1M", {
	Text = "Get Fruit In Inventory Below 1M",
	Default = false,
	Callback = function(p304)
		getgenv().AutoGetFruit = p304
	end
})
spawn(function()
	while wait() do
		pcall(function()
			if getgenv().AutoGetFruit then
				for _, v1 in ipairs({
					"Rocket-Rocket",
					"Spin-Spin",
					"Chop-Chop",
					"Spring-Spring",
					"Bomb-Bomb",
					"Smoke-Smoke",
					"Spike-Spike",
					"Flame-Flame",
					"Falcon-Falcon",
					"Ice-Ice",
					"Sand-Sand",
					"Dark-Dark",
					"Ghost-Ghost",
					"Diamond-Diamond",
					"Light-Light",
					"Rubber-Rubber",
					"Barrier-Barrier"
				}) do
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
						"LoadFruit",
						v1
					}))
				end
			end
		end)
	end
end)
GRP_Raids_Dungeon_Event_Raiding:AddButton({
	Text = "Buy Dungeon Chips [Beli]",
	Func = function()
	end
})
GRP_Raids_Dungeon_Event_Raiding:AddButton({
	Text = "Buy Dungeon Chips [Devil Fruit]",
	Func = function()
	end
})
AutoChipBeli = GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Buy_Chip_[Beli]", {
	Text = "Auto Buy Chip [Beli]",
	Default = false,
	Callback = function()
	end
})
task.spawn(function()
	while task.wait(1) do
		if _G.AutoChipBeli then
			pcall(function()
				if not GetBP("Special Microchip") then
					ReplicatedStorage2.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
				end
			end)
		end
	end
end)

do
	AutoChipFruit = GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Buy_Chip_[Devil_Fruit]", {
		Text = "Auto Buy Chip [Devil Fruit]",
		Default = false,
		Callback = function(p305)
			_G.AutoChipFruit = p305
		end
	})
end

do
	task.spawn(function()
		while task.wait(1) do
			if _G.AutoChipFruit then
				pcall(function()
					if not GetBP("Special Microchip") then
						local response = ReplicatedStorage2.Remotes.CommF_:InvokeServer("GetFruits")
						local Name

						for _, v1 in pairs(response) do
							if v1.Price <= 490000 then
								Name = v1.Name

								break
							end
						end

						if Name then
							ReplicatedStorage2.Remotes.CommF_:InvokeServer("LoadFruit", tostring(Name))
							ReplicatedStorage2.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
						end
					end
				end)
			end
		end
	end)
end

StartR = GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Start_Raid", {
	Text = "Auto Start Raid",
	Default = false,
	Callback = function(p306)
		_G.Auto_StartRaid = p306
	end
})
task.spawn(function()
	while task.wait(Sec) do
		if _G.Auto_StartRaid and LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible == false and GetBP("Special Microchip") then
			if World2 then
				_tp(CFrame.new(-6438.73535, 250.645355, -4501.50684))
				fireclickdetector(workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
			elseif World3 then
				_tp(CFrame.new(-5046, 314, -2960))
				task.wait(1.5)
				pcall(function()
					local Main = workspace.Map["Boat Castle"].RaidSummon2.Button.Main

					if Main and Main:FindFirstChild("ClickDetector") then
						fireclickdetector(Main.ClickDetector)
					end
				end)
			end
		end
	end
end)
Raiding = GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Raid_+_Next_Island", {
	Text = "Auto Raid + Next Island",
	Default = false,
	Callback = function(p307)
		_G.Raiding = p307
	end
})

do
	spawn(function()
		local Locations = workspace._WorldOrigin.Locations
		local t48 = {
			"Island 1",
			"Island 2",
			"Island 3",
			"Island 4",
			"Island 5"
		}
		local v1283

		while task.wait(0.3) do
			if _G.Raiding and LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
				local Character = LocalPlayer.Character

				if Character then
					local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character:FindFirstChildOfClass("Humanoid")

					if HumanoidRootPart and Humanoid and not (Humanoid.Health <= 0) and not Humanoid.Sit and not Humanoid.PlatformStand and not HumanoidRootPart.Anchored then
						local n7 = 999999

						for _, v1 in ipairs(t48) do
							local v1290 = Locations:FindFirstChild(v1)

							if v1290 then
								local Magnitude = (HumanoidRootPart.Position - v1290.Position).Magnitude

								if Magnitude < n7 then
									n7 = Magnitude
									v1283 = v1
								end
							end
						end

						if v1283 then
							local v1292 = Locations:FindFirstChild(v1283)

							if v1292 then
								local v1293 = false

								for _, child in ipairs(workspace.Enemies:GetChildren()) do
									local Humanoid2 = child:FindFirstChild("Humanoid")
									local HumanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")

									if Humanoid2 and HumanoidRootPart2 and Humanoid2.Health > 0 and (HumanoidRootPart2.Position - v1292.Position).Magnitude < 450 then
										v1293 = true

										while true do
											task.wait()
											t9.Kill(child, _G.Raiding)

											if not _G.Raiding then
												break
											elseif not child.Parent or Humanoid2.Health <= 0 then
												break
											end
										end
									end
								end

								if not v1293 then
									local v1298 = table.find(t48, v1283)

									if v1298 and t48[v1298 + 1] then
										local v1299 = Locations:FindFirstChild(t48[v1298 + 1])

										if v1299 then
											_tp(v1299.CFrame * CFrame.new(0, 45, 120))
										end

										v1283 = t48[v1298 + 1]
										task.wait(1)
									end
								end
							end
						end
					end
				end
			end
		end
	end)
end

GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Awakening", {
	Text = "Auto Awakening",
	Default = false,
	Callback = function(p308)
		_G.Auto_Awakener = p308
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Auto_Awakener then
					ReplicatedStorage2.Remotes.CommF_:InvokeServer("Awakener", "Check")
					ReplicatedStorage2.Remotes.CommF_:InvokeServer("Awakener", "Awaken")
				end
			end)
		end
	end)
end

GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Teleport_To_Lab", {
	Text = "Auto Teleport To Lab",
	Default = false,
	Callback = function(p309)
		_G.TpLab = p309

		while _G.TpLab do
			wait()

			if _G.TpLab then
				if World2 and _G.TpLab then
					_tp(CFrame.new(-6438.73535, 250.645355, -4501.50684))
				elseif World3 and _G.TpLab then
					_tp(CFrame.lookAt(Vector3.new(-5046, 314, -2960), Vector3.new(-5055, 314, -2957)))
				end
			end
		end
	end
})
GRP_Raids_Items_Law_Order_Sword = t15.Raids:AddLeftGroupbox("Items Law/Order Sword")

do
	GRP_Raids_Items_Law_Order_Sword:AddButton({
		Text = "Buy Microchip Law",
		Func = function()
		end
	})
end

GRP_Raids_Items_Law_Order_Sword:AddButton({
	Text = "Start Law Raids",
	Func = function()
	end
})

do
	GRP_Raids_Items_Law_Order_Sword:AddToggle("Auto_Buy_Microchip_Law", {
		Text = "Auto Buy Microchip Law",
		Default = false,
		Callback = function(p310)
			_G.AutoLawKak = p310
		end
	})
end

spawn(function()
	while task.wait(1) do
		if getgenv().AutoBuyMicrochipLaw then
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Microchip", "2")
			end)
		end
	end
end)
GRP_Raids_Items_Law_Order_Sword:AddToggle("Auto_Start_Law_Raids", {
	Text = "Auto Start Law Raids",
	Default = false,
	Callback = function(p311)
		getgenv().AutoStartLawRaids = p311
	end
})
spawn(function()
	while task.wait(1) do
		if getgenv().AutoStartLawRaids then
			pcall(function()
				fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
			end)
		end
	end
end)
GRP_Raids_Items_Law_Order_Sword:AddToggle("Auto_Kill_Law", {
	Text = "Auto Kill Law",
	Default = false,
	Callback = function(p312)
		_G.AutoLawKak = p312
	end
})
spawn(function()
	while wait(Sec) do
		if _G.AutoLawKak then
			pcall(function()
				local Order = GetConnectionEnemies("Order")

				if Order then
					while true do
						task.wait()
						t9.Kill(Order, _G.AutoLawKak)

						if _G.AutoLawKak == false then
							break
						elseif not Order.Parent or Order.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875))
				end
			end)
		end
	end
end)
GRP_Raids_Raids_Dungeons = t15.Raids:AddLeftGroupbox("Raids Dungeons")

local LocalPlayer2 = game.Players.LocalPlayer

do
	local function v1302()
		local Character = LocalPlayer2.Character

		return Character and Character:FindFirstChild("HumanoidRootPart")
	end

	GRP_Raids_Raids_Dungeons:AddToggle("Auto_Farm_Dungeon", {
		Text = "Auto Farm Dungeon",
		Default = false,
		Callback = function(p313)
			_G.AutoFarmDungeon = p313
		end
	})
	spawn(function()
		while task.wait(0.15) do
			if _G.AutoFarmDungeon then
				pcall(function()
					local Character = game.Players.LocalPlayer.Character
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

					if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then
						return
					end

					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if not _G.AutoFarmDungeon then
							break
						end

						local Humanoid2 = child:FindFirstChild("Humanoid")
						local HumanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")

						if Humanoid2 and HumanoidRootPart2 and Humanoid2.Health > 0 and (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude <= 5000 then
							while true do
								task.wait()
								t9.Kill(child, true)

								if not _G.AutoFarmDungeon then
									break
								elseif not child.Parent or Humanoid2.Health <= 0 then
									break
								end
							end
						end
					end
				end)
			end
		end
	end)
	GRP_Raids_Raids_Dungeons:AddToggle("TP_Exit_(1)", {
		Text = "TP Exit (1)",
		Default = false,
		Callback = function(p314)
			_G.TPFloor1 = p314
		end
	})

	local u1311 = false

	local function v1312()
		local v1313 = v1302()

		if not v1313 then
			return
		end

		for _, child in pairs(workspace.Map.Dungeon:GetChildren()) do
			local ExitTeleporter = child:FindFirstChild("ExitTeleporter")

			if ExitTeleporter and ExitTeleporter:FindFirstChild("Root") and (v1313.Position - ExitTeleporter.Root.Position).Magnitude < 200 then
				return ExitTeleporter.Root
			end
		end
	end

	task.spawn(function()
		while task.wait(0.3) do
			if _G.TPFloor1 then
				if not u1311 then
					local v1317 = v1312()

					if v1317 then
						local cFrame = v1317.CFrame * CFrame.new(0, 3, 0)

						v1302().CFrame = cFrame
						u1311 = true
					end
				end
			else
				u1311 = false
			end
		end
	end)
	GRP_Raids_Raids_Dungeons:AddToggle("TP_Exit_(2)", {
		Text = "TP Exit (2)",
		Default = false,
		Callback = function(p315)
			_G.TPFloor2 = p315
		end
	})

	local u1319 = false

	task.spawn(function()
		while task.wait(0.3) do
			if _G.TPFloor2 then
				if not u1319 then
					local v1320 = v1302()

					if v1320 then
						for _, child in pairs(workspace.Map.Dungeon:GetChildren()) do
							local EntranceTeleporter = child:FindFirstChild("EntranceTeleporter")
							local ExitTeleporter = child:FindFirstChild("ExitTeleporter")

							if EntranceTeleporter and ExitTeleporter and EntranceTeleporter:FindFirstChild("Root") and ExitTeleporter:FindFirstChild("Root") and (v1320.Position - EntranceTeleporter.Root.Position).Magnitude < 100 then
								v1320.CFrame = ExitTeleporter.Root.CFrame * CFrame.new(0, 3, 0)
								u1319 = true

								break
							end
						end
					end
				end
			else
				u1319 = false
			end
		end
	end)
	GRP_Raids_Raids_Dungeons:AddToggle("TP_Exit_(3)", {
		Text = "TP Exit (3)",
		Default = false,
		Callback = function(p316)
			_G.TPFloor3 = p316
		end
	})

	local u1325 = false

	local function v1326()
		local v1327

		for _, child in pairs(workspace.Map.Dungeon:GetChildren()) do
			local v1330 = tonumber(child.Name)

			if v1330 and (not v1327 or tonumber(v1327.Name) < v1330) then
				v1327 = child
			end
		end

		return v1327
	end

	task.spawn(function()
		while task.wait(0.3) do
			if _G.TPFloor3 then
				if not u1325 then
					local v1331 = v1326()

					if v1331 and v1331:FindFirstChild("ExitTeleporter") then
						if v1331.ExitTeleporter:FindFirstChild("Root") then
							v1302().CFrame = v1331.ExitTeleporter.Root.CFrame * CFrame.new(0, 3, 0)
							u1325 = true
						end
					end
				end
			else
				u1325 = false
			end
		end
	end)
	GRP_Raids_Raids_Dungeons:AddToggle("TP_Exit_(4)", {
		Text = "TP Exit (4)",
		Default = false,
		Callback = function(p317)
			_G.TPFloor4 = p317
		end
	})

	local u1332 = false

	local function v1333()
		local v1334 = v1302()

		if not v1334 then
			return
		end

		local Root_
		local huge = math.huge

		for _, child in pairs(workspace.Map.Dungeon:GetChildren()) do
			local ExitTeleporter = child:FindFirstChild("ExitTeleporter")

			if ExitTeleporter and ExitTeleporter:FindFirstChild("Root") then
				local Magnitude = (v1334.Position - ExitTeleporter.Root.Position).Magnitude

				if Magnitude < huge then
					huge = Magnitude
					Root_ = ExitTeleporter.Root
				end
			end
		end

		return Root_
	end

	task.spawn(function()
		while task.wait(0.3) do
			if _G.TPFloor4 then
				if not u1332 then
					local v1341 = v1333()

					if v1341 then
						v1302().CFrame = v1341.CFrame * CFrame.new(0, 3, 0)
						u1332 = true
					end
				end
			else
				u1332 = false
			end
		end
	end)
end

GRP_Combat_Combat_AimBot = t15.Combat:AddLeftGroupbox("Combat / AimBot")

local v1342 = GRP_Combat_Combat_AimBot:AddLabel("")

spawn(function()
	while wait(Sec) do
		pcall(function()
			local v1343 = #game:GetService("Players"):GetPlayers()

			if v1343 == 12 then
				v1342:SetText("All Players : " .. v1343 .. " / 12 [Max]")
			else
				v1342:SetText("All Players : " .. v1343 .. " / 12")
			end
		end)
	end
end)

do
	local v1344 = GRP_Combat_Combat_AimBot:AddLabel("")

	Checking_AimStatus = function()
		if _G.AimCam then
			return "Aimbot Camera"
		end

		if _G.AimbotGun then
			return "Aimbot Guns"
		end

		return ""
	end
	spawn(function()
		while wait(0.2) do
			pcall(function()
				if not _G.AimMethod then
					v1344:SetText("Aimbot - Skills : False")
				elseif _G.AimCam or _G.AimbotGun then
					v1344:SetText("Aimbot - " .. Checking_AimStatus() .. " : True")
				else
					v1344:SetText("Aimbot - Skills : True")
				end
			end)
		end
	end)
end

do
	local t49 = {}
	local Players2 = game:GetService("Players")

	for _, child in pairs(Players2:GetChildren()) do
		table.insert(t49, child.Name)
	end

	GRP_Combat_Combat_AimBot:AddDropdown("Select_Players", {
		Text = "Select Players",
		Values = t49,
		Default = 1,
		Callback = function(p318)
			_G.PlayersList = p318
		end
	})
end

GRP_Combat_Combat_AimBot:AddToggle("Teleport_To_Select_Players", {
	Text = "Teleport To Select Players",
	Default = false,
	Callback = function(p319)
		_G.TpPly = p319
		spawn(function()
			pcall(function()
				while _G.TpPly do
					wait()
					_tp(game:GetService("Players")[_G.PlayersList].Character.HumanoidRootPart.CFrame)
				end
			end)
		end)
	end
})
GRP_Combat_Combat_AimBot:AddToggle("Spectate_Select_Players", {
	Text = "Spectate Select Players",
	Default = false,
	Callback = function(p320)
		SpectatePlys = p320
		spawn(function()
			repeat
				task.wait(0.1)

				if _G.PlayersList then
					if game:GetService("Players"):FindFirstChild(_G.PlayersList) then
						workspace.Camera.CameraSubject = game:GetService("Players"):FindFirstChild(_G.PlayersList).Character.Humanoid
					end
				end
			until not SpectatePlys

			workspace.Camera.CameraSubject = LocalPlayer2.Character.Humanoid
		end)
	end
})
GRP_Combat_Combat_AimBot:AddDropdown("Select_Aim_Method", {
	Text = "Select Aim Method",
	Values = {
		"Aim Player",
		"Nearest Aim"
	},
	Default = 1,
	Callback = function(p321)
		ABmethod = p321
	end
})
GRP_Combat_Combat_AimBot:AddToggle("Aimbot_Method_Skills", {
	Text = "Aimbot Method Skills",
	Default = false,
	Callback = function(p322)
		_G.AimMethod = p322
	end
})
spawn(function()
	while wait() do
		pcall(function()
			if _G.AimMethod and ABmethod == "Aim Player" then
				local v1349 = Players:FindFirstChild(getgenv().PlayersList)

				if v1349 and v1349.Character then
					if v1349.Character:FindFirstChild("HumanoidRootPart") and v1349.Team ~= LocalPlayer2.Team then
						MousePos = v1349.Character.HumanoidRootPart.Position
					end
				end
			end
		end)
	end
end)
spawn(function()
	while wait() do
		pcall(function()
			if _G.AimMethod and ABmethod == "Nearest Aim" then
				local huge = math.huge

				for _, player in pairs(Players:GetPlayers()) do
					if player ~= LocalPlayer2 and player.Team ~= LocalPlayer2.Team and player.Character then
						if player.Character:FindFirstChild("HumanoidRootPart") then
							local Magnitude = (player.Character.HumanoidRootPart.Position - LocalPlayer2.Character.HumanoidRootPart.Position).Magnitude

							if Magnitude < huge then
								huge = Magnitude
								MousePos = player.Character.HumanoidRootPart.Position
							end
						end
					end
				end
			end
		end)
	end
end)
GRP_Combat_Combat_AimBot:AddToggle("Aimbot_Camera_Closet_Players", {
	Text = "Aimbot Camera Closet Players",
	Default = false,
	Callback = function(p323)
		_G.AimCam = p323
	end
})
task.spawn(function()
	while task.wait(Sec) do
		pcall(function()
			if _G.AimCam then
				local CurrentCamera = workspace.CurrentCamera

				closestplayer = function()
					local huge = math.huge
					local v1356
					local players, v1358 = ply:GetPlayers()

					for _, v1 in next, players, v1358 do
						if v1 ~= LocalPlayer2 and v1.Character then
							if v1.Character:FindFirstChild("Head") and _G.AimCam and v1.Character.Humanoid.Health > 0 then
								local Magnitude = (v1.Character.Head.Position - LocalPlayer2.Character.Head.Position).Magnitude

								if Magnitude < huge then
									huge = Magnitude
									v1356 = v1
								end
							end
						end
					end

					return v1356
				end

				while true do
					task.wait()
					CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, closestplayer().Character.HumanoidRootPart.Position)

					if _G.AimCam == false then
						break
					elseif dist < Mag then
						break
					end
				end
			end
		end)
	end
end)
GRP_Combat_Quests_Players = t15.Combat:AddLeftGroupbox("Quests Players")
GRP_Combat_Quests_Players:AddButton({
	Text = "Get player quests",
	Func = function()
	end
})
GRP_Combat_Quests_Players:AddToggle("Auto_Get_PlayerQuest", {
	Text = "Auto Get PlayerQuest",
	Default = false,
	Callback = function(p324)
		_G.AutoReceivePlayerQuest = p324
	end
})
spawn(function()
	while task.wait(1) do
		if _G.AutoReceivePlayerQuest then
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
			end)
		end
	end
end)
GRP_Combat_Quests_Players:AddToggle("Auto_Kill_Player_Quest", {
	Text = "Auto Kill Player Quest",
	Default = false,
	Callback = function(p325)
		_G.AutoPlayerHunter = p325
	end
})

do
	spawn(function()
		while task.wait() do
			if _G.AutoPlayerHunter then
				if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false then
					task.wait(0.5)
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
				else
					for _, child in pairs(game:GetService("Workspace").Characters:GetChildren()) do
						if string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, child.Name) then
							repeat
								task.wait()

								if AutoHaki then
									AutoHaki()
								end

								if EquipWeapon then
									EquipWeapon(_G.SelectWeapon)
								end

								Useskill = true
								_tp(child.HumanoidRootPart.CFrame * CFrame.new(1, 7, 3))
								child.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
								game:GetService("VirtualUser"):CaptureController()
								game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
							until _G.AutoPlayerHunter == false or child.Humanoid.Health <= 0

							Useskill = false
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
						end
					end
				end
			end
		end
	end)
end

GRP_Combat_Quests_Players:AddToggle("Auto_Enable_PvP", {
	Text = "Auto Enable PvP",
	Default = false,
	Callback = function(p326)
		_G.AutoPvP = p326
	end
})

do
	spawn(function()
		while task.wait(0.5) do
			if _G.AutoPvP then
				local PlayerGui = game.Players.LocalPlayer.PlayerGui

				if PlayerGui and PlayerGui.Main then
					if PlayerGui.Main:FindFirstChild("PvpDisabled") and PlayerGui.Main.PvpDisabled.Visible then
						local exitTo

						repeat
							pcall(function()
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
							end)
							exitTo = nil

							while task.wait(0.5) do
								if _G.AutoPvP then
									local PlayerGui2 = game.Players.LocalPlayer.PlayerGui

									if PlayerGui2 and PlayerGui2.Main then
										if PlayerGui2.Main:FindFirstChild("PvpDisabled") and PlayerGui2.Main.PvpDisabled.Visible then
											exitTo = 1

											break
										end
									end
								end
							end
						until exitTo ~= 1

						return
					end
				end
			end
		end
	end)
end

GRP_Combat_Quests_Players:AddToggle("Auto_Safe_Mode", {
	Text = "Auto Safe Mode",
	Default = false,
	Callback = function(p327)
		_G.SafeMode = p327
	end
})
spawn(function()
	while task.wait(0.1) do
		if _G.SafeMode then
			local Character = game.Players.LocalPlayer.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				_tp(HumanoidRootPart.CFrame * CFrame.new(0, 1000, 0))
			end
		end
	end
end)
GRP_Combat_LocalPlayer_Settings = t15.Combat:AddLeftGroupbox("LocalPlayer Settings")

do
	local Players2 = game:GetService("Players")

	game:GetService("UserInputService")

	local RunService = game:GetService("RunService")
	local LocalPlayer3 = Players2.LocalPlayer
	local u1372 = false
	local n8 = 50
	local connection
	local t50 = {
		f = 0,
		b = 0,
		l = 0,
		r = 0
	}
	local BodyGyro
	local BodyVelocity

	local function v1378()
		local function v1379()
			local Character = LocalPlayer3.Character

			if not Character then
				return
			end

			local Humanoid = Character:FindFirstChildOfClass("Humanoid")

			if not Humanoid then
				return
			end

			local MoveDirection = Humanoid.MoveDirection

			t50.f = 0
			t50.b = 0
			t50.l = 0
			t50.r = 0

			if MoveDirection.Z < -0.1 then
				t50.f = 1
			elseif MoveDirection.Z > 0.1 then
				t50.b = 1
			end

			if MoveDirection.X < -0.1 then
				t50.l = 1
			elseif MoveDirection.X > 0.1 then
				t50.r = 1
			end
		end

		local connection2

		connection2 = RunService.Heartbeat:Connect(function()
			if u1372 then
				v1379()
			elseif connection2 then
				connection2:Disconnect()
			end
		end)
	end
	local function v1384(p328)
		u1372 = p328

		if u1372 then
			if not LocalPlayer3.Character then
				return
			end

			local Humanoid = LocalPlayer3.Character:FindFirstChildOfClass("Humanoid")
			local Torso

			if LocalPlayer3.Character:FindFirstChild("Torso") then
				Torso = LocalPlayer3.Character.Torso
			else
				Torso = LocalPlayer3.Character.UpperTorso
			end

			if not Humanoid or not Torso then
				return
			end

			for _, descendant in ipairs(LocalPlayer3.Character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
					descendant.Massless = true
				end
			end

			LocalPlayer3.Character.DescendantAdded:Connect(function(descendant)
				if u1372 and descendant:IsA("BasePart") then
					descendant.CanCollide = false
					descendant.Massless = true
				end
			end)
			BodyGyro = Instance.new("BodyGyro", Torso)
			BodyGyro.P = 90000
			BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			BodyGyro.cframe = Torso.CFrame
			BodyVelocity = Instance.new("BodyVelocity", Torso)
			BodyVelocity.velocity = Vector3.new(0, 0, 0)
			BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
			Humanoid.PlatformStand = true
			v1378()
			connection = RunService.Heartbeat:Connect(function()
				if not u1372 or not LocalPlayer3.Character then
					return
				end

				for _, descendant in ipairs(LocalPlayer3.Character:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.CanCollide then
						descendant.CanCollide = false
					end
				end

				if t50.l + t50.r == 0 and t50.f + t50.b == 0 then
					BodyVelocity.velocity = Vector3.new(0, 0, 0)
				else
					BodyVelocity.velocity = (workspace.CurrentCamera.CoordinateFrame.lookVector * (t50.f + t50.b) + (workspace.CurrentCamera.CoordinateFrame * CFrame.new(t50.l + t50.r, (t50.f + t50.b) * 0.2, 0).p - workspace.CurrentCamera.CoordinateFrame.p)) * n8
				end

				BodyGyro.cframe = workspace.CurrentCamera.CoordinateFrame
			end)
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end

			if LocalPlayer3.Character then
				local Humanoid = LocalPlayer3.Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					Humanoid.PlatformStand = false
				end

				for _, descendant in ipairs(LocalPlayer3.Character:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = true
						descendant.Massless = false
					end
				end

				if BodyGyro then
					BodyGyro:Destroy()
				end

				if BodyVelocity then
					BodyVelocity:Destroy()
				end
			end

			t50 = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
		end
	end
	local function v1394(p329)
		n8 = p329
	end

	GRP_Combat_LocalPlayer_Settings:AddToggle("Enable_Fly", {
		Text = "Enable Fly",
		Default = false,
		Callback = function(p330)
			v1384(p330)
		end
	})
	GRP_Combat_LocalPlayer_Settings:AddSlider({
		Text = "Speed Fly Mode",
		Min = 10,
		Max = 200,
		Default = 50,
		Rounding = 0,
		Callback = function(p331)
			v1394(p331)
		end
	})
end

do
	GRP_Combat_LocalPlayer_Settings:AddToggle("Dash_No_Cooldown", {
		Text = "Dash No Cooldown",
		Default = false,
		Callback = function(p332)
			getgenv().DodgeNoCD = p332
		end
	})
end

local function v1395()
	local Dodge = game.Players.LocalPlayer.Character:WaitForChild("Dodge")
	local v1397, v1398 = getgc()

	for _, v1 in next, v1397, v1398 do
		if typeof(v1) == "function" and getfenv(v1).script == Dodge then
			local next_ = next
			local v1402, v1403 = getupvalues(v1)

			for k, v2 in next_, v1402, v1403 do
				if tostring(v2) == "0.4" then
					setupvalue(v1, k, 0)
				end
			end
		end
	end
end

GRP_Combat_LocalPlayer_Settings:AddToggle("Instance_Mink_V3_[_INF_]", {
	Text = "Instance Mink V3 [ INF ]",
	Default = false,
	Callback = function(p333)
		InfAblities = p333
	end
})
spawn(function()
	while wait(0.2) do
		pcall(function()
			if not InfAblities then
				LocalPlayer2.Character.HumanoidRootPart.Agility:Destroy()
			elseif not LocalPlayer2.Character.HumanoidRootPart:FindFirstChild("Agility") then
				local clone = ReplicatedStorage2.FX.Agility:Clone()

				clone.Name = "Agility"
				clone.Parent = LocalPlayer2.Character.HumanoidRootPart
			end
		end)
	end
end)
GRP_Combat_LocalPlayer_Settings:AddToggle("Instance_Energy_[_INF_]", {
	Text = "Instance Energy [ INF ]",
	Default = false,
	Callback = function(p334)
		infEnergy = p334

		if p334 then
			getInfinity_Ability("Energy", infEnergy)
		end
	end
})
GRP_Combat_LocalPlayer_Settings:AddToggle("Instance_Soru_[_INF_]", {
	Text = "Instance Soru [ INF ]",
	Default = false,
	Callback = function(p335)
		_G.InfSoru = p335

		if p335 then
			getInfinity_Ability("Soru", _G.InfSoru)
		end
	end
})
GRP_Combat_LocalPlayer_Settings:AddToggle("Instance_Observation_Range_[_INF_]", {
	Text = "Instance Observation Range [ INF ]",
	Default = false,
	Callback = function(p336)
		_G.InfiniteObRange = p336

		if p336 then
			getInfinity_Ability("Observation", _G.InfiniteObRange)
		end
	end
})
GRP_Combat_LocalPlayer_Settings:AddToggle("Ignore_Same_Teams", {
	Text = "Ignore Same Teams",
	Default = false,
	Callback = function(p337)
		_G.NoAimTeam = p337
	end
})
GRP_Combat_LocalPlayer_Settings:AddToggle("Accept_Allies", {
	Text = "Accept Allies",
	Default = false,
	Callback = function(p338)
		_G.AcceptAlly = p338
	end
})
spawn(function()
	while wait(Sec) do
		if _G.AcceptAlly then
			pcall(function()
				for _, child in pairs(ply:GetChildren()) do
					if child.Name ~= LocalPlayer2.Name and child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") then
						ReplicatedStorage2:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("AcceptAlly", child.Name)
					end
				end
			end)
		end
	end
end)
GRP_Travel_Travel_Worlds = t15.Travel:AddLeftGroupbox("Travel - Worlds")
GRP_Travel_Travel_Worlds:AddButton({
	Text = "Travel East Blue (World 1)",
	Func = function()
	end
})
GRP_Travel_Travel_Worlds:AddButton({
	Text = "Travel Dressrosa (World 2)",
	Func = function()
	end
})

do
	GRP_Travel_Travel_Worlds:AddButton({
		Text = "Travel Zou (World 3)",
		Func = function()
		end
	})
end

GRP_Travel_Travel_Island = t15.Travel:AddLeftGroupbox("Travel - Island")
Location = {}

for _, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
	table.insert(Location, child.Name)
end

Travelllll = GRP_Travel_Travel_Island:AddDropdown("Select_Travelling", {
	Text = "Select Travelling",
	Values = Location,
	Default = 1,
	Callback = function(p339)
		_G.Island = p339
	end
})

do
	GoIsland = GRP_Travel_Travel_Island:AddToggle("Auto_Travel", {
		Text = "Auto Travel",
		Default = false,
		Callback = function(p340)
			_G.Teleport = p340

			if p340 then
				for _, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
					if child.Name == _G.Island then
						while true do
							wait()
							_tp(child.CFrame * CFrame.new(0, 30, 0))

							if not _G.Teleport then
								break
							elseif Root.CFrame == child.CFrame then
								break
							end
						end
					end
				end
			end
		end
	})
end

GRP_Travel_Travel_Portal = t15.Travel:AddLeftGroupbox("Travel - Portal")

if World1 then
	Location_Portal = {
		"Sky",
		"UnderWater"
	}
elseif World2 then
	Location_Portal = {
		"SwanRoom",
		"Cursed Ship"
	}
elseif World3 then
	Location_Portal = {
		"Castle On The Sea",
		"Mansion Cafe",
		"Hydra Teleport",
		"Canvendish Room",
		"Temple of Time"
	}
end

PortalTP = GRP_Travel_Travel_Portal:AddDropdown("Select_Portal", {
	Text = "Select Portal",
	Values = Location_Portal,
	Default = 1,
	Callback = function(p341)
		_G.Island_PT = p341
	end
})
GRP_Travel_Travel_Portal:AddButton({
	Text = "requestEntrance",
	Func = function()
	end
})
GRP_Travel_Travel_NPCs = t15.Travel:AddLeftGroupbox("Travel - NPCs")

for _, child in pairs(ReplicatedStorage2.NPCs:GetChildren()) do
	table.insert(NPCList, child.Name)
end

do
	NPCsPos = GRP_Travel_Travel_NPCs:AddDropdown("Select_NPCs", {
		Text = "Select NPCs",
		Values = NPCList,
		Default = 1,
		Callback = function(p342)
			_G.TPNpc = p342
		end
	})
end

GoNPCs = GRP_Travel_Travel_NPCs:AddToggle("Auto_Tween_to_NPC", {
	Text = "Auto Tween to NPC",
	Default = false,
	Callback = function(p343)
		_G.TPNpc = p343
	end
})
spawn(function()
	while wait(Sec) do
		if _G.TPNpc then
			pcall(function()
				for _, child in pairs(ReplicatedStorage2.NPCs:GetChildren()) do
					if child.Name == NPClist then
						_tp(child.HumanoidRootPart.CFrame)
					end
				end
			end)
		end
	end
end)
GRP_Shop_Shop_Options = t15.Shop:AddLeftGroupbox("Shop Options")

do
	GRP_Shop_Shop_Options:AddButton({
		Text = "Buy Buso",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
		end
	})
end

GRP_Shop_Shop_Options:AddButton({
	Text = "Buy Geppo",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
	end
})
GRP_Shop_Shop_Options:AddButton({
	Text = "Buy Soru",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyHaki", "Soru")
	end
})

do
	GRP_Shop_Shop_Options:AddButton({
		Text = "Buy Ken",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("KenTalk", "Buy")
		end
	})
end

GRP_Shop_Fighting_Style = t15.Shop:AddLeftGroupbox("Fighting - Style")
GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy Black Leg",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyBlackLeg")
	end
})
GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy Electro",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyElectro")
	end
})
GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy Fishman Karate",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
	end
})

do
	GRP_Shop_Fighting_Style:AddButton({
		Text = "Buy DragonClaw",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
		end
	})
end

GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy Superhuman",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuySuperhuman")
	end
})
GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy Death Step",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyDeathStep")
	end
})
GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy Sharkman Karate",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
	end
})

do
	GRP_Shop_Fighting_Style:AddButton({
		Text = "Buy ElectricClaw",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyElectricClaw")
		end
	})
end

GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy DragonTalon",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyDragonTalon")
	end
})
GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy Godhuman",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyGodhuman")
	end
})
GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy SanguineArt",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuySanguineArt")
	end
})
GRP_Shop_Accessory = t15.Shop:AddLeftGroupbox("Accessory")

do
	GRP_Shop_Accessory:AddButton({
		Text = "Buy Tomoe Ring",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Tomoe Ring")
		end
	})
end

GRP_Shop_Accessory:AddButton({
	Text = "Buy Black Cape",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Black Cape")
	end
})
GRP_Shop_Accessory:AddButton({
	Text = "Buy Swordsman Hat",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Swordsman Hat")
	end
})
GRP_Shop_Accessory:AddButton({
	Text = "Buy Bizarre Rifle",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 1)
	end
})
GRP_Shop_Accessory:AddButton({
	Text = "Buy Ghoul Mask",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 2)
	end
})
GRP_Shop_Weapon_World1 = t15.Shop:AddLeftGroupbox("Weapon World1")
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Cutlass",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Cutlass")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Katana",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Katana")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Iron Mace",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Duel Katana",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Duel Katana")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Triple Katana",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Pipe",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Pipe")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Dual-Headed Blade",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Dual-Headed Blade")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Bisento",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Soul Cane",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Soul Cane")
	end
})

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Slingshot",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Slingshot")
		end
	})
end

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Musket",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Musket")
		end
	})
end

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Dual Flintlock",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Dual Flintlock")
		end
	})
end

GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Flintlock",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Flintlock")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Refined Flintlock",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Refined Flintlock")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Cannon",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Cannon")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Kabucha",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2")
	end
})
GRP_Shop_Fragments_shop = t15.Shop:AddLeftGroupbox("Fragments shop")
GRP_Shop_Fragments_shop:AddButton({
	Text = "Buy Refund Stats",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "2")
	end
})
GRP_Shop_Fragments_shop:AddButton({
	Text = "Buy Reroll Race",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
	end
})
GRP_Shop_Fragments_shop:AddButton({
	Text = "Buy Ghoul Race",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("Ectoplasm", " Change", 4)
	end
})

do
	GRP_Shop_Fragments_shop:AddButton({
		Text = "Buy Cyborg Race (2.5k)",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("CyborgTrainer", " Buy")
		end
	})
end

GRP_Shop_Fragments_shop:AddButton({
	Text = "Buy Draco Race",
	Func = function()
		task.spawn(function()
			_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))

			local vector3 = Vector3.new(5814.42724609375, 1208.3267822265625, 884.57855224609375)

			while true do
				task.wait()

				if not LocalPlayer2.Character then
					continue
				end

				if LocalPlayer2.Character.HumanoidRootPart and (LocalPlayer2.Character.HumanoidRootPart.Position - vector3).Magnitude < 1 then
					break
				end
			end

			ReplicatedStorage2.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
				NPC = "Dragon Wizard",
				Command = "DragonRace"
			} }))
		end)
	end
})
GRP_Misc_Server_Function = t15.Misc:AddLeftGroupbox("Server - Function")

do
	GRP_Misc_Server_Function:AddButton({
		Text = "Redeem All Codes",
		Func = function()
			local t51 = {
				"LIGHTNINGABUSE",
				"1LOSTADMIN",
				"ADMINFIGHT",
				"GIFTING_HOURS",
				"NOMOREHACK",
				"BANEXPLOIT",
				"WildDares",
				"BossBuild",
				"GetPranked",
				"EARN_FRUITS",
				"SUB2GAMERROBOT_RESET1",
				"KITT_RESET",
				"Bignews",
				"CHANDLER",
				"Fudd10",
				"fudd10_v2",
				"Sub2UncleKizaru",
				"FIGHT4FRUIT",
				"kittgaming",
				"TRIPLEABUSE",
				"Sub2CaptainMaui",
				"Sub2Fer999",
				"Enyu_is_Pro",
				"Magicbus",
				"JCWK",
				"Starcodeheo",
				"Bluxxy",
				"SUB2GAMERROBOT_EXP1",
				"Sub2NoobMaster123",
				"Sub2Daigrock",
				"Axiore",
				"TantaiGaming",
				"StrawHatMaine",
				"Sub2OfficialNoobie",
				"TheGreatAce",
				"JULYUPDATE_RESET",
				"ADMINHACKED",
				"SEATROLLING",
				"24NOADMIN",
				"ADMIN_TROLL",
				"NEWTROLL",
				"SECRET_ADMIN",
				"staffbattle",
				"NOEXPLOIT",
				"NOOB2ADMIN",
				"CODESLIDE",
				"fruitconcepts",
				"krazydares"
			}
			local Redeem = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):FindFirstChild("Redeem")

			if not Redeem then
				return
			end

			for _, v1 in ipairs(t51) do
				task.wait(0)
				pcall(function()
					if Redeem.InvokeServer then
						Redeem:InvokeServer(v1)
					else
						Redeem:FireServer(v1)
					end
				end)
			end
		end
	})
end

GRP_Misc_Server_Function:AddButton({
	Text = "Rejoin Server",
	Func = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
	end
})
GRP_Misc_Server_Function:AddButton({
	Text = "Hop Server",
	Func = function()
		task.spawn(function()
			local HttpService = game:GetService("HttpService")
			local TeleportService_ = game:GetService("TeleportService")
			local Players2 = game:GetService("Players")
			local ok, result = pcall(function()
				local response = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")

				return HttpService:JSONDecode(response).data
			end)

			if ok and result then
				local id

				for _, v1 in pairs(result) do
					if v1.playing < v1.maxPlayers then
						id = v1.id
					end
				end

				if id then
					pcall(function()
						TeleportService_:TeleportToPlaceInstance(game.PlaceId, id, Players2.LocalPlayer)
					end)
				end
			end
		end)
	end
})

do
	GRP_Misc_Server_Function:AddButton({
		Text = "Hop to Lowest Players",
		Func = function()
			local HttpService = game:GetService("HttpService")
			local TeleportService_ = game:GetService("TeleportService")
			local v1433 = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

			local function v1434(p344)
				local response = game:HttpGet(v1433 .. (p344 and "&cursor=" .. p344 or ""))

				return HttpService:JSONDecode(response)
			end

			local nextPageCursor
			local v1437

			repeat
				local v1438 = v1434(nextPageCursor)

				v1437 = v1438.data[1]
				nextPageCursor = v1438.nextPageCursor
			until v1437

			TeleportService_:TeleportToPlaceInstance(game.PlaceId, v1437.id, LocalPlayer2)
		end
	})
end

local ReplicatedStorage3 = game:GetService("ReplicatedStorage")

GRP_Misc_Server_Function:AddButton({
	Text = "Hop to Lowest Pings Server",
	Func = function()
		local HttpService = game:GetService("HttpService")
		local TeleportService_ = game:GetService("TeleportService")
		local Stats_ = game:GetService("Stats")

		local function v1443(p345, p346)
			local v1444 = string.format("https://games.roblox.com/v1/games/%d/servers/Public?limit=%d", p345, p346)
			local ok, result = pcall(function()
				return HttpService:JSONDecode(game:HttpGet(v1444))
			end)

			if not ok or not result or not result.data then
				return nil
			end

			return result.data
		end

		local v1447 = v1443(game.PlaceId, 100)

		if not v1447 then
			return
		end

		local v1448 = v1447[1]

		for _, v1 in pairs(v1447) do
			if v1.ping < v1448.ping and v1.playing < v1.maxPlayers then
				v1448 = v1
			end
		end

		if tonumber(Stats_.Network.ServerStatsItem["Data Ping"]:GetValueString():match("(%d+)")) >= 100 then
			TeleportService_:TeleportToPlaceInstance(game.PlaceId, v1448.id)
		end
	end
})
GRP_Misc_Server_Function:AddInput("Input_Job_Id", {
	Text = "Input Job Id",
	Default = "",
	Placeholder = "Job ID",
	Callback = function(p347)
		_G.Rechat = p347
	end
})

do
	GRP_Misc_Server_Function:AddButton({
		Text = "Teleport [Job ID]",
		Func = function()
			if _G.Rechat and _G.Rechat ~= "" then
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _G.Rechat, LocalPlayer2)
			end
		end
	})
end

GRP_Misc_Server_Function:AddButton({
	Text = "Copy JobID",
	Func = function()
		setclipboard(tostring(game.JobId))
	end
})
GRP_Misc_Player_Gui_Others = t15.Misc:AddLeftGroupbox("Player Gui / Others")

do
	GRP_Misc_Player_Gui_Others:AddButton({
		Text = "Open Awakenings Expert",
		Func = function()
			LocalPlayer2.PlayerGui.Main.AwakeningToggler.Visible = true
		end
	})
end

GRP_Misc_Player_Gui_Others:AddButton({
	Text = "Open Title Selection",
	Func = function()
		ReplicatedStorage3.Remotes.CommF_:InvokeServer("getTitles", true)
		LocalPlayer2.PlayerGui.Main.Titles.Visible = true
	end
})
DisbleChat = GRP_Misc_Player_Gui_Others:AddToggle("Disable_Chat_GUI", {
	Text = "Disable Chat GUI",
	Default = false,
	Callback = function(p348)
		_G.Rechat = p348

		if _G.Rechat == true then
			game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
		elseif _G.Rechat == false then
			game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
		end
	end
})
DisbleLeaderB = GRP_Misc_Player_Gui_Others:AddToggle("Disable_Leader_Board_GUI", {
	Text = "Disable Leader Board GUI",
	Default = false,
	Callback = function(p349)
		ReLeader = p349

		if ReLeader == true then
			game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		elseif ReLeader == false then
			game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
		end
	end
})

do
	GRP_Misc_Player_Gui_Others:AddButton({
		Text = "Set Pirate Team",
		Func = function()
			ReplicatedStorage3.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
		end
	})
end

GRP_Misc_Player_Gui_Others:AddButton({
	Text = "Set Marine Team",
	Func = function()
		ReplicatedStorage3.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
	end
})
UnPortal = GRP_Misc_Player_Gui_Others:AddToggle("Unlock_All_Portals", {
	Text = "Unlock All Portals",
	Default = false,
	Callback = function(p350)
		_G.PortalUnLock = p350
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.PortalUnLock then
				if t9.Pos(CstlePos_Miti, 8) then
					ReplicatedStorage3.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
				elseif t9.Pos(Man3Pos_Miti, 8) then
					ReplicatedStorage3.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5072.08984375, 314.5412902832, -3151.1098632812))
				elseif t9.Pos(HydraPos_Miti, 8) then
					ReplicatedStorage3.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5748.7587890625, 610.44982910156, -267.81704711914))
				elseif t9.Pos(HydratoCastle, 8) then
					ReplicatedStorage3.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5072.08984375, 314.5412902832, -3151.1098632812))
				end
			end
		end)
	end
end)
GRP_Misc_Graphics_Haki_Stats = t15.Misc:AddLeftGroupbox("Graphics / Haki Stats")
HakiSt = {
	"State 0",
	"State 1",
	"State 2",
	"State 3",
	"State 4",
	"State 5"
}
HakiStat = GRP_Misc_Graphics_Haki_Stats:AddDropdown("Select_Haki_States", {
	Text = "Select Haki States",
	Values = HakiSt,
	Default = 1,
	Callback = function(p351)
		_G.SelectStateHaki = p351
	end
})
GRP_Misc_Graphics_Haki_Stats:AddButton({
	Text = "ChangeBusoStage",
	Func = function()
		if _G.SelectStateHaki == "State 0" then
			ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 0)
		elseif _G.SelectStateHaki == "State 1" then
			ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 1)
		elseif _G.SelectStateHaki == "State 2" then
			ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 2)
		elseif _G.SelectStateHaki == "State 3" then
			ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 3)
		elseif _G.SelectStateHaki == "State 4" then
			ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 4)
		elseif _G.SelectStateHaki == "State 5" then
			ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 5)
		end
	end
})

do
	rtxM = GRP_Misc_Graphics_Haki_Stats:AddToggle("Turn_on_RTX_Mode", {
		Text = "Turn on RTX Mode",
		Default = false,
		Callback = function(p352)
			_G.RTXMode = p352

			for _, child in pairs(game.Lighting:GetChildren()) do
				if child.Name == "RTXColorCorrection" or child.Name == "RTXTint" then
					child:Destroy()
				end
			end

			if _G.RTXMode then
				local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect", game.Lighting)

				ColorCorrectionEffect.Name = "RTXColorCorrection"

				local ColorCorrectionEffect2 = Instance.new("ColorCorrectionEffect", game.Lighting)

				ColorCorrectionEffect2.Name = "RTXTint"
				OldAmbient = game.Lighting.Ambient
				OldBrightness = game.Lighting.Brightness
				OldColorShift_Top = game.Lighting.ColorShift_Top
				OldBrightnessc = ColorCorrectionEffect.Brightness
				OldContrastc = ColorCorrectionEffect.Contrast
				OldTintColorc = ColorCorrectionEffect.TintColor
				OldTintColore = ColorCorrectionEffect2.TintColor
				ColorCorrectionEffect.Brightness = 0.176
				ColorCorrectionEffect.Contrast = 0.39
				ColorCorrectionEffect.TintColor = Color3.fromRGB(217, 145, 57)
				ColorCorrectionEffect2.TintColor = Color3.fromRGB(217, 145, 57)
				game.Lighting.FogEnd = 999
				spawn(function()
					while _G.RTXMode do
						wait()
						game.Lighting.Ambient = Color3.fromRGB(33, 33, 33)
						game.Lighting.Brightness = 0.3

						if not _G.RTXMode then
							break
						end

						if LocalPlayer2.Character then
							if LocalPlayer2.Character:FindFirstChild("HumanoidRootPart") then
								if not LocalPlayer2.Character.HumanoidRootPart:FindFirstChild("RTXPointLight") then
									local PointLight = Instance.new("PointLight")

									PointLight.Name = "RTXPointLight"
									PointLight.Parent = LocalPlayer2.Character.HumanoidRootPart
									PointLight.Range = 15
									PointLight.Color = Color3.fromRGB(217, 145, 57)
								end
							end
						end
					end
				end)
			else
				pcall(function()
					if OldAmbient then
						game.Lighting.Ambient = OldAmbient
					end

					if OldBrightness then
						game.Lighting.Brightness = OldBrightness
					end

					if OldColorShift_Top then
						game.Lighting.ColorShift_Top = OldColorShift_Top
					end

					game.Lighting.FogEnd = 2500
				end)

				for _, child in pairs(game.Lighting:GetChildren()) do
					if child.Name == "RTXColorCorrection" or child.Name == "RTXTint" then
						child:Destroy()
					end
				end

				if LocalPlayer2.Character then
					if LocalPlayer2.Character:FindFirstChild("HumanoidRootPart") then
						local RTXPointLight = LocalPlayer2.Character.HumanoidRootPart:FindFirstChild("RTXPointLight")

						if RTXPointLight then
							RTXPointLight:Destroy()
						end
					end
				end
			end
		end
	})
end

GRP_Misc_Graphics_Haki_Stats:AddButton({
	Text = "Turn on Fast Mode",
	Func = function()
		local descendants, v1460 = workspace:GetDescendants()

		for _, v1 in next, descendants, v1460 do
			if table.find(t2, v1.ClassName) then
				v1.Material = "Plastic"
			end
		end
	end
})
GRP_Misc_Graphics_Haki_Stats:AddButton({
	Text = "Turn on Low CPU",
	Func = function()
		LowCpu()
	end
})

do
	GRP_Misc_Graphics_Haki_Stats:AddButton({
		Text = "Turn on increase Boats",
		Func = function()
			for _, child in pairs(workspace.Boats:GetChildren()) do
				if tostring(child.Owner.Value) == tostring(LocalPlayer2.Name) then
					for _, descendant in pairs(child:GetDescendants()) do
						if descendant:IsA("VehicleSeat") then
							descendant.MaxSpeed = 350
							descendant.Torque = 0.2
							descendant.TurnSpeed = 5
							descendant.HeadsUpDisplay = true
						end
					end
				end
			end
		end
	})
end

GRP_Misc_Graphics_Haki_Stats:AddButton({
	Text = "Remove Sky Fog",
	Func = function()
		for _, child in pairs(game.Lighting:GetChildren()) do
			if child.Name == "Sky" or child.Name == "LightingLayers" or child.Name == "SeaTerrorCC" or child.Name == "FantasySky" then
				child:Destroy()
			end
		end
	end
})
GRP_Misc_Configure_God = t15.Misc:AddLeftGroupbox("Configure - God")

do
	GRP_Misc_Configure_God:AddButton({
		Text = "Rain Fruits (Client)",
		Func = function()
			if ReplicatedStorage3:FindFirstChild("Assets") then
				if ReplicatedStorage3.Assets:FindFirstChild("Models") then
					local children = ReplicatedStorage3.Assets.Models:GetChildren()

					for _, child in pairs(children) do
						if child:IsA("Model") and child.Name ~= "IceSpikes4" then
							local clone = child:Clone()

							clone.Parent = workspace

							if clone:FindFirstChild("Float") then
								clone.Float:Destroy()
							end

							clone:SetPrimaryPartCFrame(CFrame.new(LocalPlayer2.Character.HumanoidRootPart.Position + Vector3.new(math.random(-50, 50), 100, math.random(-50, 50))))
						end
					end
				end
			end
		end
	})
end

briggt1 = GRP_Misc_Configure_God:AddToggle("Turn_on_Full_Bright", {
	Text = "Turn on Full Bright",
	Default = false,
	Callback = function(p353)
		_G.SelectDN = p353
	end
})

do
	DayN = GRP_Misc_Configure_God:AddDropdown("Select_Time", {
		Text = "Select Time",
		Values = {
			"Day",
			"Night"
		},
		Default = 1,
		Callback = function(p354)
			_G.SelectDN = p354
		end
	})
end

dayornight = GRP_Misc_Configure_God:AddToggle("Turn_on_Time", {
	Text = "Turn on Time",
	Default = false,
	Callback = function(p355)
		_G.daylightN = p355
	end
})
task.spawn(function()
	while task.wait() do
		if _G.daylightN then
			if _G.SelectDN == "Day" then
				Lighting.ClockTime = 12
			elseif _G.SelectDN == "Night" then
				Lighting.ClockTime = 0
			end
		end
	end
end)

do
	walkWater = GRP_Misc_Configure_God:AddToggle("Turn_on_Walk_on_Water", {
		Text = "Turn on Walk on Water",
		Default = true,
		Callback = function(p356)
			_G.WalkWater_Part = p356

			if _G.WalkWater_Part then
				game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
			else
				game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
			end
		end
	})
end

iceWalk = GRP_Misc_Configure_God:AddToggle("Turn_on_Ice_Walk", {
	Text = "Turn on Ice Walk",
	Default = false,
	Callback = function(p357)
		_G.WalkWater = p357
	end
})
spawn(function()
	while task.wait() do
		if _G.WalkWater then
			pcall(function()
				if LocalPlayer2.Character then
					if LocalPlayer2.Character:FindFirstChild("LeftFoot") then
						local clone = ReplicatedStorage3.Assets.Models.IceSpikes4:Clone()

						clone.Parent = workspace
						clone.Size = Vector3.new(3 + math.random(10, 12), 1.7, 3 + math.random(10, 12))
						clone.Color = Color3.fromRGB(128, 187, 219)
						clone.CFrame = CFrame.new(LocalPlayer2.Character.Head.Position.X, -3.8, LocalPlayer2.Character.Head.Position.Z) * CFrame.Angles((math.random() - 0.5) * 0.06, math.random() * 7, (math.random() - 0.5) * 0.07)

						local t52 = {
							Size = Vector3.new(0, 0.3, 0)
						}
						local tween = TW:Create(clone, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), t52)

						tween.Completed:Connect(function()
							clone:Destroy()
						end)
						tween:Play()
					end
				end
			end)
		end
	end
end)

do
	local LocalPlayer3 = game.Players.LocalPlayer

	local function v1477(p358)
		if not p358 then
			return false
		end

		local Humanoid = p358:FindFirstChild("Humanoid")

		return Humanoid and Humanoid.Health > 0
	end
	local function v1479(p359, p360)
		local children = game:GetService("Workspace").Enemies:GetChildren()
		local players = game:GetService("Players"):GetPlayers()
		local t53 = {}
		local Position = p359:GetPivot().Position

		for _, child in ipairs(children) do
			local HumanoidRootPart = child:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart and v1477(child) and (HumanoidRootPart.Position - Position).Magnitude <= p360 then
				table.insert(t53, child)
			end
		end

		for _, player in ipairs(players) do
			if player ~= LocalPlayer3 and player.Character then
				local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart and v1477(player.Character) and (HumanoidRootPart.Position - Position).Magnitude <= p360 then
					table.insert(t53, player.Character)
				end
			end
		end

		return t53
	end

	AttackNoCoolDown = function()
		local LocalPlayer4 = game:GetService("Players").LocalPlayer
		local Character = LocalPlayer4.Character

		if not Character then
			return
		end

		local v1492
		local v1493, v1494, v1495 = ipairs(Character:GetChildren())
		local v1496 = geniter(v1493, v1494, v1495)

		while true do
			local v1497 = table.pack(v1496())

			if v1497[1] then
				local v1498 = v1497[3]

				if v1498:IsA("Tool") then
					v1492 = v1498

					break
				end
			else
				break
			end
		end

		if not v1492 then
			return
		end

		local v1499 = v1479(Character, 60)

		if #v1499 == 0 then
			return
		end

		local ReplicatedStorage4 = game:GetService("ReplicatedStorage")
		local Modules = ReplicatedStorage4:FindFirstChild("Modules")

		if not Modules then
			return
		end

		local RERegisterAttack = ReplicatedStorage4:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")
		local RERegisterHit = ReplicatedStorage4:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit")

		if not RERegisterAttack or not RERegisterHit then
			return
		end

		local t54 = {}
		local v1505
		local v1506, v1507, v1508 = ipairs(v1499)

		for _, v1 in v1506, v1507, v1508 do
			if not v1:GetAttribute("IsBoat") then
				local t55 = {
					"RightLowerArm",
					"RightUpperArm",
					"LeftLowerArm",
					"LeftUpperArm",
					"RightHand",
					"LeftHand"
				}
				local PrimaryPart = v1:FindFirstChild(t55[math.random(#t55)]) or v1.PrimaryPart

				if PrimaryPart then
					table.insert(t54, {
						v1,
						PrimaryPart
					})
					v1505 = PrimaryPart
				end
			end
		end

		if not v1505 then
			return
		end

		RERegisterAttack:FireServer(0)

		local PlayerScripts = LocalPlayer4:FindFirstChild("PlayerScripts")

		if not PlayerScripts then
			return
		end

		local LocalScript = PlayerScripts:FindFirstChildOfClass("LocalScript")

		while not LocalScript do
			PlayerScripts.ChildAdded:Wait()
			LocalScript = PlayerScripts:FindFirstChildOfClass("LocalScript")
		end

		local SendHitsToServer

		if getsenv then
			local ok, result = pcall(getsenv, LocalScript)

			if ok and result then
				SendHitsToServer = result._G.SendHitsToServer
			end
		end

		local ok, result = pcall(function()
			return require(Modules.Flags).COMBAT_REMOTE_THREAD or false
		end)

		if ok and result and SendHitsToServer then
			SendHitsToServer(v1505, t54)
		elseif ok and not result then
			RERegisterHit:FireServer(v1505, t54)
		end
	end
end

CameraShakerR = require(game.ReplicatedStorage.Util.CameraShaker)
CameraShakerR:Stop()

do
	get_Monster = function()
		for _, child in pairs(workspace.Enemies:GetChildren()) do
			local UpperTorso = child:FindFirstChild("UpperTorso") or child:FindFirstChild("Head")

			if child:FindFirstChild("HumanoidRootPart", true) and UpperTorso and (child.Head.Position - LocalPlayer2.Character.HumanoidRootPart.Position).Magnitude <= 50 then
				return true, UpperTorso.Position
			end
		end

		for _, child in pairs(workspace.SeaBeasts:GetChildren()) do
			if child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Health") and child.Health.Value > 0 then
				return true, child.HumanoidRootPart.Position
			end
		end

		for _, child in pairs(workspace.Enemies:GetChildren()) do
			if child:FindFirstChild("Health") and child.Health.Value > 0 and child:FindFirstChild("VehicleSeat") then
				return true, child.Engine.Position
			end
		end
	end
end

Actived = function()
	local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
	local v1528, v1529 = getconnections(Tool.Activated)

	for _, v1 in next, v1528, v1529 do
		if typeof(v1.Function) == "function" then
			getupvalues(v1.Function)
		end
	end
end

do
	task.spawn(function()
		RunSer.Heartbeat:Connect(function()
			pcall(function()
				if not _G.Seriality then
					return
				end

				AttackNoCoolDown()

				local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
				local ToolTip = Tool.ToolTip
				local v1534 = get_Monster()

				if ToolTip == "Blox Fruit" then
					if v1534 then
						local LeftClickRemote = Tool:FindFirstChild("LeftClickRemote")

						if LeftClickRemote then
							Actived()
							LeftClickRemote:FireServer(Vector3.new(0.01, -500, 0.01), 1, true)
							LeftClickRemote:FireServer(false)
						end
					end
				end
			end)
		end)
	end)
end

local t56 = {}
local t57 = {}

do
	local Players2 = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local ReplicatedStorage4 = game:GetService("ReplicatedStorage")
	local Workspace = game:GetService("Workspace")
	local LocalPlayer3 = Players2.LocalPlayer

	if not LocalPlayer3.Character then
		LocalPlayer3.CharacterAdded:Wait()
	end

	local function v1544(p361, p362)
		local _, result = pcall(function()
			return p361:WaitForChild(p362)
		end)

		return result
	end

	local enemies = v1544(Workspace, "Enemies")
	local characters = v1544(Workspace, "Characters")
	local modules = v1544(ReplicatedStorage4, "Modules")
	local net = v1544(modules, "Net")

	t56.Rate = 2e-09
	t56.Enabled = true
	t56.IsAlive = function(p363)
		local Humanoid = p363:FindFirstChild("Humanoid")

		if Humanoid and Humanoid.Health > 0 then
			return true
		end

		return false
	end

	local u1552, attribute

	do
		t56.GetNearbyTargets = function(p364, p365)
			local Position = p364:GetPivot().Position
			local t58 = {}
			local children = p365:GetChildren()

			for i = 1, #children do
				local v1558 = children[i]
				local Humanoid = v1558:FindFirstChild("Humanoid")
				local HumanoidRootPart = v1558:FindFirstChild("HumanoidRootPart")

				if Humanoid and HumanoidRootPart and Humanoid.Health > 0 and (HumanoidRootPart.Position - Position).Magnitude <= 60 then
					table.insert(t58, v1558)
				end
			end

			return t58
		end
		t56.GetTargetParts = function(p366)
			local t59 = {}

			for i = 1, #p366 do
				local v1563 = p366[i]
				local Head = v1563:FindFirstChild("Head") or v1563.PrimaryPart

				if Head then
					table.insert(t59, {
						v1563,
						Head
					})
				end
			end

			return t59
		end
		t56.GetAllTargets = function(p367)
			local v1565 = t56.GetNearbyTargets(p367, enemies)
			local v1566 = t56.GetNearbyTargets(p367, characters)
			local t60 = {}

			for i = 1, #v1565 do
				table.insert(t60, v1565[i])
			end

			for i = 1, #v1566 do
				table.insert(t60, v1566[i])
			end

			return t60
		end

		local function executeFastAttack()
			local Character = LocalPlayer3.Character

			if not Character then
				return
			end

			if not Character:FindFirstChildOfClass("Tool") then
				return
			end

			local v1572 = t56.GetAllTargets(Character)

			if #v1572 < 1 then
				return
			end

			local v1573 = t56.GetTargetParts(v1572)

			if #v1573 < 1 then
				return
			end

			local reRegisterHit = net["RE/RegisterHit"]

			net["RE/RegisterAttack"]:FireServer(t56.Rate)
			reRegisterHit:FireServer(v1573[1][2], v1573)
		end

		t56.ExecuteFastAttack = executeFastAttack
		u1552 = nil
		attribute = nil

		local function v1575()
			for _, v1 in ipairs({
				ReplicatedStorage4.Util,
				ReplicatedStorage4.Common,
				ReplicatedStorage4.Remotes,
				ReplicatedStorage4.Assets,
				ReplicatedStorage4.FX
			}) do
				local children = v1:GetChildren()

				for _, child in ipairs(children) do
					if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
						u1552 = child
						attribute = child:GetAttribute("Id")
					end
				end

				v1.ChildAdded:Connect(function(child)
					if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
						u1552 = child
						attribute = child:GetAttribute("Id")
					end
				end)
			end
		end

		v1575()
	end

	t57.Execute = function()
		local Character = LocalPlayer3.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		local t61 = {}

		local function v1584(p368)
			local children = p368:GetChildren()

			for i = 1, #children do
				local v1587 = children[i]
				local Humanoid = v1587:FindFirstChild("Humanoid")
				local HumanoidRootPart2 = v1587:FindFirstChild("HumanoidRootPart")

				if Humanoid and HumanoidRootPart2 and Humanoid.Health > 0 and v1587 ~= Character and (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude <= 60 then
					local children2 = v1587:GetChildren()

					for _, v1 in ipairs(children2) do
						if v1:IsA("BasePart") then
							table.insert(t61, {
								v1587,
								v1
							})
						end
					end
				end
			end
		end

		v1584(enemies)
		v1584(characters)

		local Tool = Character:FindFirstChildOfClass("Tool")

		if #t61 > 0 and Tool and (Tool:GetAttribute("WeaponType") == "Melee" or Tool:GetAttribute("WeaponType") == "Sword") then
			local response = modules.Net.seed:InvokeServer()
			local reRegisterHit = net["RE/RegisterHit"]

			net["RE/RegisterAttack"]:FireServer()

			local Head = t61[1][1]:FindFirstChild("Head")

			if not Head then
				return
			end

			reRegisterHit:FireServer(Head, t61, {})

			if u1552 then
				local v1597 = math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1
				local RegisterHit = string.gsub("RE/RegisterHit", ".", function(p369)
					return string.char(bit32.bxor(string.byte(p369), v1597))
				end)
				local v1599 = bit32.bxor(attribute + 909090, response * 2)

				cloneref(u1552):FireServer(RegisterHit, v1599, Head, t61)
			end
		end
	end

	local function v1600()
		require(ReplicatedStorage4.Util.CameraShaker):Stop()
	end
	local function v1601()
		task.spawn(function()
			while task.wait(t56.Rate) do
				t56.ExecuteFastAttack()
			end
		end)
		RunService.Heartbeat:Connect(function()
			pcall(t57.Execute)
		end)
	end

	v1601()
end

lib:Notify({
	Title = "GB Hub",
	Description = "GB Hub comeback",
	Icon = "rbxassetid://88329907835665",
	Duration = 5
})