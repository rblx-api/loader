local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local function v6(p1)
	if not setclipboard then
		if not syn or not syn.write_clipboard then
			if Clipboard and Clipboard.set then
				Clipboard.set(p1)
			end

			return
		end

		syn.write_clipboard(p1)

		return
	end

	setclipboard(p1)
end
local u9 = nil
local u10 = StarterGui
local u11 = HttpService
local u12 = LocalPlayer
local u13 = Players
local u14 = v6

local function v15()
	u10:SetCore("SendNotification", {
		Title = "PinokioScripts",
		Text = "Working For Mobile and PC Executor",
		Duration = 8,
	})
	u10:SetCore("SendNotification", {
		Title = "Made By:",
		Text = "PinokioScripts Team",
		Icon = "rbxthumb://type=Asset&id=13508183954&w=150&h=150",
		Duration = 8,
	})
	task.spawn(function()
		repeat
			if not task.wait(30) then
				return
			end

			local u229 = false

			pcall(function()
				if readfile and isfile and isfile("PinokioKeySession.json") then
					local v487 = readfile("PinokioKeySession.json")
					local data = u11:JSONDecode(v487)

					if data and data.Key == "ArSinalwPinakEE" and data.Timestamp then
						if os.time() - data.Timestamp < 21600 then
							u229 = true

							return
						end

						pcall(function()
							if delfile and isfile and isfile("PinokioKeySession.json") then
								delfile("PinokioKeySession.json")
							end
						end)
					end
				end
			end)
		until not u229

		pcall(function()
			if delfile and isfile and isfile("PinokioKeySession.json") then
				delfile("PinokioKeySession.json")
			end
		end)
		u10:SetCore("SendNotification", {
			Title = "PinokioScripts",
			Text = "Key session expired (6 hours passed). Re-verify key!",
			Duration = 6,
		})
		task.wait(1)
		u9()
	end)

	local t1 = {
		fly = false,
		flyspeed = 50,
	}
	local Character = nil
	local Humanoid = nil
	local BodyVelocity = nil
	local BodyAngularVelocity = nil
	local Camera = nil
	local u33 = nil
	local LocalPlayer2 = game.Players.LocalPlayer
	local t2 = {
		W = false,
		S = false,
		A = false,
		D = false,
		Moving = false,
	}
	local u36 = LocalPlayer2

	local function u37()
		if u36.Character and u36.Character.Head and not u33 then
			Character = u36.Character
			Humanoid = Character.Humanoid
			Humanoid.PlatformStand = true
			Camera = workspace:WaitForChild("Camera")
			BodyVelocity = Instance.new("BodyVelocity")
			BodyAngularVelocity = Instance.new("BodyAngularVelocity")
			local vector3 = Vector3.new(0, 0, 0)
			local vector3_2 = Vector3.new(10000, 10000, 10000)

			BodyVelocity.Velocity = vector3
			BodyVelocity.MaxForce = vector3_2
			BodyVelocity.P = 1000
			local vector3_3 = Vector3.new(0, 0, 0)
			local vector3_4 = Vector3.new(10000, 10000, 10000)

			BodyAngularVelocity.AngularVelocity = vector3_3
			BodyAngularVelocity.MaxTorque = vector3_4
			BodyAngularVelocity.P = 1000
			BodyVelocity.Parent = Character.Head
			BodyAngularVelocity.Parent = Character.Head
			u33 = true
			Humanoid.Died:connect(function()
				u33 = false
			end)

			return
		end
	end
	local InputBegan = game:GetService("UserInputService").InputBegan
	local u40 = t2

	InputBegan:connect(function(p2, p3)
		if not p3 then
			for k, _ in pairs(u40) do
				if k ~= "Moving" and p2.KeyCode == Enum.KeyCode[k] then
					u40[k] = true
					u40.Moving = true
				end
			end

			return
		end
	end)

	local InputEnded = game:GetService("UserInputService").InputEnded
	local u42 = t2

	InputEnded:connect(function(p4, p5)
		if not p5 then
			local v246 = false

			for k, _ in pairs(u42) do
				if k ~= "Moving" then
					if p4.KeyCode == Enum.KeyCode[k] then
						u42[k] = false
					end

					if u42[k] then
						v246 = true
					end
				end
			end

			u42.Moving = v246

			return
		end
	end)
	local Heartbeat = game:GetService("RunService").Heartbeat
	local u45 = t2
	local u46 = t1

	Heartbeat:connect(function(p6)
		if u33 and Character and Character.PrimaryPart then
			local PrimaryPartPosition = Character.PrimaryPart.Position
			local CameraCFrame = Camera.CFrame
			local v253, v254, v255 = CameraCFrame:toEulerAnglesXYZ()

			Character:SetPrimaryPartCFrame(CFrame.new(PrimaryPartPosition.x, PrimaryPartPosition.y, PrimaryPartPosition.z) * CFrame.Angles(v253, v254, v255))

			if u45.Moving then
				local vector3 = Vector3.new()

				if u45.W then
					local lookVector = CameraCFrame.lookVector

					vector3 = vector3 + lookVector * (u46.flyspeed / lookVector.Magnitude)
				end

				if u45.S then
					local lookVector = CameraCFrame.lookVector

					vector3 = vector3 - lookVector * (u46.flyspeed / lookVector.Magnitude)
				end

				if u45.A then
					local rightVector = CameraCFrame.rightVector

					vector3 = vector3 - rightVector * (u46.flyspeed / rightVector.Magnitude)
				end

				if u45.D then
					local rightVector = CameraCFrame.rightVector

					vector3 = vector3 + rightVector * (u46.flyspeed / rightVector.Magnitude)
				end

				Character:TranslateBy(vector3 * p6)
			end
		end
	end)

	local v47 = loadstring(game:HttpGet("https://raw.githubusercontent.com/bitef4/Recode/main/UI/Kavo_1.lua"))()
	local v48 = v47.CreateLib("PinokioScripts | Arsenal", "GrapeTheme")
	local v49 = v48:NewTab("Main")
	local v50 = v49:NewSection("Welcome To PinokioScripts | " .. game.Players.LocalPlayer.Name)
	local v51 = v49:NewSection("> Hitbox Settings <")
	local v52 = v49:NewSection("> Triggerbot <")
	local u53 = false
	local u54 = false
	local t3 = {}
	local n1 = 21
	local n2 = 6
	local s1 = "FFA"
	local t4 = {
		"UpperTorso",
		"Head",
		"HumanoidRootPart",
	}
	local ScreenGui = Instance.new("ScreenGui", u12.PlayerGui)
	local TextLabel = Instance.new("TextLabel", ScreenGui)

	TextLabel.Size = UDim2.new(0, 200, 0, 50)
	TextLabel.TextSize = 16
	TextLabel.Position = UDim2.new(0.5, -150, 0, 0)
	TextLabel.Text = ""
	TextLabel.TextColor3 = Color3.new(1, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Visible = false

	local function v62(p7)
		if t3[p7] then
			for k, v in pairs(t3[p7]) do
				local v266 = p7.Character and p7.Character:FindFirstChild(k)

				if v266 and v266:IsA("BasePart") then
					v266.CanCollide = v.CanCollide
					v266.Transparency = v.Transparency
					v266.Size = v.Size
				end
			end
		end
	end
	local function u63(p8, p9)
		if p8.Character then
			local children = p8.Character:GetChildren()

			for _, v in ipairs(children) do
				if v:IsA("BasePart") then
					local v272 = v.Name:lower()
					local v273 = (function(...)
						local t5 = { ... }

						t5.n = select("#", ...)

						return t5
					end)(p9:lower())

					if v272:match(unpack(v273, 1, v273.n)) then
						return v
					end
				end
			end

			return nil
		end

		return nil
	end
	local function u64(p10, p11)
		if not t3[p10] then
			t3[p10] = {}
		end

		if not t3[p10][p11.Name] then
			t3[p10][p11.Name] = {
				CanCollide = p11.CanCollide,
				Transparency = p11.Transparency,
				Size = p11.Size,
			}
		end
	end
	local function u65(p12)
		for _, v in ipairs(t4) do
			local v279 = p12.Character and (p12.Character:FindFirstChild(v) or u63(p12, v))

			if v279 and v279:IsA("BasePart") then
				u64(p12, v279)
				v279.CanCollide = not u54
				v279.Transparency = n2 / 10
				v279.Size = Vector3.new(n1, n1, n1)
			end
		end
	end

	local u66 = v62

	local function v67()
		for _, player in ipairs(u13:GetPlayers()) do
			if player ~= u12 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				if s1 ~= "FFA" and (s1 ~= "Everyone" and u12.Team == player.Team) then
					u66(player)
				else
					u65(player)
				end
			end
		end
	end

	local u68 = v67

	local function v69(_)
		task.wait(0.1)

		if u53 then
			u68()
		end
	end

	local u70 = v69
	local u71 = v62
	local u72 = v62

	u13.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(u70)

		local CharacterRemoving = player.CharacterRemoving
		local u287 = player

		CharacterRemoving:Connect(function()
			u71(u287)
			t3[u287] = nil
		end)
	end)

	for _, player in ipairs(u13:GetPlayers()) do
		player.CharacterAdded:Connect(v69)

		local CharacterRemoving = player.CharacterRemoving
		local u76 = v62
		local u77 = player

		CharacterRemoving:Connect(function()
			u76(u77)
			t3[u77] = nil
		end)
	end

	local u78 = v67

	local function u79()
		for k, _ in pairs(t3) do
			if not k.Parent or not k.Character or not k.Character:IsDescendantOf(game) then
				u72(k)
				t3[k] = nil
			end
		end
	end

	v51:NewButton("[CLICK THIS FIRST] Enable Hitbox", "?", function()
		coroutine.wrap(function()
			while true do
				if u53 then
					u78()
					u79()
				end

				task.wait(0.1)
			end
		end)()
	end)

	local u80 = v67
	local u81 = v62

	v51:NewToggle("Enable Hitbox", "?", function(p14)
		u53 = p14

		if not p14 then
			for _, player in ipairs(u13:GetPlayers()) do
				u81(player)
			end

			t3 = {}

			return
		end

		u80()
	end)

	local u82 = v67

	v51:NewSlider("Hitbox Size", "?", 25, 1, function(p15)
		n1 = p15

		if u53 then
			u82()
		end
	end)

	local u83 = v67

	v51:NewSlider("Hitbox Transparency", "?", 10, 1, function(p16)
		n2 = p16

		if u53 then
			u83()
		end
	end)

	local t6 = {
		"FFA",
		"Team-Based",
		"Everyone",
	}
	local u85 = v67

	v51:NewDropdown("Team Check", "?", t6, function(p17)
		s1 = p17

		if u53 then
			u85()
		end
	end)

	local u86 = TextLabel
	local u87 = v67

	v51:NewToggle("No Collision", "?", function(p18)
		u54 = p18
		u86.Visible = p18
		coroutine.wrap(function()
			while u54 do
				if u53 then
					u87()
				end

				task.wait(0.01)
			end

			if u53 then
				u87()
			end
		end)()
	end)
	v50:NewToggle("AutoFarm [Could get you ban]", "?", function(p19)
		getgenv().AutoFarm = p19

		local u298 = nil
		local u299 = false
		local LocalPlayer3 = game.Players.LocalPlayer
		local CurrentCamera = game.Workspace.CurrentCamera

		game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = p19 and "Infinite Ammo" or ""

		local u302 = LocalPlayer3

		function closestplayer()
			local n3 = 1e999
			local v491 = nil

			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= u302 and player.TeamColor ~= u302.TeamColor and player.Character then
					local Character2 = player.Character
					local HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart")
					local Humanoid2 = Character2:FindFirstChild("Humanoid")

					if HumanoidRootPart and Humanoid2 and Humanoid2.Health > 0 then
						local Magnitude = (u302.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude

						if Magnitude < n3 then
							n3 = Magnitude
							v491 = player
						end
					end
				end
			end

			return v491
		end

		local u303 = LocalPlayer3

		local function v304()
			game:GetService("ReplicatedStorage").wkspc.TimeScale.Value = 12
			u298 = game:GetService("RunService").Stepped:Connect(function()
				if not getgenv().AutoFarm then
					if u298 then
						u298:Disconnect()
						u298 = nil
					end

					if u299 then
						mouse1release()
						u299 = false
					end
				else
					local v574 = closestplayer()

					if not v574 or not u303.Character or not u303.Character:FindFirstChild("HumanoidRootPart") then
						if u299 then
							mouse1release()
							u299 = false

							return
						end
					else
						local HumanoidRootPart = v574.Character.HumanoidRootPart
						local v576 = HumanoidRootPart.Position - HumanoidRootPart.CFrame.LookVector * 2 + Vector3.new(0, 2, 0)

						u303.Character.HumanoidRootPart.CFrame = CFrame.new(v576)

						if v574.Character:FindFirstChild("Head") then
							local HeadPosition = v574.Character.Head.Position

							CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, HeadPosition)
						end

						if not u299 then
							mouse1press()
							u299 = true

							return
						end
					end
				end
			end)
		end

		local u305 = v304

		LocalPlayer3.CharacterAdded:Connect(function(_)
			task.wait(0.5)
			u305()
		end)

		if not p19 then
			game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = ""
			getgenv().AutoFarm = false
			game:GetService("ReplicatedStorage").wkspc.TimeScale.Value = 1

			if u298 then
				u298:Disconnect()
			end

			if u299 then
				mouse1release()
			end
		else
			task.wait(0.5)
			v304()
		end
	end)
	getgenv().triggerb = false

	local s2 = "Team-Based"
	local n4 = 0.2
	local u90 = true

	v52:NewToggle("Enable Triggerbot", "triggerbot on or off", function(p21)
		getgenv().triggerb = p21
	end)
	v52:NewDropdown("Team Check Mode", "teamchecking mode", {
		"FFA",
		"Team-Based",
		"Everyone",
	}, function(p22)
		s2 = p22
	end)
	v52:NewSlider("Shot Delay", "delay between shots (1-10)", 10, 1, function(p23)
		n4 = p23 / 10
	end)

	local function v91()
		local LocalPlayer4 = game.Players.LocalPlayer
		local Humanoid3 = (LocalPlayer4.Character or LocalPlayer4.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")

		if Humanoid3 then
			Humanoid3.HealthChanged:Connect(function(p24)
				u90 = p24 > 0
			end)
		end
	end

	game.Players.LocalPlayer.CharacterAdded:Connect(v91)
	v91()
	game:GetService("RunService").RenderStepped:Connect(function()
		if getgenv().triggerb and u90 then
			local LocalPlayer5 = game.Players.LocalPlayer
			local Target = LocalPlayer5:GetMouse().Target

			if Target and Target.Parent:FindFirstChild("Humanoid") and Target.Parent.Name ~= LocalPlayer5.Name then
				local TargetParentName = game:GetService("Players"):FindFirstChild(Target.Parent.Name)

				if TargetParentName then
					local v315

					if s2 ~= "FFA" then
						if s2 ~= "Everyone" then
							v315 = s2 == "Team-Based" and game.Players.LocalPlayer.Team ~= TargetParentName.Team
						else
							v315 = TargetParentName ~= game.Players.LocalPlayer
						end
					else
						v315 = true
					end

					if v315 then
						mouse1press()
						task.wait(n4)
						mouse1release()
					end
				end
			end
		end
	end)

	local v92 = v48:NewTab("Gun Modded"):NewSection("> Overpower Gun <")

	v92:NewToggle("Infinite Ammo v1", "?", function(p25)
		game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = p25 and "Infinite Ammo" or ""
	end)

	local u93 = false

	v92:NewToggle("Infinite Ammo v2", "?", function(p26)
		u93 = p26

		if p26 then
			game:GetService("RunService").Stepped:connect(function()
				pcall(function()
					if u93 then
						local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui

						PlayerGui.GUI.Client.Variables.ammocount.Value = 99
						PlayerGui.GUI.Client.Variables.ammocount2.Value = 99
					end
				end)
			end)
		end
	end)

	local t7 = {
		FireRate = {},
		ReloadTime = {},
		EReloadTime = {},
		Auto = {},
		Spread = {},
		Recoil = {},
	}
	local u95 = t7

	v92:NewToggle("Fast Reload", "?", function(p27)
		for _, child in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
			if child:FindFirstChild("ReloadTime") then
				if not p27 then
					if not u95.ReloadTime[child] then
						child.ReloadTime.Value = 0.8
					else
						child.ReloadTime.Value = u95.ReloadTime[child]
					end
				else
					if not u95.ReloadTime[child] then
						u95.ReloadTime[child] = child.ReloadTime.Value
					end

					child.ReloadTime.Value = 0.01
				end
			end

			if child:FindFirstChild("EReloadTime") then
				if not p27 then
					if not u95.EReloadTime[child] then
						child.EReloadTime.Value = 0.8
					else
						child.EReloadTime.Value = u95.EReloadTime[child]
					end
				else
					if not u95.EReloadTime[child] then
						u95.EReloadTime[child] = child.EReloadTime.Value
					end

					child.EReloadTime.Value = 0.01
				end
			end
		end
	end)

	local u96 = t7

	v92:NewToggle("Fast Fire Rate", "?", function(p28)
		for _, descendant in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
			if descendant.Name == "FireRate" or descendant.Name == "BFireRate" then
				if not p28 then
					if not u96.FireRate[descendant] then
						descendant.Value = 0.8
					else
						descendant.Value = u96.FireRate[descendant]
					end
				else
					if not u96.FireRate[descendant] then
						u96.FireRate[descendant] = descendant.Value
					end

					descendant.Value = 0.02
				end
			end
		end
	end)

	local u97 = t7

	v92:NewToggle("Always Auto", "?", function(p29)
		for _, descendant in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
			if
				descendant.Name == "Auto"
				or descendant.Name == "AutoFire"
				or descendant.Name == "Automatic"
				or descendant.Name == "AutoShoot"
				or descendant.Name == "AutoGun"
			then
				if not p29 then
					if not u97.Auto[descendant] then
						descendant.Value = false
					else
						descendant.Value = u97.Auto[descendant]
					end
				else
					if not u97.Auto[descendant] then
						u97.Auto[descendant] = descendant.Value
					end

					descendant.Value = true
				end
			end
		end
	end)

	local u98 = t7

	v92:NewToggle("No Spread", "?", function(p30)
		for _, descendant in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
			if descendant.Name == "MaxSpread" or descendant.Name == "Spread" or descendant.Name == "SpreadControl" then
				if not p30 then
					if not u98.Spread[descendant] then
						descendant.Value = 1
					else
						descendant.Value = u98.Spread[descendant]
					end
				else
					if not u98.Spread[descendant] then
						u98.Spread[descendant] = descendant.Value
					end

					descendant.Value = 0
				end
			end
		end
	end)

	local u99 = t7

	v92:NewToggle("No Recoil", "?", function(p31)
		for _, descendant in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
			if descendant.Name == "RecoilControl" or descendant.Name == "Recoil" then
				if not p31 then
					if not u99.Recoil[descendant] then
						descendant.Value = 1
					else
						descendant.Value = u99.Recoil[descendant]
					end
				else
					if not u99.Recoil[descendant] then
						u99.Recoil[descendant] = descendant.Value
					end

					descendant.Value = 0
				end
			end
		end
	end)

	local v100 = v48:NewTab("Player"):NewSection("> Fly Hacks <")
	local u101 = LocalPlayer2

	v100:NewToggle("Fly", "Allows the player to fly", function(p32)
		if not p32 then
			if u101.Character then
				if not u33 then
					return
				end

				Humanoid.PlatformStand = false
				BodyVelocity:Destroy()
				BodyAngularVelocity:Destroy()
				u33 = false
			end

			return
		end

		u37()
	end)

	local u102 = t1

	v100:NewSlider("Fly Speed", "Allows for faster/slower flight", 500, 1, function(p33)
		u102.flyspeed = p33
	end)
	v100:NewLabel("> Speed Power <")

	local t8 = {
		WalkSpeed = 16,
	}
	local u104 = false

	v100:NewToggle("Custom WalkSpeed", "Toggle custom walkspeed", function(p34)
		u104 = p34
	end)

	local t9 = {
		"Velocity",
		"Vector",
		"CFrame",
	}
	local u106 = t9[1]

	v100:NewDropdown("Walk Method", "Choose walk method", t9, function(p35)
		u106 = p35
	end)

	local u107 = t8

	v100:NewSlider("Walkspeed Power", "Adjust walkspeed power", 500, 16, function(p36)
		u107.WalkSpeed = p36
	end)

	local u108 = t8
	local Stepped = game:GetService("RunService").Stepped

	local function u110(p37, p38)
		local Character3 = p37.Character
		local v341 = Character3 and Character3:FindFirstChildOfClass("Humanoid")
		local v342 = Character3 and Character3:FindFirstChild("HumanoidRootPart")

		if v341 and v342 then
			local v343 = v341.MoveDirection * u108.WalkSpeed

			if u106 == "Velocity" then
				v342.Velocity = Vector3.new(v343.X, v342.Velocity.Y, v343.Z)

				return
			end

			if u106 == "Vector" then
				v342.CFrame = v342.CFrame + v343 * p38 * 0.0001

				return
			end

			if u106 == "CFrame" then
				v342.CFrame = v342.CFrame + v341.MoveDirection * u108.WalkSpeed * p38 * 0.0001

				return
			end

			v341.WalkSpeed = u108.WalkSpeed
		end
	end

	Stepped:Connect(function(p39)
		if u104 then
			local LocalPlayer6 = game:GetService("Players").LocalPlayer

			if LocalPlayer6 and LocalPlayer6.Character and LocalPlayer6.Character:FindFirstChild("HumanoidRootPart") then
				u110(LocalPlayer6, p39)
			end
		end
	end)
	v100:NewLabel("> JumpPower <")

	local u111 = false

	v100:NewToggle("Infinite Jump", "Toggle infinite jump", function(p40)
		u111 = p40
		game:GetService("UserInputService").JumpRequest:Connect(function()
			if u111 then
				game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
			end
		end)
	end)

	local u112 = false

	v100:NewToggle("Custom JumpPower", "Toggle custom jumppower", function(p41)
		u112 = p41
	end)

	local t10 = {
		"Velocity",
		"Vector",
		"CFrame",
	}
	local u114 = t10[1]

	v100:NewDropdown("Jump Method", "Choose jump method", t10, function(p42)
		u114 = p42
	end)
	v100:NewSlider("Change JumpPower", "Adjust jumppower", 500, 30, function(p43)
		local LocalPlayer7 = game:GetService("Players").LocalPlayer
		local Humanoid4 = LocalPlayer7.Character:WaitForChild("Humanoid")

		Humanoid4.UseJumpPower = true

		local Jumping = Humanoid4.Jumping
		local u353 = LocalPlayer7
		local u354 = p43

		Jumping:Connect(function(p44)
			if u112 and p44 then
				local HumanoidRootPart = u353.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart then
					if u114 == "Velocity" then
						HumanoidRootPart.Velocity = HumanoidRootPart.Velocity * Vector3.new(1, 0, 1) + Vector3.new(0, u354, 0)

						return
					end

					if u114 == "Vector" then
						HumanoidRootPart.Velocity = Vector3.new(0, u354, 0)

						return
					end

					if u114 == "CFrame" then
						u353.Character:SetPrimaryPartCFrame(u353.Character:GetPrimaryPartCFrame() + Vector3.new(0, u354, 0))
					end
				end
			end
		end)
	end)
	v100:NewLabel("> Anti Aim <")

	local n5 = 10
	local u116 = nil

	v100:NewToggle("Anti-Aim v1", "Toggle anti-aim feature", function(p45)
		local Character4 = game.Players.LocalPlayer.Character
		local v357 = Character4 and Character4:FindFirstChild("HumanoidRootPart")

		if not p45 then
			if v357 then
				local AntiAimSpin = v357:FindFirstChild("AntiAimSpin")

				if AntiAimSpin then
					AntiAimSpin:Destroy()
				end

				if u116 then
					u116:Destroy()
					u116 = nil
				end
			end
		elseif v357 then
			local BodyAngularVelocity2 = Instance.new("BodyAngularVelocity")

			BodyAngularVelocity2.Name = "AntiAimSpin"
			BodyAngularVelocity2.AngularVelocity = Vector3.new(0, n5, 0)
			BodyAngularVelocity2.MaxTorque = Vector3.new(0, 1e999, 0)
			BodyAngularVelocity2.P = 500000
			BodyAngularVelocity2.Parent = v357
			u116 = Instance.new("BodyGyro")
			u116.Name = "AntiAimGyro"
			u116.MaxTorque = Vector3.new(1e999, 1e999, 1e999)
			u116.CFrame = v357.CFrame
			u116.P = 3000
			u116.Parent = v357

			return
		end
	end)
	v100:NewSlider("Spin Speed", "Adjust the speed of the anti-aim spin", 100, 10, function(p46)
		n5 = p46

		local Character5 = game.Players.LocalPlayer.Character
		local v362 = Character5 and Character5:FindFirstChild("HumanoidRootPart")

		if v362 then
			local AntiAimSpin = v362:FindFirstChild("AntiAimSpin")

			if AntiAimSpin then
				AntiAimSpin.AngularVelocity = Vector3.new(0, p46, 0)
			end
		end
	end)
	v100:NewLabel("> Object Teleport <")

	local s3 = "Both"
	local t11 = {
		"DeadHP",
		"DeadAmmo",
		"Both",
	}
	local u119 = false

	v100:NewToggle("Enable Collect debris", "object teleport to you", function(p47)
		u119 = p47

		if p47 then
			task.spawn(function()
				while u119 do
					task.wait(0.1)
					pcall(function()
						local Character6 = game.Players.LocalPlayer.Character

						if Character6 then
							local HumanoidRootPart = Character6:FindFirstChild("HumanoidRootPart")

							if HumanoidRootPart then
								for _, child in pairs(game.Workspace.Debris:GetChildren()) do
									if
										s3 == "DeadHP" and child.Name == "DeadHP"
										or s3 == "DeadAmmo" and child.Name == "DeadAmmo"
										or s3 == "Both" and (child.Name == "DeadHP" or child.Name == "DeadAmmo")
									then
										child.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0.2, 0)
									end
								end
							end
						end
					end)
				end
			end)
		end
	end)
	v100:NewDropdown("Select Object", "Choose DeadHP, DeadAmmo, or Both", t11, function(p48)
		s3 = p48
	end)
	v100:NewLabel("> Useful Cheat <")
	v100:NewTextBox("TimeScale", "?", function(p49)
		game:GetService("ReplicatedStorage").wkspc.TimeScale.Value = p49
	end)
	v100:NewLabel("> Misc <")
	v100:NewSlider("FOV Arsenal", "?", 120, 0, function(p50)
		game:GetService("Players").LocalPlayer.Settings.FOV.Value = p50
	end)

	local u120 = false

	v100:NewToggle("Toggle NoClip", "?", function(p51)
		u120 = p51

		local LocalPlayer8 = game.Players.LocalPlayer

		if p51 then
			task.spawn(function()
				while u120 do
					local Character7 = LocalPlayer8.Character

					if Character7 then
						for _, descendant in pairs(Character7:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.CanCollide = false
							end
						end
					end

					game:GetService("RunService").Stepped:Wait()
				end

				local Character8 = LocalPlayer8.Character

				if Character8 then
					for _, descendant in pairs(Character8:GetDescendants()) do
						if descendant:IsA("BasePart") then
							descendant.CanCollide = true
						end
					end
				end
			end)
		end
	end)
	game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
		if u120 then
			local spawn = task.spawn
			local u372 = character

			spawn(function()
				while u120 do
					if u372 then
						for _, descendant in pairs(u372:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.CanCollide = false
							end
						end
					end

					game:GetService("RunService").Stepped:Wait()
				end

				for _, descendant in pairs(u372:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = true
					end
				end
			end)
		end
	end)
	local u121

	v100:NewToggle("Toggle Xray", "WallXray lol", function(p52)
		u121 = p52

		if not p52 then
			for _, descendant in pairs(workspace:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant:FindFirstChild("OriginalTransparency") then
					descendant.Transparency = descendant.OriginalTransparency.Value
					descendant.OriginalTransparency:Destroy()
				end
			end

			return
		end

		for _, descendant in pairs(workspace:GetDescendants()) do
			if descendant:IsA("BasePart") then
				if not descendant:FindFirstChild("OriginalTransparency") then
					local NumberValue = Instance.new("NumberValue")

					NumberValue.Name = "OriginalTransparency"
					NumberValue.Value = descendant.Transparency
					NumberValue.Parent = descendant
				end

				descendant.Transparency = 0.5
			end
		end
	end)

	local v122 = v48:NewTab("Links"):NewSection("> Official Links & Networks <")

	v122:NewButton("Join my AI Network!", "Click to quickly copy AI link", function()
		u14("https://pinokioai-08ue.onrender.com/")
		u10:SetCore("SendNotification", {
			Title = "PinokioScripts",
			Text = "AI link copied to clipboard!",
			Duration = 4,
		})
	end)
	v122:NewButton("Looking for Testers! (Join Here)", "Click to quickly copy Testers link", function()
		u14("https://discord.com/channels/1517925722860032052/1527999621647958176")
		u10:SetCore("SendNotification", {
			Title = "PinokioScripts",
			Text = "Testers Discord link copied to clipboard!",
			Duration = 4,
		})
	end)

	local v123 = v48:NewTab("Color Skins"):NewSection("> Arm Skins <")
	local s4 = "Plastic"

	v123:NewDropdown("Arm Material", "?", {
		"Plastic",
		"ForceField",
		"Wood",
		"Grass",
	}, function(p53)
		s4 = p53
	end)

	local color3 = Color3.new(50, 50, 50)

	v123:NewColorPicker("Arm Color", "?", Color3.fromRGB(50, 50, 50), function(p54)
		color3 = p54
	end)

	local u126 = false

	v123:NewToggle("Arm Charms", "?", function(p55)
		u126 = p55

		if p55 then
			task.spawn(function()
				while true do
					task.wait(0.01)

					if not u126 then
						break
					end

					local Arms = workspace.Camera:FindFirstChild("Arms")

					if Arms then
						for _, descendant in pairs(Arms:GetDescendants()) do
							if descendant.Name ~= "Right Arm" and descendant.Name ~= "Left Arm" then
								if not descendant:IsA("SpecialMesh") then
									if descendant.Name == "L" or descendant.Name == "R" then
										descendant:Destroy()
									end
								elseif descendant.TextureId == "" then
									descendant.TextureId = "rbxassetid://0"

									descendant.VertexColor = Vector3.new(color3.R, color3.G, color3.B)
								end
							elseif descendant:IsA("BasePart") then
								descendant.Material = Enum.Material[s4]
								descendant.Color = color3
							end
						end
					end
				end
			end)
		end
	end)
	v123:NewLabel("> Gun Skin <")

	local s5 = "Plastic"

	v123:NewDropdown("Gun Material", "?", {
		"Plastic",
		"ForceField",
		"Wood",
		"Grass",
	}, function(p56)
		s5 = p56
	end)

	local color3_2 = Color3.new(50, 50, 50)

	v123:NewColorPicker("Gun Color", "?", Color3.fromRGB(50, 50, 50), function(p57)
		color3_2 = p57
	end)

	local u129 = false

	v123:NewToggle("Gun Charms", "?", function(p58)
		u129 = p58

		if p58 then
			task.spawn(function()
				while true do
					task.wait(0.01)

					if not u129 then
						break
					end

					if not workspace.Camera:FindFirstChild("Arms") then
						task.wait()
					else
						for _, descendant in pairs(workspace.Camera.Arms:GetDescendants()) do
							if descendant:IsA("MeshPart") then
								descendant.Material = Enum.Material[s5]
								descendant.Color = color3_2
							end
						end
					end
				end
			end)
		end
	end)
	v123:NewLabel("> Rainbow Gun <")

	local u130 = false
	local n6 = 1

	function zigzag(p59)
		local v387 = p59 * 3.141592653589793
		local v388 = math.cos(v387)

		return math.acos(v388) / 3.141592653589793
	end

	v123:NewToggle("Rainbow Gun v1", "?", function(p60)
		u130 = p60
	end)
	game:GetService("RunService").RenderStepped:Connect(function()
		if game.Workspace.Camera:FindFirstChild("Arms") and u130 then
			for _, descendant in pairs(game.Workspace.Camera.Arms:GetDescendants()) do
				if descendant.ClassName == "MeshPart" then
					descendant.Color = Color3.fromHSV(zigzag(n6), 1, 1)
					n6 = n6 + 0.0001
				end
			end
		end
	end)

	local u132 = false
	local n7 = 0

	function updateColors()
		for _, descendant in pairs(game.Workspace.Camera.Arms:GetDescendants()) do
			if descendant.ClassName == "MeshPart" then
				descendant.Color = Color3.fromHSV(n7, 1, 1)
			end
		end
	end

	v123:NewToggle("Rainbow Gun v2 [Crazy Fast Animation]", "?", function(p61)
		u132 = p61
	end)
	game:GetService("RunService").RenderStepped:Connect(function()
		if game.Workspace.Camera:FindFirstChild("Arms") and u132 then
			n7 = n7 + 0.1

			if n7 >= 1 then
				n7 = n7 % 1
			end

			updateColors()
		end
	end)

	local v134 = v48:NewTab("Extra"):NewSection("Random")

	local function u135()
		for _, descendant in pairs(game:GetDescendants()) do
			if descendant:IsA("ParticleEmitter") then
				descendant.Parent = game.Players.LocalPlayer.Character["Particle Area"]
			end
		end
	end
	local function u136()
		for _, descendant in pairs(game:GetDescendants()) do
			if descendant:IsA("ParticleEmitter") then
				descendant.Parent = workspace
			end
		end
	end

	v134:NewToggle("Mess up your screen lol", "?", function(p62)
		if not p62 then
			u136()

			return
		end

		u135()
	end)

	local t12 = {
		Score = nil,
		Kills = nil,
	}

	v134:NewToggle("Max Level???", "e", function(p63)
		local CareerStatsCache = u12.CareerStatsCache

		if not p63 then
			if t12.Score and t12.Kills then
				CareerStatsCache.Score.Value = t12.Score
				CareerStatsCache.Kills.Value = t12.Kills
			end

			return
		end

		if not t12.Score then
			t12.Score = CareerStatsCache.Score.Value
		end

		if not t12.Kills then
			t12.Kills = CareerStatsCache.Kills.Value
		end

		CareerStatsCache.Score.Value = 1E+18
		CareerStatsCache.Kills.Value = 100000000000000
	end)

	local t13 = {
		GUIName = nil,
		GUIName2 = nil,
		KillFeed = {},
		WinnerName = nil,
		ScorecardName = nil,
	}
	local u139
	local u140 = false
	local u141 = t13
	local u142 = t13

	local function u143()
		local PlayerGui = u12.PlayerGui

		PlayerGui.GUI_Scorecard.Scorecard.Scrolling.Visible = false
		PlayerGui.Menew_Main.Container.PlrName.Text = "PinokioScripts"
		PlayerGui.Menew_Main.Container.PlrName2.Text = "PinokioScripts"
		Workspace.KillFeed["1"].Killer.Value = "PinokioScripts On Top"
		Workspace.KillFeed["2"].Killer.Value = "PinokioScripts On Top"
		Workspace.KillFeed["3"].Killer.Value = "PinokioScripts On Top"
		Workspace.KillFeed["4"].Killer.Value = "PinokioScripts On Top"
		Workspace.KillFeed["5"].Killer.Value = "PinokioScripts On Top"
		Workspace.KillFeed["6"].Killer.Value = "PinokioScripts On Top"
		PlayerGui.GUI.Winner.Visible = false
		PlayerGui.GUI_Scorecard.Scorecard.PlayerCard.Username.Text = "PinokioScripts"
	end
	local function u144()
		local PlayerGui = u12.PlayerGui

		if u141.GUIName then
			PlayerGui.Menew_Main.Container.PlrName.Text = u141.GUIName
		end

		if u141.GUIName2 then
			PlayerGui.Menew_Main.Container.PlrName2.Text = u141.GUIName2
		end

		for k, v in pairs(u141.KillFeed) do
			Workspace.KillFeed[tostring(k)].Killer.Value = v
		end

		if u141.WinnerName ~= nil then
			PlayerGui.GUI.Winner.Visible = u141.WinnerName
		end

		if u141.ScorecardName then
			PlayerGui.GUI_Scorecard.Scorecard.PlayerCard.Username.Text = u141.ScorecardName
		end
	end

	v134:NewToggle("change Name", "weird name", function(p64)
		u139 = p64
		u140 = p64

		if not p64 then
			u140 = false
			u144()

			return
		end

		local PlayerGui = u12.PlayerGui

		u142.GUIName = PlayerGui.Menew_Main.Container.PlrName.Text
		u142.GUIName2 = PlayerGui.Menew_Main.Container.PlrName2.Text
		u142.WinnerName = PlayerGui.GUI.Winner.Visible
		u142.ScorecardName = PlayerGui.GUI_Scorecard.Scorecard.PlayerCard.Username.Text

		for i = 1, 6 do
			u142.KillFeed[i] = Workspace.KillFeed[tostring(i)].Killer.Value
		end

		task.spawn(function()
			while u140 do
				pcall(u143)
				task.wait(0.2)
			end
		end)
	end)
	v134:NewLabel("Chat")
	v134:NewToggle("IsChad", "?", function(p65)
		if not game.Players.LocalPlayer:FindFirstChild("IsChad") then
			if p65 then
				Instance.new("IntValue", game.Players.LocalPlayer).Name = "IsChad"
			end

			return
		end

		game.Players.LocalPlayer.IsChad:Destroy()
	end)
	v134:NewToggle("VIP", "?", function(p66)
		if not game.Players.LocalPlayer:FindFirstChild("VIP") then
			if p66 then
				Instance.new("IntValue", game.Players.LocalPlayer).Name = "VIP"
			end

			return
		end

		game.Players.LocalPlayer.VIP:Destroy()
	end)
	v134:NewToggle("OldVIP", "?", function(p67)
		if not game.Players.LocalPlayer:FindFirstChild("OldVIP") then
			if p67 then
				Instance.new("IntValue", game.Players.LocalPlayer).Name = "OldVIP"
			end

			return
		end

		game.Players.LocalPlayer.OldVIP:Destroy()
	end)
	v134:NewToggle("Romin", "?", function(p68)
		if not game.Players.LocalPlayer:FindFirstChild("Romin") then
			if p68 then
				Instance.new("IntValue", game.Players.LocalPlayer).Name = "Romin"
			end

			return
		end

		game.Players.LocalPlayer.Romin:Destroy()
	end)
	v134:NewToggle("IsAdmin", "?", function(p69)
		if not game.Players.LocalPlayer:FindFirstChild("IsAdmin") then
			if p69 then
				Instance.new("IntValue", game.Players.LocalPlayer).Name = "IsAdmin"
			end

			return
		end

		game.Players.LocalPlayer.IsAdmin:Destroy()
	end)

	local v145 = v48:NewTab("Visuals")
	local v146 = v145:NewSection("> ESP V1 <")
	local v147 = loadstring(game:HttpGet("https://rawscript.vercel.app/api/raw/esp_1"))()
	local u148 = v147

	v146:NewToggle("Enable Esp", "?", function(p70)
		u148:Toggle(p70)
		u148.Players = p70
	end)

	local u149 = v147

	v146:NewToggle("Tracers Esp", "?", function(p71)
		u149.Tracers = p71
	end)

	local u150 = v147

	v146:NewToggle("Name Esp", "?", function(p72)
		u150.Names = p72
	end)

	local u151 = v147

	v146:NewToggle("Boxes Esp", "?", function(p73)
		u151.Boxes = p73
	end)

	local u152 = v147

	v146:NewToggle("Team Coordinate", "?", function(p74)
		u152.TeamColor = p74
	end)

	local u153 = v147

	v146:NewToggle("Teammates", "?", function(p75)
		u153.TeamMates = p75
	end)

	local color3_3 = Color3.fromRGB(255, 255, 255)
	local u155 = v147

	v146:NewColorPicker("ESP Color", "?", color3_3, function(p76)
		u155.Color = p76
	end)

	local v156 = v145:NewSection("> ESP Options <")
	local t14 = {}

	local function v158(p77, p78)
		local BillboardGui = Instance.new("BillboardGui")
		local TextLabel2 = Instance.new("TextLabel")

		BillboardGui.Name = "dontask"
		BillboardGui.Parent = p77
		BillboardGui.AlwaysOnTop = true
		BillboardGui.Size = UDim2.new(0, 50, 0, 50)
		BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
		TextLabel2.Parent = BillboardGui
		TextLabel2.BackgroundColor3 = Color3.new(1, 1, 1)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Size = UDim2.new(1, 0, 1, 0)
		TextLabel2.Text = p78
		TextLabel2.TextColor3 = Color3.new(1, 0, 0)
		TextLabel2.TextScaled = false

		return BillboardGui
	end
	local u161 = v158
	local u162 = t14

	local function v163(p79, p80, p81)
		if not p79 then
			for k, v in pairs(u162) do
				if k and v then
					v:Destroy()
					u162[k] = nil
				end
			end

			return
		end

		for _, descendant in ipairs(game.Workspace:GetDescendants()) do
			if descendant:IsA("TouchTransmitter") and p80 == descendant.Parent.Name and descendant:IsA("TouchTransmitter") then
				local descendantParent = descendant.Parent

				if not descendantParent:FindFirstChild("dontask") then
					u162[descendantParent] = u161(descendantParent, p81)
				end
			end
		end

		local DescendantAdded = game.Workspace.DescendantAdded
		local u438 = p80
		local u439 = p81

		DescendantAdded:Connect(function(p82)
			if p82:IsA("TouchTransmitter") and p82.Parent.Name == u438 then
				if p82:IsA("TouchTransmitter") then
					local p82Parent = p82.Parent

					if not p82Parent:FindFirstChild("dontask") then
						u162[p82Parent] = u161(p82Parent, u439)
					end
				end
			end
		end)
	end

	local u164 = v163

	v156:NewToggle("Ammo Box ESP", "?", function(p83)
		u164(p83, "DeadAmmo", "Ammo Box")
	end)

	local u165 = v163

	v156:NewToggle("HP Jug ESP", "?", function(p84)
		u165(p84, "DeadHP", "HP Jar")
	end)

	local v166 = v48:NewTab("Setting")
	local v167 = v166:NewSection("> Performance <")
	local t15 = {}
	local t16 = {}
	local t17 = {
		GlobalShadows = game.Lighting.GlobalShadows,
		FogEnd = game.Lighting.FogEnd,
		Brightness = game.Lighting.Brightness,
	}
	local t18 = {
		WaterWaveSize = game.Workspace.Terrain.WaterWaveSize,
		WaterWaveSpeed = game.Workspace.Terrain.WaterWaveSpeed,
		WaterReflectance = game.Workspace.Terrain.WaterReflectance,
		WaterTransparency = game.Workspace.Terrain.WaterTransparency,
	}
	local t19 = {}

	v167:NewToggle("Anti Lag", "?", function(p85)
		if not p85 then
			for k, v in pairs(t15) do
				if k and k:IsA("BasePart") then
					k.Material = v
				end
			end

			t15 = {}

			return
		end

		for _, descendant in pairs(game:GetService("Workspace"):GetDescendants()) do
			if descendant:IsA("BasePart") and not descendant.Parent:FindFirstChild("Humanoid") then
				t15[descendant] = descendant.Material
				descendant.Material = Enum.Material.SmoothPlastic

				if descendant:IsA("Texture") then
					table.insert(t16, descendant)
					descendant:Destroy()
				end
			end
		end
	end)

	local u173 = t18
	local u174 = t8
	local u175 = t17

	v167:NewToggle("FPS Boost", "?", function(p86)
		if not p86 then
			local Terrain = game.Workspace.Terrain

			Terrain.WaterWaveSize = u173.WaterWaveSize
			Terrain.WaterWaveSpeed = u173.WaterWaveSpeed
			Terrain.WaterReflectance = u173.WaterReflectance
			Terrain.WaterTransparency = u173.WaterTransparency
			game.Lighting.GlobalShadows = u175.GlobalShadows
			game.Lighting.FogEnd = u175.FogEnd
			game.Lighting.Brightness = u175.Brightness
			u174().Rendering.QualityLevel = "Automatic"

			for k, v in pairs(t15) do
				if k and k:IsA("BasePart") then
					k.Material = v
					k.Reflectance = 0
				end
			end

			t15 = {}

			for k, v in pairs(t19) do
				if k then
					k.Enabled = v
				end
			end

			t19 = {}

			for _, v in pairs(t16) do
				if v and v.Parent then
					v.Transparency = 0
				end
			end

			t16 = {}

			return
		end

		local _game = game
		local Workspace2 = game.Workspace
		local Lighting = game.Lighting
		local Terrain = Workspace2.Terrain

		u173.WaterWaveSize = Terrain.WaterWaveSize
		u173.WaterWaveSpeed = Terrain.WaterWaveSpeed
		u173.WaterReflectance = Terrain.WaterReflectance
		u173.WaterTransparency = Terrain.WaterTransparency
		Terrain.WaterWaveSize = 0
		Terrain.WaterWaveSpeed = 0
		Terrain.WaterReflectance = 0
		Terrain.WaterTransparency = 0
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9000000000
		Lighting.Brightness = 0
		u174().Rendering.QualityLevel = "Level01"

		for _, descendant in pairs(_game:GetDescendants()) do
			if not descendant:IsA("Part") and not descendant:IsA("Union") and not descendant:IsA("CornerWedgePart") and not descendant:IsA("TrussPart") then
				if not descendant:IsA("Decal") and not descendant:IsA("Texture") then
					if not descendant:IsA("ParticleEmitter") and not descendant:IsA("Trail") then
						if not descendant:IsA("Explosion") then
							if not descendant:IsA("Fire") and not descendant:IsA("SpotLight") and not descendant:IsA("Smoke") then
								if descendant:IsA("MeshPart") then
									t15[descendant] = descendant.Material
									descendant.Material = "Plastic"
									descendant.Reflectance = 0
									descendant.TextureID = 10385902758728956
								end
							else
								descendant.Enabled = false
							end
						else
							descendant.BlastPressure = 1
							descendant.BlastRadius = 1
						end
					else
						descendant.Lifetime = NumberRange.new(0)
					end
				else
					table.insert(t16, descendant)
					descendant.Transparency = 1
				end
			else
				t15[descendant] = descendant.Material
				descendant.Material = "Plastic"
				descendant.Reflectance = 0
			end
		end

		for _, child in pairs(Lighting:GetChildren()) do
			if
				child:IsA("BlurEffect")
				or child:IsA("SunRaysEffect")
				or child:IsA("ColorCorrectionEffect")
				or child:IsA("BloomEffect")
				or child:IsA("DepthOfFieldEffect")
			then
				t19[child] = child.Enabled
				child.Enabled = false
			end
		end
	end)

	local u176 = false

	v167:NewToggle("Full Bright", "?", function(p87)
		u176 = p87

		local Lighting = game:GetService("Lighting")
		local u467 = Lighting

		local function v468()
			if not u176 then
				u467.Ambient = Color3.new(0.5, 0.5, 0.5)
				u467.ColorShift_Bottom = Color3.new(0, 0, 0)
				u467.ColorShift_Top = Color3.new(0, 0, 0)

				return
			end

			u467.Ambient = Color3.new(1, 1, 1)
			u467.ColorShift_Bottom = Color3.new(1, 1, 1)
			u467.ColorShift_Top = Color3.new(1, 1, 1)
		end

		v468()
		Lighting.LightingChanged:Connect(v468)
	end)

	local v177 = v166:NewSection("> Server <")

	v177:NewButton("Server Hop", "?", function()
		local PlaceId = game.PlaceId
		local t20 = {}
		local s6 = ""
		local hour = os.date("!*t").hour

		if
			not pcall(function()
				local HttpService2 = game:GetService("HttpService")
				local v522 = (function(...)
					local t21 = { ... }

					t21.n = select("#", ...)

					return t21
				end)(readfile("NotSameServers.json"))

				t20 = HttpService2:JSONDecode(unpack(v522, 1, v522.n))
			end)
		then
			table.insert(t20, hour)
			writefile("NotSameServers.json", game:GetService("HttpService"):JSONEncode(t20))
		end

		local u475 = PlaceId

		function teleportReturner()
			local function v525(...)
				local t22 = { ... }

				t22.n = select("#", ...)

				return t22
			end

			local data

			if s6 ~= "" then
				local HttpService3 = game.HttpService
				local v527 = v525(game:HttpGet("https://games.roblox.com/v1/games/" .. u475 .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. s6))

				data = HttpService3:JSONDecode(unpack(v527, 1, v527.n))
			else
				local HttpService4 = game.HttpService
				local v544 = v525(game:HttpGet("https://games.roblox.com/v1/games/" .. u475 .. "/servers/Public?sortOrder=Asc&limit=100"))

				data = HttpService4:JSONDecode(unpack(v544, 1, v544.n))
			end

			local s7 = ""

			if data.nextPageCursor and data.nextPageCursor ~= "null" and data.nextPageCursor ~= nil then
				s6 = data.nextPageCursor
			end

			local n8 = 0

			for _, v in pairs(data.data) do
				local v563 = true
				local id = v.id

				s7 = tostring(id)

				local maxPlayers = v.maxPlayers
				local num = tonumber(maxPlayers)
				local playing = v.playing

				if num > tonumber(playing) then
					for _, v2 in pairs(t20) do
						if n8 == 0 then
							if tonumber(hour) ~= tonumber(v2) then
								pcall(function()
									delfile("NotSameServers.json")
									t20 = {}

									table.insert(t20, hour)
								end)
							end
						elseif s7 == tostring(v2) then
							v563 = false
						end

						n8 = n8 + 1
					end

					if v563 == true then
						table.insert(t20, s7)
						task.wait()
						pcall(function()
							writefile("NotSameServers.json", game:GetService("HttpService"):JSONEncode(t20))
							task.wait()
							game:GetService("TeleportService"):TeleportToPlaceInstance(u475, s7, game.Players.LocalPlayer)
						end)
						task.wait(4)
					end
				end
			end
		end
		function teleport()
			while task.wait() do
				pcall(function()
					teleportReturner()

					if s6 ~= "" then
						teleportReturner()
					end
				end)
			end
		end

		teleport()
	end)
	v177:NewButton("Rejoin Server", "?", function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, u12)
	end)

	local v178 = v166:NewSection("> Keybind <")
	local LeftControl = Enum.KeyCode.LeftControl
	local u180 = v47

	v178:NewKeybind("Close UI", "Toggle UI", LeftControl, function()
		u180:ToggleUI()
	end)

	local v181 = v48:NewTab("Credits")
	local v182 = v181:NewSection("Credits & Info")

	v182:NewLabel("Fact: This script will no longer receive updates.")
	v182:NewLabel("This is the final update.")
	v181:NewSection("Script Developed by: PinokioScripts Team"):NewDropdown("Developer", "Dev", {
		"Pinokio",
	}, function(p88)
		print(p88 .. " created PinokioScripts")
	end)
	v181:NewSection("UI Framework: Kavo.")
	v181:NewSection("Official Discord Channel"):NewButton("Copy Discord Link", "In case you lost the channel link", function()
		u14("https://discord.gg/t6rhaAZvhG")
		u10:SetCore("SendNotification", {
			Title = "PinokioScripts",
			Text = "Discord link copied to clipboard!",
			Duration = 4,
		})
	end)

	local ScreenGui2 = Instance.new("ScreenGui", u12:WaitForChild("PlayerGui"))
	local ImageLabel = Instance.new("ImageLabel", ScreenGui2)
	local TextButton = Instance.new("TextButton", ImageLabel)

	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Position = UDim2.new(0, 0, 0.65, -100)
	ImageLabel.Size = UDim2.new(0, 100, 0, 50)
	ImageLabel.Image = "rbxassetid://3570695787"
	ImageLabel.ImageColor3 = Color3.fromRGB(11, 18, 7)
	ImageLabel.ImageTransparency = 0.2
	ImageLabel.ScaleType = Enum.ScaleType.Slice
	ImageLabel.SliceCenter = Rect.new(100, 100, 100, 100)
	ImageLabel.SliceScale = 0.12
	TextButton.AnchorPoint = Vector2.new(0, 0.5)
	TextButton.BackgroundTransparency = 1
	TextButton.Position = UDim2.new(0.022, 0, 0.85, -20)
	TextButton.Size = UDim2.new(1, -10, 1, 0)
	TextButton.Font = Enum.Font.SourceSans
	TextButton.Text = "Toggle"
	TextButton.TextColor3 = Color3.fromRGB(0, 34, 255)
	TextButton.TextSize = 20
	TextButton.TextWrapped = true
	TextButton.ZIndex = 11

	local MouseButton1Down = TextButton.MouseButton1Down
	local u187 = v47

	MouseButton1Down:Connect(function()
		u187:ToggleUI()
	end)

	local u188 = false
	local p89Position = nil
	local Position = nil
	local InputBegan2 = TextButton.InputBegan
	local u193 = ImageLabel

	InputBegan2:Connect(function(p89)
		if p89.UserInputType == Enum.UserInputType.MouseButton1 then
			u188 = true
			p89Position = p89.Position
			Position = u193.Position
		end
	end)
	TextButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			u188 = false
		end
	end)

	local InputChanged = game:GetService("UserInputService").InputChanged
	local u195 = ImageLabel

	InputChanged:Connect(function(p90)
		if u188 and (p90.UserInputType == Enum.UserInputType.MouseMovement or p90.UserInputType == Enum.UserInputType.Touch) then
			local v482 = p90.Position - p89Position

			u195.Position = UDim2.new(Position.X.Scale, Position.X.Offset + v482.X, Position.Y.Scale, Position.Y.Offset + v482.Y)
		end
	end)
end

local u16 = LocalPlayer
local u17 = TweenService
local u18 = v6
local u19 = StarterGui
local u20 = HttpService
local u21 = v15

function u9()
	local PinokioKeySystem = u16:WaitForChild("PlayerGui"):FindFirstChild("PinokioKeySystem")

	if PinokioKeySystem then
		PinokioKeySystem:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "PinokioKeySystem"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = u16:WaitForChild("PlayerGui")

	local Frame = Instance.new("Frame")

	Frame.Name = "MainFrame"
	Frame.Size = UDim2.new(0, 0, 0, 0)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
	Frame.BackgroundTransparency = 0.35
	Frame.ClipsDescendants = true
	Frame.Parent = ScreenGui

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 14)
	UICorner.Parent = Frame

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Thickness = 2.5
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = Frame

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 80, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 40, 220)),
	})
	UIGradient.Parent = UIStroke

	local spawn = task.spawn
	local u203 = ScreenGui
	local u204 = UIGradient

	spawn(function()
		while u203 and u203.Parent do
			u204.Rotation = (u204.Rotation + 2) % 360
			task.wait(0.03)
		end
	end)

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "TitleLabel"
	TextLabel.Size = UDim2.new(1, 0, 0, 32)
	TextLabel.Position = UDim2.new(0, 0, 0, 10)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "PinokioScripts | Key Verification"
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 20
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Parent = Frame

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Name = "WarnLabel"
	TextLabel3.Size = UDim2.new(1, -20, 0, 18)
	TextLabel3.Position = UDim2.new(0, 10, 0, 42)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "âš \239\184\143 Note: Keys expire & reset every 6 hours!"
	TextLabel3.TextColor3 = Color3.fromRGB(255, 200, 100)
	TextLabel3.TextSize = 13
	TextLabel3.Font = Enum.Font.GothamMedium
	TextLabel3.Parent = Frame

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Name = "StatusLabel"
	TextLabel4.Size = UDim2.new(1, -40, 0, 18)
	TextLabel4.Position = UDim2.new(0, 20, 0, 62)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Text = "Enter key to access script:"
	TextLabel4.TextColor3 = Color3.fromRGB(210, 190, 235)
	TextLabel4.TextSize = 13
	TextLabel4.Font = Enum.Font.Gotham
	TextLabel4.Parent = Frame

	local TextBox = Instance.new("TextBox")

	TextBox.Name = "KeyBox"
	TextBox.Size = UDim2.new(1, -50, 0, 40)
	TextBox.Position = UDim2.new(0, 25, 0, 88)
	TextBox.BackgroundColor3 = Color3.fromRGB(45, 20, 65)
	TextBox.BackgroundTransparency = 0.5
	TextBox.PlaceholderText = "Type key here..."
	TextBox.PlaceholderColor3 = Color3.fromRGB(160, 140, 185)
	TextBox.Text = ""
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextSize = 15
	TextBox.Font = Enum.Font.Gotham
	TextBox.ClearTextOnFocus = false
	TextBox.Parent = Frame

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 8)
	UICorner2.Parent = TextBox

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Thickness = 1.5
	UIStroke2.Color = Color3.fromRGB(180, 100, 240)
	UIStroke2.Parent = TextBox

	local TextButton = Instance.new("TextButton")

	TextButton.Name = "VerifyBtn"
	TextButton.Size = UDim2.new(0.42, 0, 0, 38)
	TextButton.Position = UDim2.new(0.06, 0, 0, 140)
	TextButton.BackgroundColor3 = Color3.fromRGB(120, 50, 190)
	TextButton.BackgroundTransparency = 0.55
	TextButton.Text = "Verify"
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.TextSize = 15
	TextButton.Font = Enum.Font.GothamBold
	TextButton.Parent = Frame

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(0, 8)
	UICorner3.Parent = TextButton

	local UIStroke3 = Instance.new("UIStroke")

	UIStroke3.Thickness = 1.5
	UIStroke3.Color = Color3.fromRGB(210, 150, 255)
	UIStroke3.Parent = TextButton

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Name = "DiscordBtn"
	TextButton2.Size = UDim2.new(0.42, 0, 0, 38)
	TextButton2.Position = UDim2.new(0.52, 0, 0, 140)
	TextButton2.BackgroundColor3 = Color3.fromRGB(120, 50, 190)
	TextButton2.BackgroundTransparency = 0.55
	TextButton2.Text = "Get Discord Link"
	TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton2.TextSize = 13
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.Parent = Frame

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 8)
	UICorner4.Parent = TextButton2

	local UIStroke4 = Instance.new("UIStroke")

	UIStroke4.Thickness = 1.5
	UIStroke4.Color = Color3.fromRGB(210, 150, 255)
	UIStroke4.Parent = TextButton2
	u17:Create(Frame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 380, 0, 198),
	}):Play()

	local u217 = Frame
	local u218 = ScreenGui

	local function u219(p91)
		local v484 = u17:Create(u217, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
		})

		v484:Play()

		local Completed = v484.Completed
		local u486 = p91

		Completed:Connect(function()
			u218:Destroy()

			if u486 then
				u486()
			end
		end)
	end

	local MouseButton1Click = TextButton2.MouseButton1Click
	local u221 = TextLabel4

	MouseButton1Click:Connect(function()
		u18("https://discord.gg/t6rhaAZvhG")
		u221.Text = "Discord link copied to clipboard!"
		u221.TextColor3 = Color3.fromRGB(120, 255, 170)
		u19:SetCore("SendNotification", {
			Title = "PinokioScripts",
			Text = "Discord link copied to clipboard!",
			Duration = 4,
		})
	end)

	local MouseButton1Click2 = TextButton.MouseButton1Click
	local u223 = TextLabel4

	MouseButton1Click2:Connect(function()
		if TextBox.Text ~= "ArSinalwPinakEE" then
			u223.Text = "Invalid Key! Try again."
			u223.TextColor3 = Color3.fromRGB(255, 100, 100)

			return
		end

		pcall(function()
			if writefile then
				local t23 = {
					Key = "ArSinalwPinakEE",
					Timestamp = os.time(),
				}

				writefile("PinokioKeySession.json", u20:JSONEncode(t23))
			end
		end)
		u223.Text = "Key Accepted! Loading..."
		u223.TextColor3 = Color3.fromRGB(120, 255, 140)
		task.wait(0.5)
		u219(function()
			u21()
		end)
	end)
end
local u22
local u24 = HttpService

pcall(function()
	if readfile and isfile and isfile("PinokioKeySession.json") then
		local v224 = readfile("PinokioKeySession.json")
		local data = u24:JSONDecode(v224)

		if data and data.Key == "ArSinalwPinakEE" and data.Timestamp then
			if os.time() - data.Timestamp < 21600 then
				u22 = true

				return
			end

			pcall(function()
				if delfile and isfile and isfile("PinokioKeySession.json") then
					delfile("PinokioKeySession.json")
				end
			end)
		end
	end
end)

if true then
	u9()
else
	StarterGui:SetCore("SendNotification", {
		Title = "PinokioScripts",
		Text = "Key session auto-verified! Loading script...",
		Duration = 4,
	})
	v15()
end