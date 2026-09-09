-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
local v3 = unpack or table.unpack
game:IsLoaded()
repeat
    task.wait()
    t1.value1 = game:IsLoaded()
until t1.value1
t1.value1 = game
t1.value1 = t1.value1:GetService("Players")
t2.value1 = t1.value1
t1.value1 = game:GetService("RunService")
t2.value2 = t1.value1
t1.value1 = game:GetService("TweenService")
t2.value3 = t1.value1
t1.value1 = game:GetService("UserInputService")
t2.value4 = t1.value1
t2.value5 = game:GetService("HttpService")
t2.value6 = t2.value1.LocalPlayer
do
    local value6 = t2.value6

    t1.value1 = value6.WaitForChild
    t1.value1 = t1.value1(value6, "PlayerGui")
end
t2.value7 = t1.value1
function t2.value8(...)
    return select(2, pcall(...))
end
function t2.value9(...)
    return pcall(...)
end
function t2.value10(p1)
    if not p1 then
        return
    end

    for _, descendant in ipairs(p1:GetDescendants()) do
        local v192 = descendant

        if v192:IsA("BasePart") then
            pcall(function()
                v192.CanCollide = false
            end)
        end
    end
end
pcall(function()
    for _, player in ipairs(t2.value1:GetPlayers()) do
        if player ~= t2.value6 and player.Character then
            t2.value10(player.Character)
        end
    end

    t2.value1.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            task.wait(0.15)
            t2.value10(character)
        end)

        if player.Character then
            t2.value10(player.Character)
        end
    end)
    t2.value2.Heartbeat:Connect(function()
        for _, player in ipairs(t2.value1:GetPlayers()) do
            if player ~= t2.value6 and player.Character then
                for _, child in ipairs(player.Character:GetChildren()) do
                    if child:IsA("BasePart") and child.CanCollide then
                        child.CanCollide = false
                    end
                end
            end
        end
    end)
end)
t2.value11 = 160
t2.value12 = 45
t2.value13 = 95
t2.value14 = 20
function t2.value15(p2, p3, p4, p5)
    if not p2 or not p2.Parent then
        return
    end

    pcall(function()
        local AssemblyLinearVelocity = p2.AssemblyLinearVelocity
        local Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude

        if Magnitude > p4 then
            local v1038 = p4 / Magnitude

            p2.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X * v1038, AssemblyLinearVelocity.Y, AssemblyLinearVelocity.Z * v1038)
        elseif AssemblyLinearVelocity.Magnitude > p4 * 1.35 then
            p2.AssemblyLinearVelocity = AssemblyLinearVelocity.Unit * p4
        end

        if p2.AssemblyAngularVelocity.Magnitude > p5 then
            p2.AssemblyAngularVelocity = Vector3.zero
        end

        if p3 then
            for _, child in ipairs(p3:GetChildren()) do
                local v1041 = child:IsA("BasePart")

                if v1041 then
                    v1041 = child ~= p2
                end

                if v1041 then
                    local AssemblyLinearVelocity2 = child.AssemblyLinearVelocity
                    local vector3 = Vector3.new(AssemblyLinearVelocity2.X, 0, AssemblyLinearVelocity2.Z)

                    if vector3.Magnitude > p4 * 1.2 then
                        local v1044 = p4 * 1.05 / vector3.Magnitude

                        child.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity2.X * v1044, AssemblyLinearVelocity2.Y, AssemblyLinearVelocity2.Z * v1044)
                    end

                    if child.AssemblyAngularVelocity.Magnitude > p5 then
                        child.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
        end
    end)
end
do
    local Heartbeat = t2.value2.Heartbeat

    function t1.value1()
        local Character = t2.value6.Character

        if not Character then
            return
        end

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            return
        end

        local v197 = State and State.autoBatToggled or State.tpBatEnabled
        local v198 = v197 and t2.value13 or t2.value11
        local v199 = v197 and t2.value14 or t2.value12

        t2.value15(HumanoidRootPart, Character, v198, v199)
    end

    Heartbeat:Connect(t1.value1)
end
do
    local function v6(p6)
        local v201 = p6 or t2.value6.Character

        if not v201 then
            return
        end

        local Humanoid = v201:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = v201:FindFirstChild("HumanoidRootPart")

        pcall(function()
            if Humanoid then
                Humanoid.PlatformStand = false
                Humanoid.Sit = false
                Humanoid.AutoRotate = true

                if Humanoid.WalkSpeed and Humanoid.WalkSpeed < 16 then
                    Humanoid.WalkSpeed = 16
                end

                if Humanoid.JumpPower and Humanoid.JumpPower <= 0 then
                    Humanoid.JumpPower = 50
                end

                if Humanoid.JumpHeight and Humanoid.JumpHeight <= 0 then
                    Humanoid.JumpHeight = 7.2
                end

                local State2 = Humanoid:GetState()
                local v1051 = State2 == Enum.HumanoidStateType.Physics

                if not v1051 then
                    v1051 = State2 == Enum.HumanoidStateType.Ragdoll or (State2 == Enum.HumanoidStateType.FallingDown or State2 == Enum.HumanoidStateType.GettingUp)
                end

                if v1051 then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
            for v1054, v1055 in ipairs(v201:GetDescendants()) do

                if v1055:IsA("BasePart") then
                    v1055.Anchored = false

                    if v1055.AssemblyAngularVelocity.Magnitude > 1 then
                        v1055.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
            if HumanoidRootPart then
                HumanoidRootPart.Anchored = false
                HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end

    function t1.value1(p7)
        v6(p7)
        task.spawn(function()
            for _ = 1, 12 do
                task.wait(0.08)
                v6(t2.value6.Character)
            end
        end)
    end
end
t2.value16 = t1.value1
t1.value1 = t2.value6.CharacterAdded
t1.value1:Connect(function(p8)
    task.spawn(function()
        t2.value16(p8)
    end)
end)
if t2.value6.Character then
    task.spawn(function()
        t2.value16(t2.value6.Character)
    end)
end
t2.value17 = Color3.fromRGB(11, 9, 18)
t2.value18 = Color3.fromRGB(16, 14, 26)
t2.value19 = Color3.fromRGB(255, 255, 255)
t2.value20 = Color3.fromRGB(165, 160, 185)
t2.value21 = Color3.fromRGB(46, 204, 113)
t2.value22 = Color3.fromRGB(12, 10, 20)
t2.value23 = Color3.fromRGB(220, 220, 235)
do
    local v12

    do
        local new = ColorSequence.new

        t1.value1 = ColorSequenceKeypoint.new

        do
            local t3 = { Color3.fromRGB(70, 50, 110) }

            t1.value1 = t1.value1(0, v3(t3))
        end

        local colorSequenceKeypoint = ColorSequenceKeypoint.new(0.25, Color3.fromRGB(35, 30, 55))
        local colorSequenceKeypoint2 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(70, 50, 110))
        local colorSequenceKeypoint3 = ColorSequenceKeypoint.new(0.75, Color3.fromRGB(30, 25, 50))

        v12 = new({
			t1.value1,
			colorSequenceKeypoint,
			colorSequenceKeypoint2,
			colorSequenceKeypoint3,
			ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 50, 110))
		})
    end

    t1.value1 = NumberSequence.new

    local numberSequenceKeypoint = NumberSequenceKeypoint.new(0, 0.88, 0)
    local numberSequenceKeypoint2 = NumberSequenceKeypoint.new(0.25, 0.6, 0)
    local numberSequenceKeypoint3 = NumberSequenceKeypoint.new(0.5, 0.3, 0)
    local numberSequenceKeypoint4 = NumberSequenceKeypoint.new(0.75, 0.65, 0)
    local v17 = t1.value1({
		numberSequenceKeypoint,
		numberSequenceKeypoint2,
		numberSequenceKeypoint3,
		numberSequenceKeypoint4,
		NumberSequenceKeypoint.new(1, 0.88, 0)
	})

    t2.value24 = {
		Color = v12,
		Rotation = 135,
		Transparency = v17
	}
end
t2.value25 = "rbxassetid://110499809323243"
t2.value26 = "rbxassetid://138799625480080"
t2.value27 = "HyperionVSConfig.json"
t2.value28 = {
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
	"Glitched Slap"
}
do
    local Unknown = Enum.KeyCode.Unknown

    t1.value1 = Enum.KeyCode.Unknown

    local Unknown2 = Enum.KeyCode.Unknown
    local Unknown3 = Enum.KeyCode.Unknown
    local Unknown4 = Enum.KeyCode.Unknown
    local Unknown5 = Enum.KeyCode.Unknown
    local Unknown6 = Enum.KeyCode.Unknown
    local Unknown7 = Enum.KeyCode.Unknown
    local Unknown8 = Enum.KeyCode.Unknown
    local Unknown9 = Enum.KeyCode.Unknown
    local Unknown10 = Enum.KeyCode.Unknown
    local Unknown11 = Enum.KeyCode.Unknown
    local Unknown12 = Enum.KeyCode.Unknown
    local Unknown13 = Enum.KeyCode.Unknown
    local Unknown14 = Enum.KeyCode.Unknown
    local Unknown15 = Enum.KeyCode.Unknown
    local Unknown16 = Enum.KeyCode.Unknown
    local Unknown17 = Enum.KeyCode.Unknown

    t2.value29 = {
		normalSpeed = 60,
		carrySpeed = 30,
		laggerSpeed = 15,
		speedType = "normal",
		laggerActive = false,
		safeMode = false,
		autoLeftEnabled = false,
		autoRightEnabled = false,
		infJumpEnabled = false,
		infJumpMode = "manual",
		antiRagdollEnabled = false,
		medusaCounterEnabled = false,
		medusaResetEnabled = false,
		antiDieEnabled = false,
		unwalkEnabled = false,
		autoTpDownEnabled = false,
		autoTpDownY = 8,
		batCounterEnabled = false,
		introEnabled = true,
		guiScale = 0.6,
		tpBatEnabled = false,
		tpBatSideOffset = 2.15,
		autoSwingEnabled = true,
		medusaLastUsed = 0,
		medusaDebounce = false,
		dropBrainrotActive = false,
		mirrorTPDownEnabled = false,
		stealBarEnabled = true,
		speedESPEnabled = false,
		guiLocked = false,
		fov = 70,
		musicSpeed = 1,
		keyAutoLeft = Unknown,
		keyAutoRight = t1.value1,
		keyDropBR = Unknown2,
		keyTpDown = Unknown3,
		keyCarrySpeed = Unknown4,
		keyLagger = Unknown5,
		keyAutoGrab = Unknown6,
		keyInfJump = Unknown7,
		keyAutoTpDown = Unknown8,
		keyAntiRag = Unknown9,
		keyMedusaCounter = Unknown10,
		keyMedusaReset = Unknown11,
		keyAntiDie = Unknown12,
		keyUnwalk = Unknown13,
		keyBatCounter = Unknown14,
		keyInstantReset = Unknown15,
		keySafeMode = Unknown16,
		hittingCooldown = false,
		batAimbotSpeed = 60,
		batAimbotMode = "v1",
		autoBatToggled = false,
		aimbotTpDownSpam = false,
		_tpInProgress = false,
		animEnabled = false,
		keyAutoBat = Unknown17
	}
end
t1.value1 = {
	active = false,
	startTime = 0,
	phase = "idle",
	label = ""
}
t2.value30 = {
	Enabled = true,
	Mode = "Semi",
	Radius = 12,
	SemiHoldMin = 1.3,
	SemiHoldMax = 2.6,
	SemiEntryDelay = 0.3,
	SemiCooldown = 0.05,
	Cooldown = 0.08,
	LastSteal = 0,
	SemiState = t1.value1,
	Data = {},
	ProgressFill = nil,
	ProgressText = nil,
	Progress = 0,
	ProgressStatus = "SEARCHING"
}
t1.value1 = {}
t2.value31 = {
	Visible = true,
	Locked = false,
	Frame = nil,
	Containers = t1.value1,
	Buttons = {}
}
function t1.value1(p9, p10)

    for v210, v211 in pairs(p10) do

        if v210 ~= "Parent" then
            p9[v210] = v211
        end
    end
    if p10.Parent then
        p9.Parent = p10.Parent
    end

    return p9
end
t2.value32 = {}
t2.value33 = nil
t2.value34 = {}
t2.value33 = 0
t2.value35 = nil
function t2.value36()
    t2.value33 = t2.value33 + 1

    return t2.value33
end
t2.value37 = t1.value1
function t1.value1(p11, p12)
    return t2.value37(Instance.new(p11), p12)
end
t2.value38 = t1.value1
function t2.value39(p13, p14, p15, p16)
    local value3 = t2.value3
    local new = TweenInfo.new

    if not p16 then
        p16 = Enum.EasingStyle.Quad
    end

    value3:Create(p13, new(p14, p16, Enum.EasingDirection.Out), p15):Play()
end
function t2.value40(p17)
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = t2.value24.Color
    UIGradient.Rotation = t2.value24.Rotation
    UIGradient.Transparency = t2.value24.Transparency
    UIGradient.Parent = p17

    return UIGradient
end
local v36, v37, v38, v39, v40, v41, v50, v51, v52, v53, v55, v56, v58, v59, v61, v68
local v132, v133, v134, v155, v156
do
    local v111, v131

    do
        local function v35(p18, p19)
            local UIStroke = Instance.new("UIStroke")

            UIStroke.Thickness = p19 or 1.5
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Color = t2.value19
            UIStroke.Parent = p18

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(0.25, Color3.fromRGB(80, 80, 80)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 80, 80)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
			})
            UIGradient.Parent = UIStroke
            table.insert(t2.value34, UIGradient)

            return UIStroke
        end

        task.spawn(function()
            while true do
                t2.value2.Heartbeat:Wait()

                for _, v in ipairs(t2.value34) do
                    if v and v.Parent then
                        v.Rotation = (v.Rotation + 2) % 360
                    end
                end
            end
        end)

        function t1.value1(p20, p21)
            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, p21 or 7),
				Parent = p20
			})

            local value38 = t2.value38
            local value19 = t2.value19
            local Border = Enum.ApplyStrokeMode.Border
            local v240 = value38("UIStroke", {
				Color = value19,
				ApplyStrokeMode = Border,
				Parent = p20
			})

            t2.value40(v240)

            return v240
        end
        function t2.value41(p22, p23)
            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 9),
				Parent = p22
			})

            local value38 = t2.value38
            local value19 = t2.value19
            local v232 = p23 or 1.25
            local Border = Enum.ApplyStrokeMode.Border
            local v234 = value38("UIStroke", {
				Color = value19,
				Thickness = v232,
				ApplyStrokeMode = Border,
				Parent = p22
			})

            t2.value40(v234)

            return v234
        end

        t2.value42 = t1.value1

        function t2.value43(p24, p25, p26)
            local value38 = t2.value38
            local uDim2 = UDim2.new(0, 12, 0, 0)
            local uDim2_2 = UDim2.new(1, -132, 1, 0)
            local value19 = t2.value19
            local v248 = p26 or 13
            local GothamMedium = Enum.Font.GothamMedium
            local Left = Enum.TextXAlignment.Left

            return value38("TextLabel", {
				ZIndex = 4,
				Position = uDim2,
				Size = uDim2_2,
				BackgroundTransparency = 1,
				Text = p25,
				TextColor3 = value19,
				TextSize = v248,
				Font = GothamMedium,
				TextXAlignment = Left,
				Parent = p24
			})
        end
        function t2.value44(p27, p28)
            local value38 = t2.value38
            local uDim2 = UDim2.new(1, -4, 0, 34)
            local value17 = t2.value17
            local v256 = t2.value36()

            return (value38("Frame", {
				Name = p27,
				ZIndex = 3,
				Size = uDim2,
				BackgroundColor3 = value17,
				BackgroundTransparency = 0.3,
				BorderSizePixel = 0,
				LayoutOrder = v256,
				Active = true,
				Parent = p28
			}))
        end
        function v36(p29, p30, p31)
            local v260 = t2.value44(p29, p31)

            t2.value41(v260)
            t2.value43(v260, p30)

            local value38 = t2.value38
            local uDim2 = UDim2.new(1, 0, 1, 0)

            value38("TextButton", {
				Name = "ActionClick",
				ZIndex = 200,
				Size = uDim2,
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				Parent = v260
			})

            return v260
        end
        function v37(p32, p33, p34, p35)
            local v267 = t2.value44(p32, p35)

            t2.value41(v267)
            t2.value43(v267, p33)

            local value38 = t2.value38
            local uDim2 = UDim2.new(1, -68, 0.5, -12)
            local uDim2_3 = UDim2.new(0, 58, 0, 24)
            local value18 = t2.value18
            local str = tostring(p34)
            local value19 = t2.value19
            local GothamMedium = Enum.Font.GothamMedium
            local v275 = value38("TextBox", {
				Name = "ValueBox",
				ZIndex = 25,
				Position = uDim2,
				Size = uDim2_3,
				BackgroundColor3 = value18,
				BackgroundTransparency = 0.18,
				BorderSizePixel = 0,
				Text = str,
				TextColor3 = value19,
				TextSize = 12,
				Font = GothamMedium,
				ClearTextOnFocus = false,
				Parent = v267
			})

            t2.value42(v275)

            return v267, v275
        end
        function v38(p36, p37, p38)
            local value38 = t2.value38
            local v280 = "Section_" .. p36
            local uDim2 = UDim2.new(1, -6, 0, 20)
            local v282 = t2.value36()
            local v283 = value38("Frame", {
				Name = v280,
				ZIndex = 4,
				Size = uDim2,
				BackgroundTransparency = 1,
				LayoutOrder = v282,
				Parent = p38
			})
            local value38_2 = t2.value38
            local uDim2_4 = UDim2.new(0, 3, 0, 12)
            local uDim2_5 = UDim2.new(0, 2, 0.5, -6)
            local color3 = Color3.fromRGB(0, 230, 255)
            local v288 = value38_2("Frame", {
				Name = "Indicator",
				ZIndex = 5,
				Size = uDim2_4,
				Position = uDim2_5,
				BackgroundColor3 = color3,
				BorderSizePixel = 0,
				Parent = v283
			})

            t2.value38("UICorner", {
				CornerRadius = UDim.new(1, 0),
				Parent = v288
			})

            local value38_3 = t2.value38
            local uDim2_6 = UDim2.new(0, 140, 1, 0)
            local uDim2_7 = UDim2.new(0, 10, 0, 0)
            local value19 = t2.value19
            local GothamBlack = Enum.Font.GothamBlack
            local Left = Enum.TextXAlignment.Left

            value38_3("TextLabel", {
				Name = "Label",
				ZIndex = 5,
				Size = uDim2_6,
				Position = uDim2_7,
				BackgroundTransparency = 1,
				Text = p37,
				TextColor3 = value19,
				TextSize = 11,
				Font = GothamBlack,
				TextXAlignment = Left,
				Parent = v283
			})

            local value38_4 = t2.value38
            local uDim2_8 = UDim2.new(1, -155, 0, 1)
            local uDim2_9 = UDim2.new(0, 150, 0.5, 0)
            local color3_2 = Color3.fromRGB(55, 45, 80)
            local v299 = value38_4("Frame", {
				Name = "Divider",
				ZIndex = 5,
				Size = uDim2_8,
				Position = uDim2_9,
				BackgroundColor3 = color3_2,
				BorderSizePixel = 0,
				Parent = v283
			})
            local UIGradient = Instance.new("UIGradient", v299)

            UIGradient.Color = ColorSequence.new(Color3.fromRGB(0, 230, 255))
            UIGradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.3),
				NumberSequenceKeypoint.new(1, 1)
			})

            return v283
        end
        function t1.value1(p39, p40, p41)
            local value38 = t2.value38
            local uDim2 = UDim2.new(1, -4, 0, 44)
            local value17 = t2.value17
            local v307 = t2.value36()
            local v308 = value38("Frame", {
				Name = p39,
				ZIndex = 3,
				Size = uDim2,
				BackgroundColor3 = value17,
				BackgroundTransparency = 0.3,
				BorderSizePixel = 0,
				LayoutOrder = v307,
				Active = true,
				Parent = p41
			})

            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 9),
				Parent = v308
			})

            local value38_5 = t2.value38
            local value19 = t2.value19
            local Border = Enum.ApplyStrokeMode.Border
            local v312 = value38_5("UIStroke", {
				Color = value19,
				Thickness = 1.25,
				ApplyStrokeMode = Border,
				Parent = v308
			})

            t2.value40(v312)

            local value38_6 = t2.value38
            local uDim2_10 = UDim2.new(1, 0, 1, 0)
            local value19_2 = t2.value19
            local GothamBlack = Enum.Font.GothamBlack
            local Center = Enum.TextXAlignment.Center
            local Center2 = Enum.TextYAlignment.Center

            value38_6("TextLabel", {
				Name = "BigLabel",
				ZIndex = 4,
				Size = uDim2_10,
				BackgroundTransparency = 1,
				Text = p40,
				TextColor3 = value19_2,
				TextSize = 17,
				Font = GothamBlack,
				TextXAlignment = Center,
				TextYAlignment = Center2,
				Parent = v308
			})

            local value38_7 = t2.value38
            local uDim2_11 = UDim2.new(1, 0, 1, 0)

            value38_7("TextButton", {
				Name = "BigClick",
				ZIndex = 200,
				Size = uDim2_11,
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				Parent = v308
			})

            return v308
        end
        function v39(p42, p43, p44)
            local v324 = t2.value44(p42, p44)

            t2.value41(v324)
            t2.value43(v324, p43)

            local value38 = t2.value38
            local uDim2 = UDim2.new(1, -54, 0, 0)
            local uDim2_12 = UDim2.new(0, 54, 1, 0)
            local v328 = value38("TextButton", {
				Name = "ToggleArea",
				Position = uDim2,
				Size = uDim2_12,
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 10,
				Parent = v324
			})
            local value38_8 = t2.value38
            local uDim2_13 = UDim2.new(0.5, -17, 0.5, -9)
            local uDim2_14 = UDim2.new(0, 34, 0, 18)
            local v332 = value38_8("Frame", {
				Name = "ToggleTrack",
				ZIndex = 5,
				Position = uDim2_13,
				Size = uDim2_14,
				BackgroundColor3 = t2.value19,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				Parent = v328
			})

            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 9),
				Parent = v332
			})

            local value40 = t2.value40
            local value38_9 = t2.value38
            local value19 = t2.value19
            local Border = Enum.ApplyStrokeMode.Border

            value40(value38_9("UIStroke", {
				Color = value19,
				ApplyStrokeMode = Border,
				Parent = v332
			}))

            local value38_10 = t2.value38
            local uDim2_15 = UDim2.new(0, 3, 0.5, -6)
            local uDim2_16 = UDim2.new(0, 13, 0, 13)
            local v340 = value38_10("Frame", {
				Name = "ToggleKnob",
				ZIndex = 6,
				Position = uDim2_15,
				Size = uDim2_16,
				BackgroundColor3 = t2.value17,
				BorderSizePixel = 0,
				Parent = v332
			})

            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 7),
				Parent = v340
			})

            local value38_11 = t2.value38
            local uDim2_17 = UDim2.new(0, 2, 0, 2)
            local uDim2_18 = UDim2.new(1, -4, 0, 4)
            local v344 = value38_11("Frame", {
				Name = "KnobShine",
				ZIndex = 7,
				Position = uDim2_17,
				Size = uDim2_18,
				BackgroundColor3 = t2.value19,
				BackgroundTransparency = 0.72,
				BorderSizePixel = 0,
				Parent = v340
			})

            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 4),
				Parent = v344
			})

            local value38_12 = t2.value38
            local uDim2_19 = UDim2.new(1, 0, 1, 0)

            value38_12("TextButton", {
				Name = "ToggleClick",
				ZIndex = 100,
				Size = uDim2_19,
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				Parent = v328
			})

            return v324
        end
        function v40(p45, p46)
            if not p45 then
                return
            end

            local ToggleArea = p45:FindFirstChild("ToggleArea")

            if not ToggleArea then
                return
            end

            local ToggleTrack = ToggleArea:FindFirstChild("ToggleTrack")

            if not ToggleTrack then
                return
            end

            local ToggleKnob = ToggleTrack:FindFirstChild("ToggleKnob")

            if not ToggleKnob then
                return
            end

            if p46 then
                ToggleTrack.BackgroundTransparency = 0
                ToggleTrack.BackgroundColor3 = t2.value21
                t2.value39(ToggleKnob, 0.12, {
					Position = UDim2.new(1, -16, 0.5, -6)
				})
            else
                ToggleTrack.BackgroundTransparency = 0.2
                ToggleTrack.BackgroundColor3 = t2.value19
                t2.value39(ToggleKnob, 0.12, {
					Position = UDim2.new(0, 3, 0.5, -6)
				})
            end

            t2.value32[p45] = p46
        end
        function v41(p47, p48, p49, p50)
            local v369 = t2.value44(p47, p50)
            t2.value41(v369)
            t2.value43(v369, p48, 11)
            local value38 = t2.value38
            local uDim2 = UDim2.new(1, -82, 0.5, -12)
            local uDim2_20 = UDim2.new(0, 72, 0, 24)
            local value18 = t2.value18
            local v374 = t2.value29[p49] and (t2.value29[p49] ~= Enum.KeyCode.Unknown and t2.value29[p49].Name) or "?"
            local value19 = t2.value19
            local GothamBold = Enum.Font.GothamBold
            local v377 = value38("TextButton", {
				Name = "KeybindBtn",
				ZIndex = 7,
				Position = uDim2,
				Size = uDim2_20,
				BackgroundColor3 = value18,
				BackgroundTransparency = 0.18,
				BorderSizePixel = 0,
				Text = v374,
				TextColor3 = value19,
				TextSize = 10,
				Font = GothamBold,
				AutoButtonColor = false,
				Parent = v369
			})
            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 7),
				Parent = v377
			})
            t2.value42(v377, 7)
            local function v378()
                local v1057 = t2.value29[p49]
                local v1058 = v377
                local v1059 = v1057

                if v1057 then
                    v1059 = v1057 ~= Enum.KeyCode.Unknown
                end

                v1058.Text = v1059 and v1057.Name or "?"
            end
            local u379 = false
            local u380
            v377.MouseButton1Click:Connect(function()
                if u379 then
                    u379 = false

                    if u380 then
                        u380:Disconnect()
                        u380 = nil
                    end

                    v378()

                    return
                end

                u379 = true
                v377.Text = "..."
                u380 = t2.value4.InputBegan:Connect(function(input, gameProcessed)
                    if not u379 then
                        return
                    end

                    if gameProcessed then
                        return
                    end

                    local v1498 = input.UserInputType ~= Enum.UserInputType.Keyboard

                    if v1498 then
                        v1498 = input.UserInputType ~= Enum.UserInputType.Gamepad1

                        if v1498 then
                            v1498 = input.UserInputType ~= Enum.UserInputType.Gamepad2 and (input.UserInputType ~= Enum.UserInputType.Gamepad3 and input.UserInputType ~= Enum.UserInputType.Gamepad4)
                        end
                    end

                    if v1498 then
                        return
                    end

                    if input.KeyCode == Enum.KeyCode.Unknown then
                        return
                    end

                    if u380 then
                        u380:Disconnect()
                        u380 = nil
                    end

                    if input.KeyCode == Enum.KeyCode.Escape then
                        v378()

                        return
                    end

                    t2.value29[p49] = input.KeyCode
                    v378()
                    t2.value35()
                end)
            end)

            return v369
        end

        t2.value45 = nil
        t2.value46 = nil
        t2.value47 = nil

        function t2.value48()
            return false
        end
        function t2.value49()
            return true
        end

        t2.value50 = nil
        t2.value51 = 0
        t2.value52 = {
			active = false,
			overlay = nil,
			label = nil,
			disabledPrompts = {},
			promptsScanned = false,
			promptAddedConn = nil
		}

        function t2.value53()
            local ok, result = pcall(function()
                local PlayerGui = t2.value6:FindFirstChild("PlayerGui")

                if not PlayerGui then
                    return nil
                end

                local DuelsMachineTopFrame = PlayerGui:FindFirstChild("DuelsMachineTopFrame", true)

                if not DuelsMachineTopFrame then
                    return nil
                end

                local Timer = DuelsMachineTopFrame:FindFirstChild("Timer", true)

                if not Timer then
                    return nil
                end

                return Timer:FindFirstChild("Label", true) or Timer:FindFirstChildWhichIsA("TextLabel", true)
            end)

            return ok and result or nil
        end
        function t2.value54(p51)
            local _tostring = tostring

            if not p51 then
                p51 = ""
            end

            local v383 = _tostring(p51):upper():gsub("^%s+", ""):gsub("%s+$", "")

            if v383 == "GO" or (v383 == "GO!" or (v383 == "START" or v383 == "START!")) then
                return nil
            end

            if v383:find(":", 1, true) then
                return nil
            end

            local num = tonumber(v383)

            if not num then
                for match in v383:gmatch("%d+%.?%d*") do
                    num = tonumber(match)
                end
            end

            if num ~= nil and (num >= 0 and num <= 5) then
                return num
            end

            return nil
        end
        function t2.value55()
            local Character = t2.value6.Character

            if not Character then
                return false
            end

            local ok, result = pcall(function()
                return t2.value6:GetAttribute("Stealing")
            end)

            if ok then
                ok = result == true
            end

            if ok then
                return true
            end

            local ok2, result2 = pcall(function()
                return t2.value6:GetAttribute("AntiKick")
            end)

            if ok2 then
                ok2 = result2 == true
            end

            if ok2 then
                return true
            end

            local ok3, result3 = pcall(function()
                return Character:GetAttribute("Stealing")
            end)

            if ok3 then
                ok3 = result3 == true
            end

            if ok3 then
                return true
            end

            for _, child in ipairs(Character:GetChildren()) do
                if not (child:IsA("Tool") or child:IsA("Model")) then
                    continue
                end

                local v398 = child.Name:lower()
                local v399 = v398:find("brainrot", 1, true)

                if not v399 then
                    v399 = v398:find("skibidi", 1, true)

                    if not v399 then
                        v399 = v398:find("toilet", 1, true)

                        if not v399 then
                            v399 = v398:find("animal", 1, true) or (v398:find("carry", 1, true) or v398:find("grab", 1, true))
                        end
                    end
                end

                if v399 then
                    return true
                end
            end

            return false
        end
        function t2.value56()
            local v401 = false

            if t2.value29.safeMode == true then
                local v402 = t2.value53()

                v401 = v402 ~= nil and t2.value54(v402.Text) ~= nil
            end

            return v401
        end
        function t2.value57()
            return t2.value55()
        end
        function t2.value58(p52)
            if p52:IsA("ProximityPrompt") and p52.Enabled then
                if t2.value52.disabledPrompts[p52] == nil then
                    t2.value52.disabledPrompts[p52] = true
                end

                p52.Enabled = false
            end
        end
        function t2.value59(p53)
            pcall(function()
                local v1063 = t2.value7:FindFirstChild("HyperionVSButtons") or game:GetService("CoreGui"):FindFirstChild("HyperionVSButtons")

                if v1063 then
                    local ButtonPanel = v1063:FindFirstChild("ButtonPanel")

                    if ButtonPanel then
                        local GetChildren = ButtonPanel.GetChildren

                        for _, v in ipairs(GetChildren(ButtonPanel)) do
                            if v:IsA("Frame") and v:FindFirstChild("BtnBgImage") then
                                v.BackgroundTransparency = not p53 and 0.15 or 0.55
                            end
                        end
                    end
                end
            end)
        end

        do
            local function v42()
                t2.value59(true)

                if not t2.value52.promptsScanned then
                    t2.value52.promptsScanned = true

                    for _, descendant in ipairs(workspace:GetDescendants()) do
                        t2.value58(descendant)
                    end

                    t2.value52.promptAddedConn = workspace.DescendantAdded:Connect(function(descendant)
                        if t2.value52.active then
                            t2.value58(descendant)
                        end
                    end)
                end

                for k in pairs(t2.value52.disabledPrompts) do
                    local v410 = k

                    if v410 and (v410.Parent and v410.Enabled) then
                        v410.Enabled = false
                    end
                end
            end

            function t2.value60()
                t2.value59(false)

                for k, v in pairs(t2.value52.disabledPrompts) do
                    if k and k.Parent then
                        pcall(function()
                            k.Enabled = v
                        end)
                    end
                end

                t2.value52.disabledPrompts = {}
                t2.value52.promptsScanned = false

                if t2.value52.promptAddedConn then
                    t2.value52.promptAddedConn:Disconnect()
                    t2.value52.promptAddedConn = nil
                end
            end

            t2.value61 = nil

            function t2.value61()
                if t2.value52.overlay and (t2.value52.overlay.Parent and t2.value52.label) then
                    return t2.value52.overlay, t2.value52.label
                end

                pcall(function()
                    local HyperionSafeModeLock = game:GetService("CoreGui"):FindFirstChild("HyperionSafeModeLock")

                    if HyperionSafeModeLock then
                        HyperionSafeModeLock:Destroy()
                    end

                    local HyperionSafeModeLock2 = t2.value7:FindFirstChild("HyperionSafeModeLock")

                    if HyperionSafeModeLock2 then
                        HyperionSafeModeLock2:Destroy()
                    end
                end)

                local ScreenGui = Instance.new("ScreenGui")

                ScreenGui.Name = "HyperionSafeModeLock"
                ScreenGui.ResetOnSpawn = false
                ScreenGui.IgnoreGuiInset = true
                ScreenGui.DisplayOrder = 1000000
                ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
                ScreenGui.Enabled = false
                pcall(function()
                    if syn and syn.protect_gui then
                        syn.protect_gui(ScreenGui)
                    end
                end)

                if not pcall(function()
                    ScreenGui.Parent = game:GetService("CoreGui")
                end) then
                    ScreenGui.Parent = t2.value7
                end

                local Frame = Instance.new("Frame")

                Frame.AnchorPoint = Vector2.new(0.5, 0)
                Frame.Position = UDim2.new(0.5, 0, 0, 12)
                Frame.Size = UDim2.new(0, 260, 0, 54)
                Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Frame.BackgroundTransparency = 0.2
                Frame.BorderSizePixel = 0
                Frame.Active = false
                Frame.Selectable = false
                Frame.ZIndex = 1000000
                Frame.Parent = ScreenGui
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

                local TextLabel = Instance.new("TextLabel")

                TextLabel.Size = UDim2.fromScale(1, 1)
                TextLabel.BackgroundTransparency = 1
                TextLabel.Text = "BUTTONS LOCKED"
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextStrokeTransparency = 0.3
                TextLabel.Font = Enum.Font.GothamBlack
                TextLabel.TextSize = 17
                TextLabel.Active = false
                TextLabel.Selectable = false
                TextLabel.ZIndex = 1000001
                TextLabel.Parent = Frame
                t2.value52.overlay = ScreenGui
                t2.value52.label = TextLabel

                return ScreenGui, TextLabel
            end
            function t2.value62()
                if t2.value52.active then
                    return
                end

                t2.value52.active = true

                local FocusedTextBox = t2.value4:GetFocusedTextBox()

                if FocusedTextBox then
                    pcall(function()
                        FocusedTextBox:ReleaseFocus(false)
                    end)
                end

                local v414 = t2.value61()

                if v414 then
                    v414.Enabled = true
                end

                v42()
            end
            function t2.value63()
                if not t2.value52.active then
                    return
                end

                t2.value52.active = false

                if t2.value52.overlay then
                    t2.value52.overlay.Enabled = false
                end

                t2.value60()

                if t2.value29.autoBatToggled and t2.value48 then
                    task.defer(function()
                        if not t2.value56() and t2.value29.autoBatToggled then
                            pcall(t2.value48)
                        end
                    end)
                end
            end

            t2.value2.Heartbeat:Connect(function()
                if t2.value56() then
                    t2.value62()
                    v42()

                    local v415 = t2.value53()
                    local v416 = v415 and t2.value54(v415.Text) or nil
                    local v417, v418 = t2.value61()

                    if v417 then
                        v417.Enabled = true
                    end

                    if v418 then
                        v418.Text = "BUTTONS LOCKED" .. v416 and "  " .. tostring((math.max(0, (math.ceil(v416))))) or ""

                        return
                    end
                else
                    t2.value63()
                end
            end)

            function t2.value64()
                local Character = t2.value6.Character

                if not Character then
                    return nil
                end

                for _, v in ipairs(t2.value28) do
                    local v2 = Character:FindFirstChild(v)

                    if v2 and v2:IsA("Tool") then
                        return v2
                    end
                end

                local Backpack = t2.value6:FindFirstChild("Backpack")

                if Backpack then
                    for _, v in ipairs(t2.value28) do
                        local v4 = Backpack:FindFirstChild(v)

                        if v4 and v4:IsA("Tool") then
                            return v4
                        end
                    end
                end

                local GetChildren = Character.GetChildren
                local v430, v431, v432 = ipairs(GetChildren(Character))
                local v433

                repeat
                    v432, v433 = v430(v431, v432)

                    if not v432 then
                        if Backpack then
                            local GetChildren2 = Backpack.GetChildren

                            for _, v in ipairs(GetChildren2(Backpack)) do
                                if v:IsA("Tool") and v.Name:lower():find("bat") or v.Name:lower():find("slap") then
                                    return v
                                end
                            end
                        end

                        return nil
                    end
                until v433:IsA("Tool") and v433.Name:lower():find("bat") or v433.Name:lower():find("slap")

                return v433
            end
            function t2.value65(p54)
                if not p54 then
                    return
                end

                pcall(function()
                    p54:Activate()
                end)

                local v420 = p54:FindFirstChildOfClass("RemoteEvent") or p54:FindFirstChildWhichIsA("RemoteEvent", true)

                if v420 then
                    pcall(function()
                        v420:FireServer()
                    end)
                end
            end
            function t2.value66()
                if t2.value29.laggerActive then
                    return tonumber(t2.value29.laggerSpeed) or 15
                end

                if t2.value29.speedType == "carry" then
                    return tonumber(t2.value29.carrySpeed) or 30
                end

                return tonumber(t2.value29.normalSpeed) or 60
            end
            function t2.value67()
                if t2.value29.speedType == "carry" then
                    return tonumber(t2.value29.normalSpeed) or 60
                end

                if t2.value29.laggerActive then
                    return tonumber(t2.value29.laggerSpeed) or 15
                end

                return tonumber(t2.value29.normalSpeed) or 60
            end
            function t2.value68()
                if not t2.value57() then
                    return
                end

                if t2.value29.laggerActive then
                    return
                end

                if t2.value29.speedType ~= "carry" then
                    t2.value29.speedType = "carry"

                    if t2.value31.Buttons.carrySpeed then
                        t2.value31.Buttons.carrySpeed(true)
                    end

                    t2.value35()
                end
            end

            t2.value69 = Vector3.zero
            t2.value70 = nil
            t2.value71 = 59
            t2.value72 = false

            function t2.value73(p55)
                local Character = t2.value6.Character

                if not Character then
                    return false
                end

                if typeof(p55) ~= "Instance" then
                    return false
                end

                if p55.Name ~= "HumanoidRootPart" then
                    return false
                end

                if not p55:IsA("BasePart") then
                    return false
                end

                return Character == p55.Parent
            end

            t2.value74 = nil

            local ok = pcall(function()
                t2.value70 = hookmetamethod(game, "__index", newcclosure(function(p56, p57)
                    if (not checkcaller() and p57 == "AssemblyLinearVelocity" or p57 == "Velocity") and t2.value73(p56) then
                        return t2.value69
                    end

                    return t2.value70(p56, p57)
                end))
            end)

            pcall(function()
                t2.value74 = hookmetamethod(game, "__newindex", newcclosure(function(p58, p59, p60)
                    if (not checkcaller() and p59 == "AssemblyLinearVelocity" or p59 == "Velocity") and t2.value73(p58) then
                        return
                    end

                    return t2.value74(p58, p59, p60)
                end))
            end)

            if ok then
                ok = nil
            end

            if ok then
                t2.value72 = true

                local function v44(p61)
                    local Character = t2.value6.Character
                    local v441 = Character and Character:FindFirstChildOfClass("Humanoid")
                    local v442 = Character and Character:FindFirstChild("HumanoidRootPart")

                    if not Character or (not v441 or (not v442 or v441.Health <= 0)) then
                        return
                    end

                    local MoveDirection = v441.MoveDirection

                    if MoveDirection.Magnitude > 0.05 then
                        pcall(function()
                            if v442.SetNetworkOwner then
                                v442:SetNetworkOwner(t2.value6)
                            end
                        end)

                        local Unit = MoveDirection.Unit

                        Vector3.new(Unit.X * 16, v442.AssemblyLinearVelocity.Y, Unit.Z * 16)
                        v442.AssemblyLinearVelocity = Vector3.new(Unit.X * p61, v442.AssemblyLinearVelocity.Y, Unit.Z * p61)

                        return
                    end

                    Vector3.new(0, v442.AssemblyLinearVelocity.Y, 0)
                end

                t2.value2.PreSimulation:Connect(function()
                    if _G.HyperionResetting then
                        return
                    end

                    if t2.value29._tpInProgress then
                        return
                    end

                    local autoLeftEnabled = t2.value29.autoLeftEnabled

                    if not autoLeftEnabled then
                        autoLeftEnabled = t2.value29.autoRightEnabled or (t2.value29.autoBatToggled or t2.value29.tpBatEnabled)
                    end

                    if autoLeftEnabled then
                        return
                    end

                    local value71 = t2.value71

                    if type(t2.value66) == "function" then
                        value71 = tonumber(t2.value66()) or t2.value71
                    end

                    v44(value71)
                end)
            end

            local vector3 = Vector3.new(0, 0, 0)

            t2.value75 = nil
            t2.value76 = vector3
            t2.value75 = false
            t2.value77 = 1
            t2.value78 = nil

            function t2.value78(p62)
                local u458 = p62
                local ok4, result = pcall(function()
                    local v1087 = u458.Position + Vector3.new(0, 2, 0)
                    local raycastParams = RaycastParams.new()

                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                    local Parent = u458.Parent

                    if Parent then
                        raycastParams.FilterDescendantsInstances = { Parent }
                    end

                    raycastParams.IgnoreWater = true

                    local raycastResult = workspace:Raycast(v1087, Vector3.new(0, -8, 0), raycastParams)

                    if raycastResult and raycastResult.Normal then
                        local NormalY = raycastResult.Normal.Y
                        local v1092 = raycastResult.Distance < 4.2

                        return {
							ny = NormalY,
							grounded = v1092
						}
                    end

                    return {
						ny = 1,
						grounded = false
					}
                end)
                if ok4 then
                    ok4 = type(result) == "table" and type(result.ny) == "number"
                end
                if ok4 then
                    t2.value77 = result.ny

                    return result.ny, result.grounded == true
                end

                return t2.value77, false
            end
            function t2.value79(p63, p64)
                if not p63 or not p63.Parent then
                    return
                end

                local p64X = p64.X
                local p64Z = p64.Z
                local v455 = math.sqrt(p64X * p64X + p64Z * p64Z)

                t2.value75 = v455 > 0.05

                if v455 < 0.05 then
                    return
                end

                pcall(function()
                    local AssemblyMass = p63.AssemblyMass

                    if not AssemblyMass or (AssemblyMass ~= AssemblyMass or AssemblyMass <= 0) then
                        AssemblyMass = 1
                    end

                    local AssemblyLinearVelocity = p63.AssemblyLinearVelocity
                    local v1078 = Vector3.new(p64X, AssemblyLinearVelocity.Y, p64Z) - AssemblyLinearVelocity

                    p63:ApplyImpulse(Vector3.new(v1078.X, 0, v1078.Z) * AssemblyMass)
                end)
            end
            function t2.value80(p65)
                if not p65 or not p65.Parent then
                    return
                end

                pcall(function()
                    local _, v1080 = t2.value78(p65)

                    if not v1080 then
                        return
                    end

                    local AssemblyLinearVelocity = p65.AssemblyLinearVelocity
                    local AssemblyLinearVelocityX = AssemblyLinearVelocity.X
                    local AssemblyLinearVelocityZ = AssemblyLinearVelocity.Z
                    local v1084 = math.sqrt(AssemblyLinearVelocityX * AssemblyLinearVelocityX + AssemblyLinearVelocityZ * AssemblyLinearVelocityZ)

                    if v1084 < 0.15 then
                        return
                    end

                    local AssemblyMass = p65.AssemblyMass

                    if not AssemblyMass or (AssemblyMass ~= AssemblyMass or AssemblyMass <= 0) then
                        AssemblyMass = 1
                    end

                    local v1086 = not (v1084 < 1.2) and 0.72 or 0.55

                    p65:ApplyImpulse(Vector3.new(-AssemblyLinearVelocityX, 0, -AssemblyLinearVelocityZ) * AssemblyMass * v1086)
                end)
            end
            function t2.value81(_, p67, p68)
                local v450 = _G.HyperionSpeedCounterLabel or speedLbl

                if not v450 or not v450.Parent then
                    return
                end

                if not p68 or (not p67 or p67 <= 0) then
                    v450.Text = "SPEED 0.0"

                    return
                end

                v450.Text = "SPEED " .. string.format("%.1f", p67)
            end

            t2.value2.Heartbeat:Connect(function(_)
                if _G.HyperionResetting then
                    return
                end

                if t2.value29._tpInProgress then
                    return
                end

                local Character = t2.value6.Character

                if not Character then
                    return
                end

                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                if not Humanoid or (not HumanoidRootPart or Humanoid.Health <= 0) then
                    return
                end

                local v467

                if not Humanoid then
                    v467 = false
                else
                    local State3 = Humanoid:GetState()

                    v467 = State3 == Enum.HumanoidStateType.Physics or (State3 == Enum.HumanoidStateType.Ragdoll or (State3 == Enum.HumanoidStateType.FallingDown or Humanoid.PlatformStand == true))
                end

                if v467 then
                    t2.value76 = Vector3.new(0, 0, 0)
                    t2.value75 = false
                    t2.value80(HumanoidRootPart)
                    t2.value81(HumanoidRootPart, 0, false)

                    return
                end

                local MoveDirection = Humanoid.MoveDirection
                local n1 = 0
                local v471 = false
                local v472 = not t2.value29.autoLeftEnabled

                if v472 then
                    v472 = not t2.value29.autoRightEnabled and (not t2.value29.autoBatToggled and not t2.value29.tpBatEnabled)
                end

                if v472 then
                    local v473 = t2.value66()

                    if MoveDirection.Magnitude > 0.05 then
                        v471 = true
                        n1 = v473
                        t2.value76 = Vector3.new(MoveDirection.X, 0, MoveDirection.Z).Unit

                        if not t2.value72 then
                            t2.value79(HumanoidRootPart, t2.value76 * v473)
                        end

                        _G.HyperionEngineSpeed = v473
                        _G.HyperionEngineSpeedAt = tick()
                    else
                        t2.value75 = false
                        t2.value80(HumanoidRootPart)
                    end
                elseif t2.value29.autoLeftEnabled or t2.value29.autoRightEnabled then
                    v471 = true
                    n1 = t2.value67()
                elseif t2.value29.autoBatToggled or t2.value29.tpBatEnabled then
                    n1 = t2.value66()
                    v471 = true
                else
                    t2.value80(HumanoidRootPart)
                end

                local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
                local Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude

                if v471 or t2.value75 and Magnitude > 1.2 then
                    t2.value81(HumanoidRootPart, n1, true)

                    return
                end

                if Magnitude > 2.5 and not v471 then
                    local v476 = math.floor(Magnitude * 10 + 0.5) / 10

                    t2.value81(HumanoidRootPart, v476, true)

                    return
                end

                t2.value81(HumanoidRootPart, 0, false)
            end)

            local vector3_2 = Vector3.new(-476.47, -6.28, 92.73)
            local vector3_3 = Vector3.new(-483.12, -4.95, 94.81)

            t2.value82 = vector3_2
            t2.value83 = vector3_3

            local vector3_4 = Vector3.new(-476.16, -6.52, 25.62)
            local vector3_5 = Vector3.new(-483.06, -5.03, 25.48)

            t2.value84 = vector3_4
            t2.value85 = vector3_5
        end

        t2.value86 = nil
        t2.value87 = nil
        t2.value88 = 1
        t2.value89 = 1

        function t2.value90(p70, p71, p72)
            if not p70 or not p71 then
                return
            end

            if p71.Magnitude > 0.01 then
                p71 = p71.Unit
            end

            local AssemblyMass = p70.AssemblyMass

            if not AssemblyMass or AssemblyMass <= 0 then
                AssemblyMass = 1
            end

            local AssemblyLinearVelocity = p70.AssemblyLinearVelocity
            local v489 = Vector3.new(p71.X * p72, AssemblyLinearVelocity.Y, p71.Z * p72) - AssemblyLinearVelocity

            p70:ApplyImpulse(Vector3.new(v489.X, 0, v489.Z) * AssemblyMass)
        end
        function v50()
            if t2.value86 then
                t2.value86:Disconnect()
                t2.value86 = nil
            end

            t2.value88 = 1
            t2.value29.autoLeftEnabled = false

            local Character = t2.value6.Character

            if Character then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    Humanoid:Move(Vector3.zero, false)
                end
            end

            if t2.value31.Buttons.autoLeft then
                t2.value31.Buttons.autoLeft(false)
            end
        end
        function v51()
            if t2.value87 then
                t2.value87:Disconnect()
                t2.value87 = nil
            end

            t2.value89 = 1
            t2.value29.autoRightEnabled = false

            local Character = t2.value6.Character

            if Character then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    Humanoid:Move(Vector3.zero, false)
                end
            end

            if t2.value31.Buttons.autoRight then
                t2.value31.Buttons.autoRight(false)
            end
        end
        function t2.value91()
            if t2.value57 and t2.value57() then
                t2.value29.autoLeftEnabled = false

                if t2.value31.Buttons.autoLeft then
                    t2.value31.Buttons.autoLeft(false)
                end

                if _G.HyperionSetAutoLeftVisual then
                    pcall(_G.HyperionSetAutoLeftVisual, false)
                end

                return true
            end

            return false
        end
        function t2.value92()
            if t2.value57 and t2.value57() then
                t2.value29.autoRightEnabled = false

                if t2.value31.Buttons.autoRight then
                    t2.value31.Buttons.autoRight(false)
                end

                if _G.HyperionSetAutoRightVisual then
                    pcall(_G.HyperionSetAutoRightVisual, false)
                end

                return true
            end

            return false
        end
        function v52()
            if t2.value91() then
                return
            end

            if t2.value87 then
                v51()
            end

            if t2.value86 then
                t2.value86:Disconnect()
            end

            t2.value88 = 1
            t2.value29.autoLeftEnabled = true
            t2.value2.Heartbeat:Connect(function()
                if not t2.value29.autoLeftEnabled then
                    return
                end

                if t2.value91() then
                    v50()

                    return
                end

                if t2.value56() then
                    return
                end

                local Character = t2.value6.Character

                if not Character then
                    return
                end

                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                local v1107 = not HumanoidRootPart
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if not v1107 then
                    v1107 = not Humanoid
                end

                if v1107 then
                    return
                end

                local v1109

                if not Humanoid then
                    v1109 = false
                else
                    local State4 = Humanoid:GetState()

                    v1109 = State4 == Enum.HumanoidStateType.Physics or (State4 == Enum.HumanoidStateType.Ragdoll or (State4 == Enum.HumanoidStateType.FallingDown or Humanoid.PlatformStand == true))
                end

                if v1109 then
                    Humanoid:Move(Vector3.zero, false)

                    return
                end

                local v1111 = t2.value67()

                if t2.value88 == 1 then
                    if (Vector3.new(t2.value82.X, HumanoidRootPart.Position.Y, t2.value82.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                        t2.value88 = 2

                        local v1112 = t2.value83 - HumanoidRootPart.Position
                        local Unit = Vector3.new(v1112.X, 0, v1112.Z).Unit

                        Humanoid:Move(Unit, false)
                        t2.value90(HumanoidRootPart, Unit, v1111)

                        return
                    end

                    local v1114 = t2.value82 - HumanoidRootPart.Position
                    local Unit = Vector3.new(v1114.X, 0, v1114.Z).Unit

                    Humanoid:Move(Unit, false)
                    t2.value90(HumanoidRootPart, Unit, v1111)

                    return
                end

                if t2.value88 == 2 then
                    if (Vector3.new(t2.value83.X, HumanoidRootPart.Position.Y, t2.value83.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                        Humanoid:Move(Vector3.zero, false)
                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        v50()

                        return
                    end

                    local v1116 = t2.value83 - HumanoidRootPart.Position
                    local Unit = Vector3.new(v1116.X, 0, v1116.Z).Unit

                    Humanoid:Move(Unit, false)
                    t2.value90(HumanoidRootPart, Unit, v1111)
                end
            end)
        end
        function t2.value93()
            if t2.value92() then
                return
            end

            if t2.value86 then
                v50()
            end

            if t2.value87 then
                t2.value87:Disconnect()
            end

            t2.value89 = 1
            t2.value29.autoRightEnabled = true
            t2.value87 = t2.value2.Heartbeat:Connect(function()
                if not t2.value29.autoRightEnabled then
                    return
                end

                if t2.value92() then
                    v51()

                    return
                end

                if t2.value56() then
                    return
                end

                local Character = t2.value6.Character

                if not Character then
                    return
                end

                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if not HumanoidRootPart or not Humanoid then
                    return
                end

                local v1096

                if not Humanoid then
                    v1096 = false
                else
                    local State5 = Humanoid:GetState()

                    v1096 = State5 == Enum.HumanoidStateType.Physics or (State5 == Enum.HumanoidStateType.Ragdoll or (State5 == Enum.HumanoidStateType.FallingDown or Humanoid.PlatformStand == true))
                end

                if v1096 then
                    Humanoid:Move(Vector3.zero, false)

                    return
                end

                local v1098 = t2.value67()

                if t2.value89 == 1 then
                    if (Vector3.new(t2.value84.X, HumanoidRootPart.Position.Y, t2.value84.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                        t2.value89 = 2

                        local v1099 = t2.value85 - HumanoidRootPart.Position
                        local Unit = Vector3.new(v1099.X, 0, v1099.Z).Unit

                        Humanoid:Move(Unit, false)
                        t2.value90(HumanoidRootPart, Unit, v1098)

                        return
                    end

                    local v1101 = t2.value84 - HumanoidRootPart.Position
                    local Unit = Vector3.new(v1101.X, 0, v1101.Z).Unit

                    Humanoid:Move(Unit, false)
                    t2.value90(HumanoidRootPart, Unit, v1098)

                    return
                end

                if t2.value89 == 2 then
                    if (Vector3.new(t2.value85.X, HumanoidRootPart.Position.Y, t2.value85.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                        Humanoid:Move(Vector3.zero, false)
                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        v51()

                        return
                    end

                    local v1103 = t2.value85 - HumanoidRootPart.Position
                    local Unit = Vector3.new(v1103.X, 0, v1103.Z).Unit

                    Humanoid:Move(Unit, false)
                    t2.value90(HumanoidRootPart, Unit, v1098)
                end
            end)
        end

        t2.value94 = false
        t2.value95 = nil
        t2.value96 = 0
        t2.value97 = -7

        function t2.value98()
            local num = tonumber(t2.value29.autoTpDownY)

            if num == nil then
                num = 8
            end

            if num < 0 then
                num = -num
            end

            if num > 20 then
                num = 20
            end

            return num
        end
        function t2.value99()
            local Character = t2.value6.Character
            local t4 = { Character }
            pcall(function()
                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= t2.value6 and (player.Character and player.Character ~= t2.value6.Character) then
                        t4[#t4 + 1] = player.Character
                    end
                end
            end)

            return t4
        end

        t2.value100 = nil

        function t2.value101(p73)
            if not p73 then
                return nil
            end

            return p73:FindFirstChildOfClass("Tool")
        end
        function t2.value102(p74, p75, p76)
            if not p74 or (not p75 or not p76) then
                return
            end

            pcall(function()
                if not p76 or not p76.Parent then
                    return
                end

                if p76.Parent == p74 then
                    return
                end

                local Backpack = t2.value6:FindFirstChild("Backpack")

                if Backpack and Backpack == p76.Parent or p76:IsDescendantOf(Backpack) then
                    p75:EquipTool(p76)
                end
            end)
        end

        t2.value103 = nil

        function t2.value100(p77)
            local Character = t2.value6.Character
            if not Character then
                return
            end
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            if not HumanoidRootPart then
                return
            end
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if not Humanoid or Humanoid.Health <= 0 then
                return
            end
            local v523 = typeof(t2.value97) == "number" and t2.value97 or -7
            if not p77 then
                if tick() < (t2.value96 or 0) then
                    return
                end
                if Humanoid.FloorMaterial ~= Enum.Material.Air then
                    return
                end
                local v525 = t2.value98()
                local u524
                pcall(function()
                    local raycastParams = RaycastParams.new()

                    raycastParams.FilterDescendantsInstances = t2.value99()
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                    local raycastResult = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -400, 0), raycastParams)

                    if raycastResult and (raycastResult.Position and raycastResult.Position.Y < HumanoidRootPart.Position.Y) then
                        u524 = raycastResult.Position.Y
                    end
                end)
                if u524 then
                    local v526 = u524 + (Humanoid.HipHeight and (Humanoid.HipHeight > 0 and Humanoid.HipHeight) or 2) + HumanoidRootPart.Size.Y / 2 + 0.05

                    if v525 > HumanoidRootPart.Position.Y - v526 then
                        return
                    end
                elseif HumanoidRootPart.Position.Y < v523 + v525 then
                    return
                end
                if Humanoid:GetState() == Enum.HumanoidStateType.Seated then
                    return
                end
            end
            if type(cancelDrop) == "function" then
                pcall(cancelDrop)
            end
            local u527
            pcall(function()
                u527 = t2.value101(Character)
            end)
            pcall(function()
                Humanoid.PlatformStand = false
                HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, v523, HumanoidRootPart.Position.Z) * CFrame.Angles(0, select(2, HumanoidRootPart.CFrame:ToEulerAnglesYXZ()), 0)
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                pcall(function()
                    Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                end)
            end)
            local _ = tick() + 0.35
            t2.value51 = tick() + 0.4
            task.defer(function()
                pcall(function()
                    local Character2 = t2.value6.Character
                    local v1500 = Character2 and Character2:FindFirstChildOfClass("Humanoid")
                    local v1501 = Character2 and Character2:FindFirstChild("HumanoidRootPart")

                    if not v1500 or not v1501 then
                        return
                    end

                    v1500.PlatformStand = false
                    v1501.AssemblyLinearVelocity = Vector3.new(0, math.min(v1501.AssemblyLinearVelocity.Y, 0), 0)
                    v1501.AssemblyAngularVelocity = Vector3.zero

                    local State6 = v1500:GetState()

                    if State6 == Enum.HumanoidStateType.Physics or (State6 == Enum.HumanoidStateType.Ragdoll or State6 == Enum.HumanoidStateType.FallingDown) then
                        v1500:ChangeState(Enum.HumanoidStateType.GettingUp)
                        task.wait(0.05)

                        if v1500.Parent then
                            v1500.PlatformStand = false
                            v1500:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end
                end)
            end)
            if u527 then
                task.defer(function()
                    pcall(function()
                        t2.value102(t2.value6.Character, t2.value6.Character and t2.value6.Character:FindFirstChildOfClass("Humanoid"), u527)
                    end)
                end)
            end
        end
        function t2.value104()
            t2.value29.autoTpDownEnabled = true

            if t2.value95 then
                task.cancel(t2.value95)
            end

            task.spawn(function()
                while t2.value29.autoTpDownEnabled do
                    task.wait(0.2)

                    if not t2.value94 then
                        pcall(function()
                            t2.value100(false)
                        end)
                    end
                end
            end)
        end
        function t2.value105()
            t2.value29.autoTpDownEnabled = false
            t2.value94 = false

            if t2.value95 then
                task.cancel(t2.value95)
                t2.value95 = nil
            end
        end

        t2.value106 = nil

        function t2.value107()
            if type(cancelDrop) == "function" then
                pcall(cancelDrop)
            end

            pcall(function()
                t2.value100(true)
            end)
        end

        t2.value106 = 0.2
        t2.value103 = 150

        function t2.value108()
            if t2.value56() then
                return
            end
            if t2.value29.dropBrainrotActive and (t2.value29.dropBrainrotStartedAt and tick() - t2.value29.dropBrainrotStartedAt < 2) then
                return
            end
            local Character = t2.value6.Character
            if not Character then
                return
            end
            if not Character:FindFirstChild("HumanoidRootPart") then
                return
            end
            t2.value29.dropBrainrotActive = true
            local timestamp = tick()
            t2.value29.dropBrainrotStartedAt = timestamp
            local connection
            connection = t2.value2.Heartbeat:Connect(function()
                if t2.value56() then
                    connection:Disconnect()
                    t2.value29.dropBrainrotActive = false

                    return
                end

                local v1130 = Character and Character:FindFirstChild("HumanoidRootPart")

                if not v1130 then
                    connection:Disconnect()
                    t2.value29.dropBrainrotActive = false

                    return
                end

                if tick() - timestamp >= t2.value106 then
                    connection:Disconnect()

                    local raycastParams = RaycastParams.new()

                    raycastParams.FilterDescendantsInstances = { Character }
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                    local raycastResult = workspace:Raycast(v1130.Position, Vector3.new(0, -2000, 0), raycastParams)

                    if raycastResult then
                        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                        local v1134 = (Humanoid and Humanoid.HipHeight or 2) + v1130.Size.Y / 2

                        v1130.CFrame = CFrame.new(v1130.Position.X, raycastResult.Position.Y + v1134, v1130.Position.Z)
                        v1130.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end

                    t2.value29.dropBrainrotActive = false

                    return
                end

                v1130.AssemblyLinearVelocity = Vector3.new(v1130.AssemblyLinearVelocity.X, t2.value103, v1130.AssemblyLinearVelocity.Z)
            end)
        end

        t2.value109 = nil
        t2.value110 = nil

        function t2.value111()
            if t2.value56() then
                return
            end

            local Character = t2.value6.Character

            if Character then
                for _, child in ipairs(Character:GetChildren()) do
                    local v535 = child

                    if v535:IsA("Tool") then
                        pcall(function()
                            v535.Parent = t2.value6.Backpack
                        end)
                    end
                end
            end

            t2.value108()
        end

        t2.value109 = nil
        t2.value110 = false

        function t2.value112(p78)
            if not p78 then
                return false
            end

            local State7 = p78:GetState()

            return State7 == Enum.HumanoidStateType.Physics or (State7 == Enum.HumanoidStateType.Ragdoll or (State7 == Enum.HumanoidStateType.FallingDown or p78.PlatformStand == true))
        end
        function t2.value113()
            if t2.value109 then
                t2.value109:Disconnect()
                t2.value109 = nil
            end

            t2.value110 = false
        end

        t2.value114 = {}
        t2.value115 = nil

        function t2.value115()
            local Character = t2.value6.Character

            if not Character then
                return nil
            end

            local GetChildren = Character.GetChildren

            for _, v in ipairs(GetChildren(Character)) do
                if not v:IsA("Tool") then
                    continue
                end

                local v542 = v.Name:lower()

                if v542:find("medusa") or (v542:find("head") or v542:find("stone")) then
                    return v
                end
            end

            local Backpack = t2.value6:FindFirstChild("Backpack")

            if Backpack then
                local GetChildren3 = Backpack.GetChildren

                for _, v in ipairs(GetChildren3(Backpack)) do
                    if not v:IsA("Tool") then
                        continue
                    end

                    local v547 = v.Name:lower()

                    if v547:find("medusa") or (v547:find("head") or v547:find("stone")) then
                        return v
                    end
                end
            end

            return nil
        end
        function t2.value116()
            if t2.value56() then
                return
            end

            if t2.value29.medusaDebounce then
                return
            end

            if tick() - t2.value29.medusaLastUsed < 25 then
                return
            end

            local Character = t2.value6.Character

            if not Character then
                return
            end

            t2.value29.medusaDebounce = true

            local v549 = t2.value115()

            if not v549 then
                t2.value29.medusaDebounce = false

                return
            end

            if Character ~= v549.Parent then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    Humanoid:EquipTool(v549)
                end
            end

            t2.value8(function()
                v549:Activate()
            end)
            t2.value29.medusaLastUsed = tick()
            t2.value29.medusaDebounce = false
        end
        function t2.value117(p79)
            return p79:GetPropertyChangedSignal("Anchored"):Connect(function()
                if p79.Anchored and p79.Transparency == 1 then
                    t2.value116()
                end
            end)
        end
        function v53(p80)
            t2.value45()

            if not p80 then
                return
            end

            local GetDescendants = p80.GetDescendants

            for _, v in ipairs(GetDescendants(p80)) do
                if v:IsA("BasePart") then
                    table.insert(t2.value114, t2.value117(v))
                end
            end

            table.insert(t2.value114, p80.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("BasePart") then
                    table.insert(t2.value114, t2.value117(descendant))
                end
            end))
        end
        function t2.value45()
            for _, v in pairs(t2.value114) do
                local v562 = v

                t2.value8(function()
                    v562:Disconnect()
                end)
            end

            t2.value114 = {}
        end

        t2.value118 = nil
        t2.value118 = {
			conn = nil,
			cached = {}
		}

        function t2.value119()
            local Character = t2.value6.Character

            if not Character then
                return false
            end

            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            local v574 = not Humanoid
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            if not v574 then
                v574 = not HumanoidRootPart
            end

            if v574 then
                return false
            end

            t2.value118.cached = {
				character = Character,
				humanoid = Humanoid,
				root = HumanoidRootPart
			}

            local CurrentCamera = workspace.CurrentCamera

            if CurrentCamera then
                CurrentCamera.CameraSubject = Humanoid
            end

            return true
        end
        function t2.value120(p81)
            if not p81 then
                p81 = t2.value118.cached.humanoid
            end

            if not p81 then
                return false
            end

            local State8 = p81:GetState()

            if State8 == Enum.HumanoidStateType.Physics or (State8 == Enum.HumanoidStateType.Ragdoll or (State8 == Enum.HumanoidStateType.FallingDown or p81.PlatformStand)) then
                return true
            end

            local RagdollEndTime = t2.value6:GetAttribute("RagdollEndTime")

            return RagdollEndTime ~= nil and RagdollEndTime - workspace:GetServerTimeNow() > 0
        end

        local v77

        do
            local function v54(p82)
                if not p82 then
                    p82 = t2.value118.cached.character or t2.value6.Character
                end

                if not p82 then
                    return
                end

                local GetDescendants = p82.GetDescendants

                for _, v in ipairs(GetDescendants(p82)) do
                    local v584 = v

                    if v584:IsA("BallSocketConstraint") or v584:IsA("Attachment") and v584.Name:find("RagdollAttachment") then
                        pcall(function()
                            v584:Destroy()
                        end)
                    end
                end
            end

            function t2.value121(p83, p84, p85)
                local u588 = p83 or (t2.value118.cached.character or t2.value6.Character)
                local u589 = p84 or u588 and u588:FindFirstChildOfClass("Humanoid")
                local u590 = p85 or u588 and u588:FindFirstChild("HumanoidRootPart")
                local v591 = not u588

                if not v591 then
                    v591 = not u589 or (not u590 or u589.Health <= 0)
                end

                if v591 then
                    return
                end

                pcall(function()
                    t2.value6:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
                end)

                local v592 = t2.value29.autoBatToggled == true or t2.value29.tpBatEnabled == true

                v54(u588)
                pcall(function()
                    local AssemblyLinearVelocity = u590.AssemblyLinearVelocity

                    if v592 then
                        u590.AssemblyAngularVelocity = Vector3.zero
                        u590.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, math.clamp(AssemblyLinearVelocity.Y, -40, 60), AssemblyLinearVelocity.Z)
                    else
                        u590.AssemblyLinearVelocity = Vector3.zero
                        u590.AssemblyAngularVelocity = Vector3.zero
                    end

                    u589:ChangeState(Enum.HumanoidStateType.GettingUp)
                    u589:ChangeState(Enum.HumanoidStateType.Running)
                    u589.PlatformStand = false
                    u589.Sit = false
                    u589.AutoRotate = not v592

                    if u589.JumpPower and u589.JumpPower <= 0 then
                        u589.JumpPower = 50
                    end

                    if u589.WalkSpeed and u589.WalkSpeed <= 0 then
                        u589.WalkSpeed = 16
                    end

                    for _, descendant in ipairs(u588:GetDescendants()) do
                        if descendant:IsA("Motor6D") then
                            descendant.Enabled = true
                        elseif descendant:IsA("Constraint") then
                            descendant.Enabled = true
                        end
                    end

                    u590.Anchored = false

                    local _, v1142 = u590.CFrame:ToEulerAnglesYXZ()

                    u590.CFrame = CFrame.new(u590.Position) * CFrame.Angles(0, v1142, 0)

                    local CurrentCamera = workspace.CurrentCamera

                    if CurrentCamera then
                        CurrentCamera.CameraSubject = u589
                    end
                end)

                if not v592 then
                    pcall(function()
                        local PlayerScripts = t2.value6:FindFirstChild("PlayerScripts")
                        local v1145 = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")
                        local v1146 = v1145 and v1145:FindFirstChild("ControlModule")

                        if v1146 then
                            local ok, result = pcall(require, v1146)

                            if ok then
                                ok = result and result.Enable
                            end

                            if ok then
                                result:Enable()
                            end
                        end
                    end)
                end
            end
            function v55()
                if t2.value118.conn then
                    return
                end

                if not t2.value29.antiRagdollEnabled then
                    return
                end

                t2.value119()
                t2.value118.conn = t2.value2.Heartbeat:Connect(function()
                    if not t2.value29.antiRagdollEnabled then
                        return
                    end

                    if t2.value56() then
                        return
                    end

                    if tick() < t2.value51 then
                        return
                    end

                    local Character = t2.value6.Character
                    local v1150 = Character and Character:FindFirstChildOfClass("Humanoid")
                    local v1151 = not Character
                    local v1152 = Character and Character:FindFirstChild("HumanoidRootPart")

                    if not v1151 then
                        v1151 = not v1150 or (not v1152 or v1150.Health <= 0)
                    end

                    if v1151 then
                        return
                    end

                    if t2.value120(v1150) then
                        if tick() - 0 >= 0.03 then
                            t2.value121(Character, v1150, v1152)

                            return
                        end

                        pcall(function()
                            v1150:ChangeState(Enum.HumanoidStateType.GettingUp)
                            v1150.PlatformStand = false
                            v1150.Sit = false
                        end)
                    end
                end)
            end

            t2.value122 = nil

            function t2.value123()
                if t2.value118.conn then
                    t2.value118.conn:Disconnect()
                    t2.value118.conn = nil
                end

                t2.value118.cached = {}
            end

            t2.value124 = nil
            t2.value125 = nil
            t2.value126 = nil
            t2.value127 = nil
            t2.value122 = nil
            t2.value125 = false

            function t2.value128(p86, p87)
                if not p86 or not p86.Parent then
                    return
                end

                if p86.Health <= 0 and not t2.value125 then
                    return
                end

                pcall(function()
                    local v1153 = math.max(p86.MaxHealth or 100, 100)

                    p86.MaxHealth = v1153

                    if p86.Health > 0 then
                        p86.Health = v1153
                    end

                    p86:SetStateEnabled(Enum.HumanoidStateType.Dead, t2.value125)
                    p86:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    p86:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    p86:SetStateEnabled(Enum.HumanoidStateType.Physics, false)

                    if p86.Health > 0 then
                        p86:ChangeState(Enum.HumanoidStateType.Running)
                    end

                    if p87 then
                        p87.AssemblyAngularVelocity = Vector3.zero
                    end
                end)
            end
            function v56()
                if t2.value124 then
                    return
                end

                t2.value29.antiDieEnabled = true

                local function v596(p88)
                    if t2.value126 then
                        pcall(function()
                            t2.value126:Disconnect()
                        end)
                    end

                    local v1155 = p88 and p88:FindFirstChildOfClass("Humanoid")

                    if not v1155 then
                        return
                    end

                    v1155.HealthChanged:Connect(function()
                        if t2.value29.antiDieEnabled and (not t2.value125 and v1155.Health < (v1155.MaxHealth or 100)) then
                            t2.value128(v1155, p88:FindFirstChild("HumanoidRootPart"))
                        end
                    end)
                end

                if t2.value6.Character then
                    v596(t2.value6.Character)
                end

                t2.value6.CharacterAdded:Connect(function(character)
                    task.wait(0.15)
                    v596(character)
                end)
                t2.value2.Heartbeat:Connect(function()
                    if not t2.value29.antiDieEnabled then
                        return
                    end

                    local Character = t2.value6.Character

                    if not Character then
                        return
                    end

                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                    if not Humanoid or Humanoid.Health <= 0 then
                        return
                    end

                    if t2.value125 then
                        return
                    end

                    if t2.value56() then
                        if Humanoid.Health < (Humanoid.MaxHealth or 100) and Humanoid.Health > 0 then
                            t2.value128(Humanoid, HumanoidRootPart)
                        end

                        return
                    end

                    if Humanoid.Health < (Humanoid.MaxHealth or 100) and Humanoid.Health > 0 then
                        t2.value128(Humanoid, HumanoidRootPart)
                    end

                    local State9 = Humanoid:GetState()

                    if State9 == Enum.HumanoidStateType.Physics or (State9 == Enum.HumanoidStateType.Ragdoll or State9 == Enum.HumanoidStateType.FallingDown) then
                        pcall(function()
                            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end)

                        if HumanoidRootPart then
                            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(HumanoidRootPart.AssemblyLinearVelocity.X, 0, HumanoidRootPart.AssemblyLinearVelocity.Z)
                        end
                    end
                end)
            end
            function t2.value129()
                t2.value29.antiDieEnabled = false

                if t2.value124 then
                    t2.value124:Disconnect()
                    t2.value124 = nil
                end

                if t2.value126 then
                    pcall(function()
                        t2.value126:Disconnect()
                    end)
                    t2.value126 = nil
                end

                if t2.value127 then
                    pcall(function()
                        t2.value127:Disconnect()
                    end)
                    t2.value127 = nil
                end

                t2.value122 = nil
            end
            function t2.value130(p89)
                t2.value125 = not not p89

                if t2.value122 and t2.value122.Parent then
                    pcall(function()
                        t2.value122:SetStateEnabled(Enum.HumanoidStateType.Dead, t2.value125)
                    end)
                end
            end

            t2.value131 = false
            t2.value132 = 0
            t2.value133 = {}
            t2.value134 = nil

            function t2.value135()
                t2.value131 = false
                _G.HyperionResetting = false
                t2.value130(false)
            end

            local function v57()
                if t2.value131 then
                    return
                end

                local Character = t2.value6.Character

                if not Character or not Character.Parent then
                    return
                end

                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if not Humanoid or Humanoid.Health <= 0 then
                    return
                end

                t2.value131 = true
                _G.HyperionResetting = true
                t2.value130(true)

                local HipHeight = Humanoid.HipHeight
                local n2 = 0
                local u601 = false

                task.spawn(function()
                    while true do
                        local v1161 = Character

                        if v1161 then
                            v1161 = Character.Parent and (Humanoid and (Humanoid.Health > 0 and not u601))
                        end

                        if not v1161 then
                            break
                        end

                        if t2.value6.Character ~= Character then
                            u601 = true

                            break
                        end

                        pcall(function()
                            Humanoid.HipHeight = 1E+30
                            Humanoid.AutoRotate = true

                            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                            if HumanoidRootPart then
                                HumanoidRootPart.CanCollide = false
                            end

                            for _, child in ipairs(Character:GetChildren()) do
                                if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
                                    child.CanCollide = false
                                end
                            end
                        end)

                        local v1162 = not Character

                        if not v1162 then
                            v1162 = not Character.Parent

                            if not v1162 then
                                v1162 = not Humanoid or (Humanoid.Health <= 0 or t2.value6.Character ~= Character)
                            end
                        end

                        if v1162 then
                            u601 = true

                            break
                        end

                        n2 += 1

                        if n2 >= 40 then
                            break
                        end

                        task.wait(0.05)
                    end

                    if not u601 then
                        local v1163 = Character

                        if v1163 then
                            v1163 = Character.Parent and (Humanoid and Humanoid.Health > 0)
                        end

                        if v1163 then
                            pcall(function()
                                Humanoid.Health = 0
                            end)
                            task.wait(0.1)

                            if not Character.Parent or Humanoid.Health <= 0 then
                                u601 = true
                            end
                        end
                    end

                    if not u601 and (Character and (Character.Parent and Humanoid)) then
                        pcall(function()
                            Humanoid.HipHeight = HipHeight

                            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                            if HumanoidRootPart then
                                HumanoidRootPart.CanCollide = true
                            end

                            for _, child in ipairs(Character:GetChildren()) do
                                if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
                                    child.CanCollide = true
                                end
                            end
                        end)
                    end

                    t2.value135()
                end)
            end

            function t2.value136(_)
                if not t2.value29.medusaResetEnabled then
                    return
                end

                if t2.value131 or _G.HyperionResetting then
                    return
                end

                if os.clock() - t2.value132 < 2.5 then
                    return
                end

                local Character = t2.value6.Character

                if not Character then
                    return
                end

                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if not Humanoid or Humanoid.Health <= 0 then
                    return
                end

                os.clock()
                v57()
            end

            t2.value137 = nil

            function t2.value137(p91)
                if not p91 then
                    return false
                end

                local v553 = t2.value53()

                if v553 ~= nil and t2.value54(v553.Text) ~= nil then
                    return false
                end

                if t2.value6:GetAttribute("Stealing") then
                    return false
                end

                if p91:GetAttribute("Stealing") then
                    return false
                end

                local Humanoid = p91:FindFirstChildOfClass("Humanoid")

                if not Humanoid or Humanoid.Health <= 0 then
                    return false
                end

                if Humanoid.Sit or Humanoid.SeatPart then
                    return false
                end

                if Humanoid:GetState() == Enum.HumanoidStateType.Seated then
                    return false
                end

                local HumanoidRootPart = p91:FindFirstChild("HumanoidRootPart")

                if not HumanoidRootPart or not HumanoidRootPart.Anchored then
                    return false
                end

                if HumanoidRootPart.AssemblyLinearVelocity.Magnitude > 1 then
                    return false
                end

                local n3 = 0
                local GetChildren = p91.GetChildren

                for _, v in ipairs(GetChildren(p91)) do
                    if v:IsA("BasePart") and (v ~= HumanoidRootPart and v.Anchored) then
                        n3 += 1
                    end
                end

                if n3 < 4 and Humanoid.WalkSpeed > 0.5 then
                    return false
                end

                return true
            end
            function t2.value138(p92)
                if not p92:IsA("BasePart") then
                    return
                end

                local insert = table.insert
                local value133 = t2.value133
                local t5 = { p92:GetPropertyChangedSignal("Anchored"):Connect(function()
                    if not p92.Anchored then
                        return
                    end

                    task.defer(function()
                        if t2.value137(t2.value6.Character) then
                            t2.value136("anchored")
                        end
                    end)
                end) }

                insert(value133, v3(t5))
            end
            function t2.value46()

                for v611, v612 in pairs(t2.value133) do

                    local v613 = v612

                    pcall(function()
                        v613:Disconnect()
                    end)
                end
                t2.value133 = {}
                if t2.value134 then
                    pcall(function()
                        t2.value134:Disconnect()
                    end)
                    t2.value134 = nil
                end
            end
            function t2.value139(p93)
                t2.value46()
                if not p93 or not t2.value29.medusaResetEnabled then
                    return
                end
                local GetDescendants = p93.GetDescendants
                for _, v in ipairs(GetDescendants(p93)) do
                    t2.value138(v)
                end
                table.insert(t2.value133, p93.DescendantAdded:Connect(function(descendant)
                    if descendant:IsA("BasePart") then
                        t2.value138(descendant)
                    end
                end))
                local u618
                t2.value2.Heartbeat:Connect(function()
                    if not t2.value29.medusaResetEnabled or t2.value131 then
                        u618 = nil

                        return
                    end

                    local Character = t2.value6.Character

                    if Character and t2.value137(Character) then
                        u618 = u618 or os.clock()

                        if os.clock() - u618 >= 0.35 then
                            t2.value136("poll")
                        end
                    end
                end)
            end
            function t2.value140()
                if t2.value56() then
                    return
                end

                v57()
            end

            t2.value141 = nil

            function t2.value142()
                if t2.value141 then
                    return
                end

                t2.value141 = t2.value4.JumpRequest:Connect(function()
                    if not t2.value29.infJumpEnabled then
                        return
                    end

                    if t2.value56() then
                        return
                    end

                    if t2.value29.infJumpMode ~= "manual" then
                        return
                    end

                    local Character = t2.value6.Character
                    local v1167 = Character and Character:FindFirstChild("HumanoidRootPart")

                    if v1167 then
                        v1167.Velocity = Vector3.new(v1167.Velocity.X, 55, v1167.Velocity.Z)
                    end
                end)
            end
            function t2.value143()
                if t2.value141 then
                    t2.value141:Disconnect()
                end
            end

            t2.value2.Heartbeat:Connect(function()
                if not t2.value29.infJumpEnabled then
                    return
                end

                if t2.value56() then
                    return
                end

                local Character = t2.value6.Character

                if not Character then
                    return
                end

                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                if not HumanoidRootPart then
                    return
                end

                if t2.value29.infJumpMode == "hold" then
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                    if (t2.value4:IsKeyDown(Enum.KeyCode.Space) or Humanoid and Humanoid.Jump == true) and HumanoidRootPart.Velocity.Y < 30 then
                        HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, 55, HumanoidRootPart.Velocity.Z)
                    end
                end

                if HumanoidRootPart.Velocity.Y < -120 then
                    HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, -120, HumanoidRootPart.Velocity.Z)
                end
            end)
            t2.value144 = nil
            t2.value144 = nil

            function v58()
                if t2.value29.unwalkEnabled then
                    return
                end

                t2.value29.unwalkEnabled = true

                local Character = t2.value6.Character

                if not Character then
                    return
                end

                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    for _, v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
                        v:Stop()
                    end
                end

                local Animate = Character:FindFirstChild("Animate")

                if Animate then
                    Animate:Clone()
                    Animate:Destroy()
                end
            end

            t2.value145 = nil
            t2.value146 = nil

            function t2.value147()
                if not t2.value29.unwalkEnabled then
                    return
                end

                t2.value29.unwalkEnabled = false

                local Character = t2.value6.Character

                if Character and t2.value144 then
                    t2.value144.Parent = Character
                    t2.value144.Disabled = false
                    t2.value144 = nil
                end
            end

            t2.value145 = 9
            t2.value148 = 80
            t2.value149 = nil
            t2.value150 = nil

            function t2.value150(p94, p95, _)
                local v639 = math.clamp(tonumber(p94) or 0, 0, 1)

                t2.value30.Progress = v639

                local value30 = t2.value30

                if not p95 then
                    p95 = t2.value30.ProgressStatus
                end

                value30.ProgressStatus = p95

                if t2.value30.ProgressFill and t2.value30.ProgressFill.Parent then
                    t2.value3:Create(t2.value30.ProgressFill, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(v639, 0, 1, 0)
					}):Play()
                end

                if t2.value30.ProgressText and t2.value30.ProgressText.Parent then
                    t2.value30.ProgressText.Text = math.floor(v639 * 100 + 0.5) .. "%"
                end
            end
            function t2.value151(p97)
                local value150 = t2.value150

                if not p97 then
                    p97 = not t2.value30.Enabled and "OFF" or "SEARCHING"
                end

                value150(0, p97)
            end

            t2.value146 = nil

            function t2.value152()
                if t2.value146 then
                    return
                end
                local u641
                t2.value146 = task.spawn(function()
                    while t2.value149 and t2.value30.Enabled do
                        local timestamp = tick()

                        if t2.value30.SemiState.active or timestamp < (t2.value30.DisplayHoldUntil or 0) then
                            u641 = nil
                        else
                            if not u641 then
                                u641 = timestamp
                            end

                            local v1169 = tonumber(t2.value30.SemiHoldMax) or 2.6

                            if v1169 <= 0.05 then
                                v1169 = 2.6
                            end

                            local v1170 = (timestamp - u641) / v1169 % 1
                            local v1171 = not t2.value56() and "SEARCHING" or "SAFE MODE LOCK"

                            t2.value150(v1170, v1171)
                        end

                        task.wait()
                    end

                    t2.value146 = nil
                end)
            end
            function t2.value153()
                t2.value30.Mode = "Semi"
                t2.value30.Radius = t2.value145
            end

            t2.value154 = nil

            function t2.value154(p98)
                local Plots = workspace:FindFirstChild("Plots")

                if not Plots then
                    return false
                end

                local p98_2 = Plots:FindFirstChild(p98)

                if not p98_2 then
                    return false
                end

                local PlotSign = p98_2:FindFirstChild("PlotSign")

                if PlotSign then
                    local YourBase = PlotSign:FindFirstChild("YourBase")

                    if YourBase and YourBase:IsA("BillboardGui") then
                        return YourBase.Enabled == true
                    end
                end

                return false
            end
            function t2.value155()
                local Character = t2.value6.Character
                local v650 = Character and Character:FindFirstChild("HumanoidRootPart")
                if not v650 then
                    return nil
                end
                local Plots = workspace:FindFirstChild("Plots")
                if not Plots then
                    return nil
                end
                local GetChildren = Plots.GetChildren
                local huge = math.huge
                local u654
                local u655 = huge
                local u656
                local u657
                for _, v in ipairs(GetChildren(Plots)) do
                    if not t2.value154(v.Name) then
                        local AnimalPodiums = v:FindFirstChild("AnimalPodiums")

                        if AnimalPodiums then
                            for _, child in ipairs(AnimalPodiums:GetChildren()) do
                                local v663 = child

                                t2.value8(function()
                                    local Base = v663:FindFirstChild("Base")
                                    local v1173 = Base and Base:FindFirstChild("Spawn")

                                    if v1173 then
                                        local Magnitude = (v1173.Position - v650.Position).Magnitude

                                        if Magnitude < u655 and Magnitude <= t2.value148 then
                                            local PromptAttachment = v1173:FindFirstChild("PromptAttachment")

                                            if PromptAttachment then
                                                for _, child2 in ipairs(PromptAttachment:GetChildren()) do
                                                    if child2:IsA("ProximityPrompt") then
                                                        local Name = v663.Name
                                                        local v1179 = v663

                                                        u654 = child2
                                                        u655 = Magnitude
                                                        u656 = Name
                                                        u657 = v1179

                                                        return
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end

                return u654, u655, u656, u657
            end
            function t2.value156(p99)
                local Character = t2.value6.Character
                local v621 = Character and Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("UpperTorso")

                if not v621 or not p99 then
                    return 1e999
                end

                local Base = p99:FindFirstChild("Base")
                local v623 = Base and Base:FindFirstChild("Spawn")
                local v624 = v623 and v623.Position or p99:GetPivot().Position

                return (v621.Position - v624).Magnitude
            end
            function t2.value157(p100)
                local t6 = {}
                if not p100 then
                    return t6
                end
                local u479
                pcall(function()
                    if getconnections then
                        u479 = getconnections(p100)

                        return
                    end

                    if get_signal_cons then
                        u479 = get_signal_cons(p100)
                    end
                end)
                if type(u479) ~= "table" then
                    return t6
                end
                for _, v in ipairs(u479) do
                    local v482 = v
                    local u483
                    pcall(function()
                        u483 = v482.Function or (v482.func or v482.Fn)
                    end)
                    if type(u483) == "function" then
                        table.insert(t6, u483)
                    end
                end

                return t6
            end
            function t2.value158(p101, p102)
                if #p102.hold > 0 then
                    for _, v in ipairs(p102.hold) do
                        local v571 = v

                        t2.value9(function()
                            v571()
                        end)
                    end

                    return
                end

                pcall(function()
                    if p101.InputHoldBegin then
                        p101:InputHoldBegin()
                    end
                end)
            end
            function t2.value159(p103, p104)
                if not p104.useFallback and #p104.trigger > 0 then
                    for _, v in ipairs(p104.trigger) do
                        local v513 = v

                        t2.value9(function()
                            v513()
                        end)
                    end

                    return true
                end

                if fireproximityprompt and pcall(function()
                    fireproximityprompt(p103)
                end) then
                    return true
                end

                return (pcall(function()
                    if p103.InputHoldEnd then
                        p103:InputHoldEnd()
                    end
                end))
            end
            function t2.value160(p105, p106, p107)
                if t2.value30.SemiState.active then
                    return false
                end

                if not t2.value30.Data[p105] then
                    t2.value30.Data[p105] = {
						hold = {},
						trigger = {},
						ready = true,
						useFallback = false
					}

                    local v667 = t2.value157(p105.PromptButtonHoldBegan)
                    local v668 = t2.value157(p105.Triggered)

                    t2.value30.Data[p105].hold = v667
                    t2.value30.Data[p105].trigger = v668

                    if #v667 == 0 and #v668 == 0 then
                        t2.value30.Data[p105].useFallback = true
                    end
                end

                local v669 = t2.value30.Data[p105]

                if not v669.ready then
                    return false
                end

                v669.ready = false
                t2.value30.SemiState.active = true
                t2.value30.SemiState.startTime = tick()
                t2.value30.SemiState.phase = "holding"
                t2.value30.SemiState.label = p107 or "Animal"
                task.spawn(function()
                    local success, result = pcall(function()
                        local startTime = t2.value30.SemiState.startTime

                        t2.value158(p105, v669)

                        while true do
                            local value30Enabled = t2.value30.Enabled

                            if value30Enabled then
                                value30Enabled = t2.value30.Mode == "Semi" and (not t2.value56() and tick() - startTime < t2.value30.SemiHoldMin)
                            end

                            if not value30Enabled then
                                break
                            end

                            local v1514 = (tick() - startTime) / t2.value30.SemiHoldMax % 1

                            t2.value150(v1514, "HOLDING", " - HOLD")
                            task.wait(0.02)
                        end

                        t2.value30.SemiState.phase = "waitingRange"

                        local value145 = t2.value145
                        local v1516 = value145 >= t2.value156(p106)
                        local v1517 = false

                        while true do
                            local value30Enabled = t2.value30.Enabled

                            if value30Enabled then
                                value30Enabled = t2.value30.Mode == "Semi" and (not t2.value56() and p105.Parent)
                            end

                            if not value30Enabled then
                                break
                            end

                            local v1519 = tick() - startTime

                            if v1519 > t2.value30.SemiHoldMax then
                                break
                            end

                            local v1520 = v1519 / t2.value30.SemiHoldMax % 1

                            if value145 >= t2.value156(p106) then
                                t2.value150(v1520, "STEALING", " - GRAB")

                                if not v1516 then
                                    task.wait(t2.value30.SemiEntryDelay)
                                end

                                local value30Enabled2 = t2.value30.Enabled

                                if value30Enabled2 then
                                    value30Enabled2 = t2.value30.Mode == "Semi" and (not t2.value56() and (p105.Parent and value145 >= t2.value156(p106)))
                                end

                                if value30Enabled2 then
                                    local v1522 = p105
                                    local v1523 = v669

                                    t2.value159(v1522, v1523)
                                    v1517 = true
                                end

                                break
                            end

                            t2.value150(v1520, "STEALING", " - WAIT")
                            task.wait(0.02)
                        end

                        t2.value30.SemiState.active = false
                        t2.value30.SemiState.phase = "idle"

                        if v1517 then
                            t2.value30.LastSteal = tick()
                            t2.value150(1, "STOLE")
                            t2.value30.DisplayHoldUntil = tick() + 0.8
                        end

                        task.wait(t2.value30.SemiCooldown)
                    end)
                    if not success then
                        warn("[Hyperion] AutoSteal attempt error: " .. tostring(result))
                        t2.value30.SemiState.active = false
                        t2.value30.SemiState.phase = "idle"
                    end
                    v669.ready = true
                    t2.value151(not t2.value56() and "SEARCHING" or "SAFE MODE LOCK")
                end)

                return true
            end
            function v59()
                t2.value153()

                if t2.value149 then
                    return
                end

                t2.value151("SEARCHING")
                t2.value30.DisplayHoldUntil = 0
                t2.value2.Heartbeat:Connect(function()
                    t2.value153()

                    if not t2.value30.Enabled then
                        return
                    end

                    if t2.value56() then
                        return
                    end

                    if t2.value57() then
                        return
                    end

                    if tick() - (t2.value30.LastSteal or 0) < (t2.value30.Cooldown or 0) then
                        return
                    end

                    if t2.value30.SemiState.active then
                        return
                    end

                    local v1182, _, v1184, v1185 = t2.value155()

                    if v1182 and v1185 then
                        t2.value160(v1182, v1185, v1184)
                    end
                end)
                t2.value152()
            end
            function t2.value161()
                if t2.value149 then
                    t2.value149:Disconnect()
                    t2.value149 = nil
                end

                t2.value30.SemiState.active = false
                t2.value30.SemiState.phase = "idle"

                for _, v in pairs(t2.value30.Data) do
                    if v.ready ~= nil then
                        v.ready = true
                    end
                end

                t2.value151("OFF")
            end

            t2.value153()
            t2.value162 = nil
            t2.value163 = false
            t2.value164 = {}
            t2.value165 = nil
            t2.value166 = "HyperionTPBatFF"
            t2.value167 = 85
            t2.value168 = 15
            t2.value169 = 95
            t2.value170 = 20

            function t2.value171()
                if t2.value165 then
                    pcall(function()
                        t2.value165:Destroy()
                    end)
                    t2.value165 = nil
                end

                pcall(function()
                    for _, child in ipairs(workspace:GetChildren()) do
                        local v1188 = child

                        if v1188.Name == "HyperionTPBatPredBall" then
                            pcall(function()
                                v1188:Destroy()
                            end)
                        end
                    end
                end)
            end
            function t2.value172(p108)
                pcall(function()
                    if not t2.value165 or not t2.value165.Parent then
                        t2.value165 = Instance.new("Part")
                        t2.value165.Name = "HyperionTPBatPredBall"
                        t2.value165.Size = Vector3.new(0.6, 0.6, 0.6)
                        t2.value165.Shape = Enum.PartType.Ball
                        t2.value165.Material = Enum.Material.Neon
                        t2.value165.CanCollide = false
                        t2.value165.Anchored = true
                        t2.value165.CastShadow = false
                        t2.value165.Parent = workspace
                    end

                    t2.value165.Color = Color3.fromRGB(190, 120, 255)
                    t2.value165.CFrame = CFrame.new(p108)
                    t2.value165.Transparency = 0.15
                end)
            end

            t2.value173 = nil

            function t2.value173(p109, p110)
                if not p109 then
                    return
                end

                pcall(function()
                    p109.MaxHealth = math.max(p109.MaxHealth, 100)
                    p109.Health = p109.MaxHealth
                    p109.BreakJointsOnDeath = false
                    p109.RequiresNeck = false
                    p109.PlatformStand = false
                    p109.Sit = false
                    p109:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    p109:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    p109:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    p109:SetStateEnabled(Enum.HumanoidStateType.Physics, false)

                    local State10 = p109:GetState()
                    local v1193 = State10 == Enum.HumanoidStateType.Dead

                    if not v1193 then
                        v1193 = State10 == Enum.HumanoidStateType.Physics or (State10 == Enum.HumanoidStateType.Ragdoll or State10 == Enum.HumanoidStateType.FallingDown)
                    end

                    if v1193 then
                        p109:ChangeState(Enum.HumanoidStateType.Running)
                    end

                    if p110 and not p110:FindFirstChild(t2.value166) then
                        local ForceField = Instance.new("ForceField")

                        ForceField.Name = t2.value166
                        ForceField.Visible = false
                        ForceField.Parent = p110
                    end
                end)
            end
            function t2.value174()
                for _, v in ipairs(t2.value164) do
                    local v672 = v

                    pcall(function()
                        v672:Disconnect()
                    end)
                end

                for i = #t2.value164, 1, -1 do
                    t2.value164[i] = nil
                end

                pcall(function()
                    local Character = t2.value6.Character

                    if Character then
                        local t2value166 = Character:FindFirstChild(t2.value166)

                        if t2value166 then
                            t2value166:Destroy()
                        end

                        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                        if Humanoid then
                            Humanoid.BreakJointsOnDeath = true
                            Humanoid.RequiresNeck = true
                            pcall(function()
                                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                                Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
                            end)
                        end
                    end
                end)
            end
            function t2.value175(p111)
                if not p111 then
                    return
                end

                local v678 = p111:FindFirstChildOfClass("Humanoid") or p111:WaitForChild("Humanoid", 3)

                if not v678 then
                    return
                end

                pcall(function()
                    local t2value166 = p111:FindFirstChild(t2.value166)

                    if t2value166 then
                        t2value166:Destroy()
                    end

                    local ForceField = Instance.new("ForceField")

                    ForceField.Name = t2.value166
                    ForceField.Visible = false
                    ForceField.Parent = p111
                end)
                t2.value173(v678, p111)
                table.insert(t2.value164, t2.value2.Stepped:Connect(function()
                    if not t2.value29.tpBatEnabled then
                        return
                    end

                    local Character = t2.value6.Character
                    local v1198 = Character
                    local value173 = t2.value173

                    if Character then
                        v1198 = Character:FindFirstChildOfClass("Humanoid")
                    end

                    value173(v1198, Character)
                end))
                table.insert(t2.value164, t2.value2.Heartbeat:Connect(function()
                    if not t2.value29.tpBatEnabled then
                        return
                    end

                    local Character = t2.value6.Character
                    local v1201 = Character
                    local value173 = t2.value173

                    if Character then
                        v1201 = Character:FindFirstChildOfClass("Humanoid")
                    end

                    value173(v1201, Character)
                end))
            end
            function t2.value176()
                t2.value174()
                t2.value175(t2.value6.Character)
                table.insert(t2.value164, t2.value6.CharacterAdded:Connect(function(character)
                    if not t2.value29.tpBatEnabled then
                        return
                    end

                    task.wait(0.05)
                    t2.value175(character)
                end))
            end

            local function v60()
                local Character = t2.value6.Character

                if not Character then
                    return
                end

                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                pcall(function()
                    for _, descendant in ipairs(Character:GetDescendants()) do
                        local v1210 = descendant:IsA("BodyVelocity")

                        if not v1210 then
                            v1210 = descendant:IsA("BodyPosition")

                            if not v1210 then
                                v1210 = descendant:IsA("BodyAngularVelocity")

                                if not v1210 then
                                    v1210 = descendant:IsA("LinearVelocity")

                                    if not v1210 then
                                        v1210 = descendant:IsA("AlignPosition")

                                        if not v1210 then
                                            v1210 = descendant:IsA("AlignOrientation") or (descendant:IsA("VectorForce") or descendant:IsA("Torque"))
                                        end
                                    end
                                end
                            end
                        end

                        if v1210 then
                            local v1211 = descendant.Name:find("Hyperion")

                            if not v1211 then
                                v1211 = descendant.Name:find("Aim") or (descendant.Name:find("TP") or descendant.Name:find("Pred"))
                            end

                            if v1211 then
                                descendant:Destroy()
                            end
                        end
                    end

                    local t2value166 = Character:FindFirstChild(t2.value166)

                    if t2value166 then
                        t2value166:Destroy()
                    end
                end)

                if HumanoidRootPart then
                    HumanoidRootPart.Anchored = false
                    pcall(function()
                        if sethiddenproperty then
                            sethiddenproperty(HumanoidRootPart, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
                            sethiddenproperty(HumanoidRootPart, "PhysicsRepRootPart", HumanoidRootPart)
                        end
                    end)
                    HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero

                    local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

                    if AssemblyLinearVelocity.Magnitude < 0.5 and (Humanoid and Humanoid.MoveDirection.Magnitude > 0.1) then
                        local MoveDirection = Humanoid.MoveDirection
                        local v693 = math.max(Humanoid.WalkSpeed or 16, 16)

                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(MoveDirection.X * v693, math.max(AssemblyLinearVelocity.Y, 0), MoveDirection.Z * v693)
                    else
                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, AssemblyLinearVelocity.Y, AssemblyLinearVelocity.Z)
                    end

                    local HumanoidRootPartPosition = HumanoidRootPart.Position
                    local _, v696 = HumanoidRootPart.CFrame:ToEulerAnglesYXZ()

                    HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPartPosition) * CFrame.Angles(0, v696, 0)
                end

                if Humanoid then
                    Humanoid.AutoRotate = true
                    Humanoid.PlatformStand = false
                    Humanoid.Sit = false

                    if (Humanoid.WalkSpeed or 0) <= 0 then
                        Humanoid.WalkSpeed = 16
                    end

                    if (Humanoid.JumpPower or 0) <= 0 then
                        Humanoid.JumpPower = 50
                    end

                    pcall(function()
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
                    end)
                    pcall(function()
                        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end)

                    local CurrentCamera = workspace.CurrentCamera

                    if CurrentCamera then
                        CurrentCamera.CameraSubject = Humanoid
                    end
                end
            end

            function t2.value177()
                local v496 = t2.value6.Character and t2.value6.Character:FindFirstChild("HumanoidRootPart")
                if not v496 then
                    return nil
                end
                local v497
                local n4 = 1e999
                for _, player in ipairs(t2.value1:GetPlayers()) do
                    if player ~= t2.value6 and player.Character then
                        local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                        if HumanoidRootPart and (Humanoid and Humanoid.Health > 0) then
                            local Magnitude = (HumanoidRootPart.Position - v496.Position).Magnitude

                            if Magnitude < n4 then
                                n4 = Magnitude
                                v497 = HumanoidRootPart
                            end
                        end
                    end
                end

                return v497
            end
            function t2.value178(p112)
                if not p112 then
                    return nil
                end

                local function v680(p113)
                    if not p113 or not p113:IsA("Tool") then
                        return false
                    end

                    local v1204 = p113.Name:lower()
                    local v1205 = v1204:find("bat")

                    if not v1205 then
                        v1205 = v1204:find("slap") or (v1204:find("glove") or v1204:find("hand"))
                    end

                    return v1205
                end

                for _, child in ipairs(p112:GetChildren()) do
                    if v680(child) then
                        return child
                    end
                end

                local v683 = t2.value6:FindFirstChildOfClass("Backpack") or t2.value6:FindFirstChild("Backpack")

                if v683 then
                    local GetChildren = v683.GetChildren

                    for _, v in ipairs(GetChildren(v683)) do
                        local v687 = v

                        if v680(v687) then
                            pcall(function()
                                local Humanoid = p112:FindFirstChildOfClass("Humanoid")

                                if Humanoid then
                                    Humanoid:EquipTool(v687)
                                end
                            end)

                            return v687
                        end
                    end
                end

                return p112:FindFirstChild("Bat")
            end
            function t2.value179(p114)
                if t2.value29.autoSwingEnabled == false then
                    return
                end

                if t2.value163 then
                    return
                end

                pcall(function()
                    local v1213 = p114 and p114:FindFirstChildOfClass("Humanoid")
                    local v1214 = t2.value178(p114) or p114 and p114:FindFirstChildOfClass("Tool")

                    if v1214 and (v1213 and v1214.Parent ~= p114) then
                        pcall(function()
                            v1213:EquipTool(v1214)
                        end)
                    end

                    if v1214 then
                        t2.value65(v1214)
                        pcall(function()
                            v1214:Activate()
                        end)

                        local RemoteFunction = v1214:FindFirstChildOfClass("RemoteFunction")

                        if RemoteFunction then
                            pcall(function()
                                RemoteFunction:InvokeServer()
                            end)
                        end
                    end
                end)
                task.delay(0.08, function()
                end)
            end
            function v61()
                t2.value47()
                t2.value29.tpBatEnabled = true
                _G.HyperionTPBatActive = true
                pcall(t2.value176)
                t2.value162 = t2.value2.Heartbeat:Connect(function()
                    if not t2.value29.tpBatEnabled then
                        return
                    end

                    local Character = t2.value6.Character

                    if not Character then
                        return
                    end

                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                    if not HumanoidRootPart or not Humanoid then
                        return
                    end

                    t2.value173(Humanoid, Character)

                    if t2.value56() then
                        t2.value171()

                        return
                    end

                    Humanoid.AutoRotate = false

                    local v1219 = t2.value177()

                    if not v1219 or not v1219.Parent then
                        t2.value171()

                        return
                    end

                    pcall(function()
                        if sethiddenproperty then
                            sethiddenproperty(HumanoidRootPart, "PhysicsRepRootPart", v1219)
                        end
                    end)

                    local v1220 = tonumber(t2.value29.tpBatSideOffset) or 2.2
                    local LookVector = v1219.CFrame.LookVector
                    local vector3 = Vector3.new(LookVector.X, 0, LookVector.Z)
                    local v1223 = if not (vector3.Magnitude < 0.05) then Vector3.new(0, 1.2, 0) - vector3.Unit * v1220 else Vector3.new(0, 1.2, v1220)
                    local v1224 = v1219.Position + v1223
                    local Magnitude = (HumanoidRootPart.Position - v1224).Magnitude

                    if Magnitude > 10 then
                        HumanoidRootPart.CFrame = CFrame.new(v1224, v1219.Position)
                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                    elseif Magnitude > 2.5 then
                        local v1226 = v1224 - HumanoidRootPart.Position
                        local vector3_6 = Vector3.new(v1226.X, 0, v1226.Z)

                        if vector3_6.Magnitude > 0.05 then
                            HumanoidRootPart.AssemblyLinearVelocity = vector3_6.Unit * math.min(55, Magnitude * 8) + Vector3.new(0, HumanoidRootPart.AssemblyLinearVelocity.Y * 0.2, 0)
                        end

                        local vector3_7 = Vector3.new(v1219.Position.X - HumanoidRootPart.Position.X, 0, v1219.Position.Z - HumanoidRootPart.Position.Z)

                        if vector3_7.Magnitude > 0.1 then
                            HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + vector3_7.Unit)
                        end
                    else
                        local vector3_8 = Vector3.new(v1219.Position.X - HumanoidRootPart.Position.X, 0, v1219.Position.Z - HumanoidRootPart.Position.Z)

                        if vector3_8.Magnitude > 0.1 then
                            HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + vector3_8.Unit)
                        end

                        local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X * 0.5, math.max(AssemblyLinearVelocity.Y, -10), AssemblyLinearVelocity.Z * 0.5)
                    end

                    t2.value172(v1219.Position)
                    pcall(function()
                        local CurrentCamera = workspace.CurrentCamera

                        if CurrentCamera then
                            CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, v1219.Position)
                        end
                    end)
                    t2.value179(Character)
                    pcall(function()
                        local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
                        if AssemblyLinearVelocity.Magnitude > t2.value167 then
                            HumanoidRootPart.AssemblyLinearVelocity = AssemblyLinearVelocity.Unit * t2.value167
                        end
                        if HumanoidRootPart.AssemblyAngularVelocity.Magnitude > t2.value168 then
                            HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                        end
                        for v1528, v1529 in ipairs(Character:GetChildren()) do

                            if v1529:IsA("BasePart") and v1529 ~= HumanoidRootPart then
                                local AssemblyLinearVelocity3 = v1529.AssemblyLinearVelocity

                                if AssemblyLinearVelocity3.Magnitude > t2.value167 * 1.1 then
                                    v1529.AssemblyLinearVelocity = AssemblyLinearVelocity3.Unit * t2.value167
                                end

                                if v1529.AssemblyAngularVelocity.Magnitude > t2.value168 then
                                    v1529.AssemblyAngularVelocity = Vector3.zero
                                end
                            end
                        end
                        local AssemblyLinearVelocity4 = HumanoidRootPart.AssemblyLinearVelocity
                        if AssemblyLinearVelocity4.Magnitude > t2.value169 then
                            HumanoidRootPart.AssemblyLinearVelocity = AssemblyLinearVelocity4.Unit * t2.value169
                        end
                        if HumanoidRootPart.AssemblyAngularVelocity.Magnitude > t2.value170 then
                            HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                        end
                    end)
                end)

                if t2.value31.Buttons.tpBat then
                    t2.value31.Buttons.tpBat(true)
                end
            end
            function t2.value47()
                if t2.value162 then
                    t2.value162:Disconnect()
                end

                t2.value29.tpBatEnabled = false
                _G.HyperionTPBatActive = false
                t2.value174()
                t2.value171()
                pcall(v60)
                task.defer(function()
                    pcall(v60)
                end)
                task.delay(0.08, function()
                    pcall(v60)
                end)
                task.delay(0.2, function()
                    pcall(v60)
                end)

                if t2.value31.Buttons.tpBat then
                    t2.value31.Buttons.tpBat(false)
                end
            end
            function t2.value35()
                local normalSpeed = t2.value29.normalSpeed
                local carrySpeed = t2.value29.carrySpeed
                local laggerSpeed = t2.value29.laggerSpeed
                local speedType = t2.value29.speedType
                local laggerActive = t2.value29.laggerActive
                local safeMode = t2.value29.safeMode
                local autoLeftEnabled = t2.value29.autoLeftEnabled
                local autoRightEnabled = t2.value29.autoRightEnabled
                local infJumpEnabled = t2.value29.infJumpEnabled
                local infJumpMode = t2.value29.infJumpMode
                local antiRagdollEnabled = t2.value29.antiRagdollEnabled
                local medusaCounterEnabled = t2.value29.medusaCounterEnabled
                local medusaResetEnabled = t2.value29.medusaResetEnabled
                local antiDieEnabled = t2.value29.antiDieEnabled
                local unwalkEnabled = t2.value29.unwalkEnabled
                local autoTpDownEnabled = t2.value29.autoTpDownEnabled
                local autoTpDownY = t2.value29.autoTpDownY
                local batCounterEnabled = t2.value29.batCounterEnabled
                local guiScale = t2.value29.guiScale
                local tpBatEnabled = t2.value29.tpBatEnabled
                local tpBatSideOffset = t2.value29.tpBatSideOffset
                local autoSwingEnabled = t2.value29.autoSwingEnabled
                local autoBatToggled = t2.value29.autoBatToggled
                local aimbotTpDownSpam = t2.value29.aimbotTpDownSpam
                local batAimbotMode = t2.value29.batAimbotMode
                local mirrorTPDownEnabled = t2.value29.mirrorTPDownEnabled
                local animEnabled = t2.value29.animEnabled
                local stealBarEnabled = t2.value29.stealBarEnabled
                local speedESPEnabled = t2.value29.speedESPEnabled
                local guiLocked = t2.value29.guiLocked
                local fov = t2.value29.fov
                local musicSpeed = t2.value29.musicSpeed
                local v735 = t2.value29.introEnabled ~= false
                local value31Visible = t2.value31.Visible
                local value31Locked = t2.value31.Locked
                local t8 = {
					version = 1,
					normalSpeed = normalSpeed,
					carrySpeed = carrySpeed,
					laggerSpeed = laggerSpeed,
					speedType = speedType,
					laggerActive = laggerActive,
					safeMode = safeMode,
					autoLeftEnabled = autoLeftEnabled,
					autoRightEnabled = autoRightEnabled,
					infJumpEnabled = infJumpEnabled,
					infJumpMode = infJumpMode,
					antiRagdollEnabled = antiRagdollEnabled,
					medusaCounterEnabled = medusaCounterEnabled,
					medusaResetEnabled = medusaResetEnabled,
					antiDieEnabled = antiDieEnabled,
					unwalkEnabled = unwalkEnabled,
					autoTpDownEnabled = autoTpDownEnabled,
					autoTpDownY = autoTpDownY,
					batCounterEnabled = batCounterEnabled,
					guiScale = guiScale,
					tpBatEnabled = tpBatEnabled,
					tpBatSideOffset = tpBatSideOffset,
					autoSwingEnabled = autoSwingEnabled,
					autoBatToggled = autoBatToggled,
					aimbotTpDownSpam = aimbotTpDownSpam,
					batAimbotMode = batAimbotMode,
					mirrorTPDownEnabled = mirrorTPDownEnabled,
					animEnabled = animEnabled,
					stealBarEnabled = stealBarEnabled,
					speedESPEnabled = speedESPEnabled,
					guiLocked = guiLocked,
					fov = fov,
					musicSpeed = musicSpeed,
					stealRadius = 9,
					stealMode = "Semi",
					introEnabled = v735,
					mobileVisible = value31Visible,
					mobileLocked = value31Locked
				}

                for k, v in pairs(t2.value29) do
                    local v741 = k

                    if type(v741) == "string" and v741:sub(1, 3) == "key" and typeof(v) == "EnumItem" then
                        t8[v741] = v.Name
                    end
                end

                pcall(function()
                    if writefile then
                        local _writefile = writefile
                        local value5 = t2.value5
                        local JSONEncode = value5.JSONEncode

                        _writefile(t2.value27, JSONEncode(value5, t8))
                    end
                end)

                return true
            end;

            (function()
                pcall(function()
                    if not readfile or (not isfile or not isfile(t2.value27)) then
                        return
                    end

                    local data = t2.value5:JSONDecode(readfile(t2.value27))

                    if not data then
                        return
                    end

                    for k, v in pairs(data) do
                        local v1237 = k

                        if t2.value29[v1237] ~= nil and type(v) == type(t2.value29[v1237]) then
                            t2.value29[v1237] = v
                        end
                    end

                    if type(t2.value29.autoTpDownY) == "number" then
                        if t2.value29.autoTpDownY < 0 then
                            t2.value29.autoTpDownY = -t2.value29.autoTpDownY
                        end

                        if t2.value29.autoTpDownY > 20 then
                            t2.value29.autoTpDownY = 20
                        end
                    else
                        t2.value29.autoTpDownY = 8
                    end

                    if type(t2.value29.musicSpeed) == "number" then
                        if t2.value29.musicSpeed < 0.5 then
                            t2.value29.musicSpeed = 0.5
                        end

                        if t2.value29.musicSpeed > 2 then
                            t2.value29.musicSpeed = 2
                        end

                        t2.value29.musicSpeed = math.floor(t2.value29.musicSpeed * 10 + 0.5) / 10
                    else
                        t2.value29.musicSpeed = 1
                    end

                    for k, v in pairs(data) do
                        local v1240 = k

                        if type(v1240) == "string" and (v1240:sub(1, 3) == "key" and type(v) == "string") then
                            local v1241 = Enum.KeyCode[v]

                            if v1241 then
                                t2.value29[v1240] = v1241
                            end
                        end
                    end

                    if data.batAimbotMode == "v1" or data.batAimbotMode == "v2" then
                        t2.value29.batAimbotMode = data.batAimbotMode
                    else
                        t2.value29.batAimbotMode = "v1"
                    end

                    t2.value30.Mode = "Semi"
                    t2.value30.Radius = 12

                    if type(data.introEnabled) == "boolean" then
                        t2.value29.introEnabled = data.introEnabled
                    end

                    if type(data.mobileVisible) == "boolean" then
                        t2.value31.Visible = data.mobileVisible
                    end

                    if type(data.mobileLocked) == "boolean" then
                        t2.value31.Locked = data.mobileLocked
                    end
                end)
            end)()
            pcall(function()
                for _, v in ipairs({
					"HyperionVS",
					"HyperionVSButtons",
					"HyperionSafeModeLock",
					"HyperionHubStealBar",
					"HyperionHub",
					"HyperionHubButtons",
					"HyperionIntro",
					"HyperionMusicPanel",
					"HyperionHitboxHitter",
					"HyperionHubInstantReset",
					"HyperionHubLaggerUI",
					"HyperionHubTPBatUI"
				}) do
                    local v5 = t2.value7:FindFirstChild(v)

                    if v5 then
                        v5:Destroy()
                    end

                    local v7 = game:GetService("CoreGui"):FindFirstChild(v)

                    if v7 then
                        v7:Destroy()
                    end
                end
            end)
            t2.value180 = nil
            t2.value180 = false

            function t2.value181()
                local t9 = {}
                if t2.value29 and t2.value29.introEnabled == false then
                    return
                end
                if t2.value180 then
                    return
                end
                t2.value180 = true
                local function v743(p115)
                    if not p115 then
                        return nil
                    end
                    local u1243
                    pcall(function()
                        if getcustomasset then
                            u1243 = getcustomasset(p115)
                        end

                        if not u1243 and (syn and syn.getcustomasset) then
                            u1243 = syn.getcustomasset(p115)
                        end

                        if not u1243 and getsynasset then
                            u1243 = getsynasset(p115)
                        end
                    end)
                    if u1243 and u1243 ~= "" then
                        return u1243
                    end

                    return nil
                end
                local function v744(p116)
                    local ok, result = pcall(function()
                        return game:HttpGet(p116)
                    end)

                    if ok then
                        ok = result and #result > 100
                    end

                    if ok then
                        return result
                    end

                    return nil
                end
                function t9.value1(p117)
                    if not p117 then
                        return
                    end

                    pcall(function()
                        if syn and syn.protect_gui then
                            syn.protect_gui(p117)
                        end
                    end)

                    local u1248 = false

                    pcall(function()
                        if gethui then
                            p117.Parent = gethui()
                            u1248 = true
                        end
                    end)

                    if not u1248 then
                        pcall(function()
                            p117.Parent = game:GetService("CoreGui")
                            u1248 = true
                        end)
                    end

                    if not u1248 then
                        pcall(function()
                            p117.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
                        end)
                    end
                end
                t9.value4 = "IrishHub"
                t9.value4 = {
					[v2589] = "rbxassetid://131513419838182",
					GreenDuels = "rbxassetid://79052318194557",
					VampireHub = "rbxassetid://108632168923336",
					AceDuels = "rbxassetid://86968392795085",
					HyperionDuels = "rbxassetid://95589904723107"
				}
                t9.value2 = "rbxassetid://132182797103598"
                t9.value3 = 0.95
                Color3.fromRGB(255, 30, 50)
                t9.value5 = Color3.fromRGB(255, 65, 80)
                local value5 = t9.value5
                t9.value5 = Color3.fromRGB(168, 85, 247)
                local value5_2 = t9.value5
                t9.value5 = Color3.fromRGB(0, 230, 255)
                local value5_3 = t9.value5
                t9.value5 = Color3.fromRGB(10, 8, 20)
                local color3 = Color3.fromRGB(5, 4, 10)
                local color3_3 = Color3.fromRGB(245, 245, 250)
                local Players = game:GetService("Players")
                t9.value6 = game:GetService("TweenService")
                local value6 = t9.value6
                t9.value6 = game:GetService("RunService")
                local value6_2 = t9.value6
                t9.value6 = game:GetService("SoundService")
                local LocalPlayer = Players.LocalPlayer
                local CurrentCamera = workspace.CurrentCamera
                while not CurrentCamera do
                    value6_2.RenderStepped:Wait()
                    CurrentCamera = workspace.CurrentCamera
                end
                pcall(function()
                    local v1249 = LocalPlayer and (LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("HyperionDuelsIntro"))

                    if v1249 then
                        v1249:Destroy()
                    end

                    local HyperionDuelsIntro = game:GetService("CoreGui"):FindFirstChild("HyperionDuelsIntro")

                    if HyperionDuelsIntro then
                        HyperionDuelsIntro:Destroy()
                    end
                end)
                local ScreenGui = Instance.new("ScreenGui")
                ScreenGui.Name = "HyperionDuelsIntro"
                ScreenGui.IgnoreGuiInset = true
                ScreenGui.ResetOnSpawn = false
                ScreenGui.DisplayOrder = 999999
                ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                t9.value1(ScreenGui)
                local Sound = Instance.new("Sound")
                Sound.Name = "HyperionIntroSong"
                Sound.Volume = 0.55
                Sound.Looped = false
                Sound.Parent = t9.value6
                local Sound2 = Instance.new("Sound")
                Sound2.Name = "HyperionImpactSound"
                Sound2.SoundId = t9.value2
                Sound2.Volume = t9.value3
                Sound2.Looped = false
                Sound2.Parent = t9.value6
                local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")
                EqualizerSoundEffect.LowGain = 4
                EqualizerSoundEffect.MidGain = 2
                EqualizerSoundEffect.HighGain = -1
                EqualizerSoundEffect.Parent = Sound2
                local DistortionSoundEffect = Instance.new("DistortionSoundEffect")
                DistortionSoundEffect.Level = 0.08
                DistortionSoundEffect.Parent = Sound2
                local u760 = true
                local u761
                local function v762()
                    pcall(function()
                        Sound2:Stop()
                        Sound2.TimePosition = 0
                        Sound2:Play()
                    end)
                end
                local t10 = {
					"https://files.catbox.moe/8ch5qz.mp3",
					"https://files.catbox.moe/8oogdu.mp3",
					"https://files.catbox.moe/gm26vl.mp3",
					"https://files.catbox.moe/m5kxm3.mp3",
					"https://files.catbox.moe/zuid5n.mp3",
					"https://files.catbox.moe/z6eqnt.mp3",
					"https://files.catbox.moe/t0nlhv.mp3",
					"https://files.catbox.moe/mthg31.mp3",
					"https://files.catbox.moe/ddnbup.mp3",
					"https://files.catbox.moe/uf7506.mp3"
				}
                t9.value8 = math.clamp(tonumber(selectedIntroMusic) or 1, 1, #t10)
                local v764 = t10[t9.value8]
                t9.value7 = tostring(t9.value8) .. ".mp3"
                local v765 = "HyperionHubIntro_" .. t9.value7
                local u766
                task.spawn(function()
                    local v1251 = v743(v765)
                    if v1251 then
                        u766 = v1251

                        return
                    end
                    local u1252
                    pcall(function()
                        if v744 then
                            local v1532 = v764
                            local ok, result = pcall(function()
                                return game:HttpGet(v1532)
                            end)

                            if ok then
                                ok = result and #result > 100
                            end

                            u1252 = if not ok then nil else result
                        end
                    end)
                    if not u1252 or #u1252 < 1000 then
                        pcall(function()
                            u1252 = game:HttpGet(v764)
                        end)
                    end
                    if u1252 and #u1252 > 1000 then
                        pcall(function()
                            if writefile then
                                writefile(v765, u1252)
                            end
                        end)
                        task.wait(0.05)
                        u766 = v743(v765)
                    end
                end)
                local function v767(p118, p119, p120, p121, p122)
                    local v1258 = value6
                    local new = TweenInfo.new

                    if not p121 then
                        p121 = Enum.EasingStyle.Quint
                    end

                    local v1260 = v1258:Create(p118, new(p119, p121, p122 or Enum.EasingDirection.Out), p120)

                    v1260:Play()

                    return v1260
                end
                t9.value9 = Instance.new("Frame")
                t9.value11 = UDim2.fromScale(1, 1)
                t9.value9.Size = t9.value11
                t9.value9.BackgroundColor3 = color3
                t9.value9.BorderSizePixel = 0
                t9.value9.Parent = ScreenGui
                t9.value10 = Instance.new("ImageLabel")
                t9.value10.Name = "HyperionIntroBg"
                t9.value12 = UDim2.fromScale(1.04, 1.04)
                t9.value10.Size = t9.value12
                t9.value12 = UDim2.fromScale(0.5, 0.5)
                t9.value10.Position = t9.value12
                t9.value12 = Vector2.new(0.5, 0.5)
                t9.value10.AnchorPoint = t9.value12
                t9.value10.Image = t2.value25
                t9.value11 = Enum.ScaleType.Crop
                t9.value10.ScaleType = t9.value11
                t9.value10.BackgroundTransparency = 1
                t9.value10.ImageTransparency = 0.32
                t9.value10.ZIndex = 1
                t9.value10.Parent = t9.value9
                t9.value11 = Instance.new("Frame")
                t9.value13 = UDim2.fromScale(1, 1)
                t9.value11.Size = t9.value13
                t9.value13 = Color3.fromRGB(8, 6, 16)
                t9.value11.BackgroundColor3 = t9.value13
                t9.value11.BackgroundTransparency = 0.35
                t9.value11.BorderSizePixel = 0
                t9.value11.ZIndex = 2
                t9.value11.Parent = t9.value9
                t9.value12 = Instance.new("UIGradient", t9.value11)
                t9.value13 = ColorSequence.new
                t9.value16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 10, 40))
                t9.value18 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(5, 4, 12))
                t9.value15 = ColorSequenceKeypoint.new
                t9.value19 = Color3.fromRGB
                local v768 = t9.value13({
					t9.value16,
					t9.value18,
					t9.value15(1, t9.value19(20, 10, 40))
				})
                t9.value12.Color = v768
                t9.value12.Rotation = 45
                t9.value13 = Instance.new("Frame")
                local vector2 = Vector2.new(0.5, 0.5)
                t9.value13.AnchorPoint = vector2
                local uDim2 = UDim2.fromScale(0.5, 0.5)
                t9.value13.Position = uDim2
                local uDim2_21 = UDim2.fromScale(0.7, 0.7)
                t9.value13.Size = uDim2_21
                t9.value13.BackgroundColor3 = value5_2
                t9.value13.BackgroundTransparency = 0.92
                t9.value13.BorderSizePixel = 0
                t9.value13.ZIndex = 3
                t9.value13.Parent = t9.value9
                local UICorner = Instance.new("UICorner", t9.value13)
                t9.value15 = UDim.new(1, 0)
                UICorner.CornerRadius = t9.value15
                local Frame = Instance.new("Frame")
                t9.value16 = UDim2.fromScale(1, 1)
                Frame.Size = t9.value16
                Frame.BackgroundColor3 = color3_3
                Frame.BackgroundTransparency = 1
                Frame.BorderSizePixel = 0
                Frame.ZIndex = 999
                Frame.Parent = ScreenGui
                local CanvasGroup = Instance.new("CanvasGroup")
                t9.value15 = "AnchorPoint"
                t9.value18 = Vector2.new(0.5, 0.5)
                CanvasGroup[t9.value15] = t9.value18
                t9.value15 = "Position"
                t9.value18 = UDim2.fromScale(0.5, 0.5)
                CanvasGroup[t9.value15] = t9.value18
                t9.value15 = "BackgroundTransparency"
                CanvasGroup[t9.value15] = 1
                t9.value15 = "GroupTransparency"
                CanvasGroup[t9.value15] = 0
                t9.value15 = "ZIndex"
                CanvasGroup[t9.value15] = 10
                t9.value15 = "Parent"
                CanvasGroup[t9.value15] = ScreenGui
                t9.value15 = Instance.new("UIScale")
                t9.value15.Scale = 1
                t9.value15.Parent = CanvasGroup
                t9.value16 = Instance.new("Frame")
                local uDim2_22 = UDim2.fromScale(1, 1)
                t9.value16.Size = uDim2_22
                t9.value16.BackgroundColor3 = t9.value5
                t9.value16.BackgroundTransparency = 0.08
                t9.value16.BorderSizePixel = 0
                t9.value16.ClipsDescendants = true
                t9.value16.Parent = CanvasGroup
                t9.value18 = Instance.new("UICorner", t9.value16)
                local uDim = UDim.new(0, 16)
                t9.value18.CornerRadius = uDim
                t9.value18 = Instance.new("UIStroke")
                t9.value18.Color = value5_2
                t9.value18.Thickness = 2
                t9.value18.Transparency = 0.2
                local Border = Enum.ApplyStrokeMode.Border
                t9.value18.ApplyStrokeMode = Border
                t9.value18.Parent = t9.value16
                local UIGradient = Instance.new("UIGradient", t9.value18)
                t9.value19 = ColorSequence.new
                t9.value14 = ColorSequenceKeypoint.new(0, value5_2)
                local colorSequenceKeypoint = ColorSequenceKeypoint.new(0.5, value5_3)
                t9.value22 = ColorSequenceKeypoint.new
                t9.value20 = t9.value19({
					t9.value14,
					colorSequenceKeypoint,
					t9.value22(1, value5_2)
				})
                UIGradient.Color = t9.value20
                local Frame2 = Instance.new("Frame")
                t9.value19 = "Size"
                t9.value21 = UDim2.new(1, 0, 0, 32)
                Frame2[t9.value19] = t9.value21
                t9.value19 = "BackgroundColor3"
                t9.value21 = Color3.fromRGB(15, 12, 28)
                Frame2[t9.value19] = t9.value21
                t9.value19 = "BackgroundTransparency"
                Frame2[t9.value19] = 0.2
                t9.value19 = "BorderSizePixel"
                Frame2[t9.value19] = 0
                t9.value19 = "ZIndex"
                Frame2[t9.value19] = 35
                t9.value19 = "Parent"
                Frame2[t9.value19] = t9.value16
                t9.value19 = Instance.new("TextLabel")
                t9.value21 = UDim2.new(0, 14, 0.5, -9)
                t9.value19.Position = t9.value21
                t9.value21 = UDim2.new(0, 220, 0, 18)
                t9.value19.Size = t9.value21
                t9.value19.BackgroundTransparency = 1
                t9.value19.Text = "[ HYPERION // PROTOCOL 01 ]"
                t9.value19.TextColor3 = value5_3
                t9.value20 = Enum.Font.GothamBold
                t9.value19.Font = t9.value20
                t9.value19.TextSize = 11
                t9.value20 = Enum.TextXAlignment.Left
                t9.value19.TextXAlignment = t9.value20
                t9.value19.ZIndex = 36
                t9.value19.Parent = Frame2
                t9.value20 = Instance.new("TextLabel")
                t9.value22 = UDim2.new(1, -150, 0.5, -9)
                t9.value20.Position = t9.value22
                t9.value22 = UDim2.new(0, 136, 0, 18)
                t9.value20.Size = t9.value22
                t9.value20.BackgroundTransparency = 1
                t9.value20.Text = "TARGET ELIMINATION"
                t9.value20.TextColor3 = value5
                t9.value21 = Enum.Font.GothamBold
                t9.value20.Font = t9.value21
                t9.value20.TextSize = 10
                t9.value21 = Enum.TextXAlignment.Right
                t9.value20.TextXAlignment = t9.value21
                t9.value20.ZIndex = 36
                t9.value20.Parent = Frame2
                t9.value21 = Instance.new("Frame")
                local value21 = t9.value21
                t9.value21 = value21
                t9.value22 = "Position"
                local uDim2_23 = UDim2.new(0, 6, 0, 36)
                t9.value21[t9.value22] = uDim2_23
                t9.value21 = value21
                t9.value22 = "Size"
                local uDim2_24 = UDim2.new(1, -12, 1, -42)
                t9.value21[t9.value22] = uDim2_24
                t9.value21 = value21
                t9.value22 = "BackgroundColor3"
                local color3_4 = Color3.fromRGB(8, 6, 16)
                t9.value21[t9.value22] = color3_4
                t9.value21 = value21
                t9.value22 = "BackgroundTransparency"
                t9.value21[t9.value22] = 0.4
                t9.value21 = value21
                t9.value22 = "BorderSizePixel"
                t9.value21[t9.value22] = 0
                t9.value21 = value21
                t9.value22 = "ClipsDescendants"
                t9.value21[t9.value22] = true
                t9.value21 = value21
                t9.value22 = "Parent"
                t9.value21[t9.value22] = t9.value16
                t9.value22 = Instance.new("UICorner", value21)
                t9.value21 = "CornerRadius"
                local uDim3 = UDim.new(0, 12)
                t9.value22[t9.value21] = uDim3
                local IrishHub = t9.value4.IrishHub
                local uDim2_25 = UDim2.new(0, 3, 0, 3)
                local uDim2_26 = UDim2.new(0.5, -6, 0.5, -6)
                t9.value22 = {
					name = "IRISH HUB",
					tag = "TARGET [01]",
					image = IrishHub,
					pos = uDim2_25,
					size = uDim2_26
				}
                local GreenDuels = t9.value4.GreenDuels
                local uDim2_27 = UDim2.new(0.5, 3, 0, 3)
                local uDim2_28 = UDim2.new(0.5, -6, 0.5, -6)
                t9.value14 = {
					name = "GREEN DUELS",
					tag = "TARGET [02]",
					image = GreenDuels,
					pos = uDim2_27,
					size = uDim2_28
				}
                local VampireHub = t9.value4.VampireHub
                local uDim2_29 = UDim2.new(0, 3, 0.5, 3)
                local uDim2_30 = UDim2.new(0.5, -6, 0.5, -6)
                local t11 = {
					name = "VAMPIRE HUB",
					tag = "TARGET [03]",
					image = VampireHub,
					pos = uDim2_29,
					size = uDim2_30
				}
                local AceDuels = t9.value4.AceDuels
                local uDim2_31 = UDim2.new(0.5, 3, 0.5, 3)
                local uDim2_32 = UDim2.new(0.5, -6, 0.5, -6)
                t9.value21 = {
					t9.value22,
					t9.value14,
					t11,
					{
						name = "ACE DUELS",
						tag = "TARGET [04]",
						image = AceDuels,
						pos = uDim2_31,
						size = uDim2_32
					}
				}
                local t12 = {}
                function t9.value22(p123, _)
                    local CanvasGroup2 = Instance.new("CanvasGroup")

                    CanvasGroup2.Name = p123.name
                    CanvasGroup2.Position = p123.pos
                    CanvasGroup2.Size = p123.size
                    CanvasGroup2.BackgroundColor3 = Color3.fromRGB(14, 11, 24)
                    CanvasGroup2.BorderSizePixel = 0
                    CanvasGroup2.ClipsDescendants = true
                    CanvasGroup2.GroupTransparency = 1
                    CanvasGroup2.ZIndex = 12
                    CanvasGroup2.Parent = value21
                    Instance.new("UICorner", CanvasGroup2).CornerRadius = UDim.new(0, 10)

                    local UIStroke = Instance.new("UIStroke")

                    UIStroke.Color = Color3.fromRGB(50, 40, 75)
                    UIStroke.Thickness = 1.2
                    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    UIStroke.Parent = CanvasGroup2

                    local UIScale = Instance.new("UIScale")

                    UIScale.Scale = 1.15
                    UIScale.Parent = CanvasGroup2

                    local ImageLabel = Instance.new("ImageLabel")

                    ImageLabel.Size = UDim2.fromScale(1, 1)
                    ImageLabel.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
                    ImageLabel.BorderSizePixel = 0
                    ImageLabel.Image = p123.image
                    ImageLabel.ScaleType = Enum.ScaleType.Crop
                    ImageLabel.ImageTransparency = 0
                    ImageLabel.ZIndex = 13
                    ImageLabel.Parent = CanvasGroup2

                    local Frame3 = Instance.new("Frame")

                    Frame3.Size = UDim2.fromScale(1, 1)
                    Frame3.BackgroundColor3 = color3
                    Frame3.BackgroundTransparency = 0.25
                    Frame3.BorderSizePixel = 0
                    Frame3.ZIndex = 14
                    Frame3.Parent = CanvasGroup2

                    local Frame4 = Instance.new("Frame")

                    Frame4.Size = UDim2.new(1, 0, 0, 22)
                    Frame4.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
                    Frame4.BackgroundTransparency = 0.3
                    Frame4.BorderSizePixel = 0
                    Frame4.ZIndex = 15
                    Frame4.Parent = CanvasGroup2

                    local TextLabel = Instance.new("TextLabel")

                    TextLabel.Position = UDim2.new(0, 8, 0, 0)
                    TextLabel.Size = UDim2.new(1, -16, 1, 0)
                    TextLabel.BackgroundTransparency = 1
                    TextLabel.Text = p123.tag .. " // " .. p123.name
                    TextLabel.TextColor3 = color3_3
                    TextLabel.Font = Enum.Font.GothamBold
                    TextLabel.TextSize = 11
                    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                    TextLabel.ZIndex = 16
                    TextLabel.Parent = Frame4

                    local Frame5 = Instance.new("Frame")

                    Frame5.AnchorPoint = Vector2.new(0.5, 0.5)
                    Frame5.Position = UDim2.fromScale(-0.55, 0.58)
                    Frame5.Size = UDim2.new(0.92, 0, 0.26, 0)
                    Frame5.BackgroundColor3 = Color3.fromRGB(20, 4, 8)
                    Frame5.BackgroundTransparency = 0.05
                    Frame5.BorderSizePixel = 0
                    Frame5.Rotation = -3
                    Frame5.ZIndex = 20
                    Frame5.Parent = CanvasGroup2
                    Instance.new("UICorner", Frame5).CornerRadius = UDim.new(0, 6)

                    local UIStroke2 = Instance.new("UIStroke")

                    UIStroke2.Color = value5
                    UIStroke2.Thickness = 1.8
                    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    UIStroke2.Parent = Frame5

                    local TextLabel2 = Instance.new("TextLabel")

                    TextLabel2.Size = UDim2.fromScale(1, 1)
                    TextLabel2.BackgroundTransparency = 1
                    TextLabel2.Text = "// MOGGED //"
                    TextLabel2.TextColor3 = value5
                    TextLabel2.Font = Enum.Font.GothamBlack
                    TextLabel2.TextScaled = true
                    TextLabel2.ZIndex = 21
                    TextLabel2.Parent = Frame5

                    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

                    UITextSizeConstraint.MinTextSize = 14
                    UITextSizeConstraint.MaxTextSize = 34
                    UITextSizeConstraint.Parent = TextLabel2

                    return {
						group = CanvasGroup2,
						scale = UIScale,
						stroke = UIStroke,
						bar = Frame5,
						text = TextLabel2,
						darken = Frame3
					}
                end
                for i, v in ipairs(t9.value21) do
                    t12[i] = t9.value22(v, i)
                end
                local CanvasGroup3 = Instance.new("CanvasGroup")
                t9.value17 = "Size"
                local uDim2_33 = UDim2.fromScale(1, 1)
                CanvasGroup3[t9.value17] = uDim2_33
                t9.value17 = "BackgroundTransparency"
                CanvasGroup3[t9.value17] = 1
                t9.value17 = "GroupTransparency"
                CanvasGroup3[t9.value17] = 1
                t9.value17 = "Visible"
                CanvasGroup3[t9.value17] = false
                t9.value17 = "ZIndex"
                CanvasGroup3[t9.value17] = 40
                t9.value17 = "Parent"
                CanvasGroup3[t9.value17] = value21
                t9.value17 = Instance.new("ImageLabel")
                local uDim2_34 = UDim2.fromScale(1, 1)
                t9.value17.Size = uDim2_34
                t9.value17.Image = t2.value25
                local Crop = Enum.ScaleType.Crop
                t9.value17.ScaleType = Crop
                t9.value17.BackgroundTransparency = 1
                t9.value17.ImageTransparency = 0.45
                t9.value17.ZIndex = 41
                t9.value17.Parent = CanvasGroup3
                local Frame6 = Instance.new("Frame")
                Frame6.AnchorPoint = Vector2.new(0.5, 0.5)
                Frame6.Position = UDim2.fromScale(0.5, 0.4)
                Frame6.Size = UDim2.fromOffset(135, 135)
                Frame6.BackgroundColor3 = Color3.fromRGB(16, 12, 30)
                Frame6.BackgroundTransparency = 0.15
                Frame6.BorderSizePixel = 0
                Frame6.ZIndex = 42
                Frame6.Parent = CanvasGroup3
                Instance.new("UICorner", Frame6).CornerRadius = UDim.new(1, 0)
                local UIStroke = Instance.new("UIStroke")
                UIStroke.Color = value5_2
                UIStroke.Thickness = 2.5
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                UIStroke.Parent = Frame6
                local UIGradient2 = Instance.new("UIGradient", UIStroke)
                UIGradient2.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, value5_2),
					ColorSequenceKeypoint.new(0.5, value5_3),
					ColorSequenceKeypoint.new(1, value5_2)
				})
                local ImageLabel = Instance.new("ImageLabel")
                ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
                ImageLabel.Size = UDim2.fromScale(0.85, 0.85)
                ImageLabel.Image = t2.value26
                ImageLabel.ScaleType = Enum.ScaleType.Fit
                ImageLabel.BackgroundTransparency = 1
                ImageLabel.ZIndex = 43
                ImageLabel.Parent = Frame6
                local Frame7 = Instance.new("Frame")
                Frame7.AnchorPoint = Vector2.new(0.5, 0.5)
                Frame7.Position = UDim2.fromScale(0.5, 0.65)
                Frame7.Size = UDim2.new(0, 160, 0, 22)
                Frame7.BackgroundColor3 = Color3.fromRGB(24, 16, 45)
                Frame7.BackgroundTransparency = 0.15
                Frame7.BorderSizePixel = 0
                Frame7.ZIndex = 44
                Frame7.Parent = CanvasGroup3
                Instance.new("UICorner", Frame7).CornerRadius = UDim.new(0, 6)
                local UIStroke3 = Instance.new("UIStroke", Frame7)
                UIStroke3.Color = value5_3
                UIStroke3.Thickness = 1
                UIStroke3.Transparency = 0.3
                local TextLabel = Instance.new("TextLabel")
                TextLabel.Size = UDim2.fromScale(1, 1)
                TextLabel.BackgroundTransparency = 1
                TextLabel.Text = " APEX OF DUELS "
                TextLabel.TextColor3 = value5_3
                TextLabel.Font = Enum.Font.GothamBold
                TextLabel.TextSize = 10
                TextLabel.ZIndex = 45
                TextLabel.Parent = Frame7
                local TextLabel3 = Instance.new("TextLabel")
                TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5)
                TextLabel3.Position = UDim2.fromScale(0.5, 0.76)
                TextLabel3.Size = UDim2.new(0.9, 0, 0.12, 0)
                TextLabel3.BackgroundTransparency = 1
                TextLabel3.Text = "HYPERION DUELS"
                TextLabel3.TextColor3 = color3_3
                TextLabel3.Font = Enum.Font.GothamBlack
                TextLabel3.TextScaled = true
                TextLabel3.ZIndex = 46
                TextLabel3.Parent = CanvasGroup3
                local UIStroke4 = Instance.new("UIStroke", TextLabel3)
                UIStroke4.Color = value5_2
                UIStroke4.Thickness = 2
                UIStroke4.Transparency = 0.2
                local TextLabel4 = Instance.new("TextLabel")
                TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5)
                TextLabel4.Position = UDim2.fromScale(0.5, 0.87)
                TextLabel4.Size = UDim2.new(0.9, 0, 0.05, 0)
                TextLabel4.BackgroundTransparency = 1
                TextLabel4.Text = "> SUPREMACY CONFIRMED - ALL TARGETS ELIMINATED <"
                TextLabel4.TextColor3 = Color3.fromRGB(160, 255, 200)
                TextLabel4.Font = Enum.Font.GothamBold
                TextLabel4.TextScaled = true
                TextLabel4.ZIndex = 46
                TextLabel4.Parent = CanvasGroup3
                local CanvasGroup4 = Instance.new("CanvasGroup")
                CanvasGroup4.Size = UDim2.fromScale(1, 1)
                CanvasGroup4.BackgroundTransparency = 1
                CanvasGroup4.GroupTransparency = 1
                CanvasGroup4.Visible = false
                CanvasGroup4.ZIndex = 50
                CanvasGroup4.Parent = value21
                local Frame8 = Instance.new("Frame")
                Frame8.AnchorPoint = Vector2.new(0.5, 0.5)
                Frame8.Position = UDim2.fromScale(0.5, 0.4)
                Frame8.Size = UDim2.fromOffset(160, 160)
                Frame8.BackgroundTransparency = 1
                Frame8.ZIndex = 52
                Frame8.Parent = CanvasGroup4
                Instance.new("UICorner", Frame8).CornerRadius = UDim.new(1, 0)
                local UIStroke5 = Instance.new("UIStroke")
                UIStroke5.Color = value5_2
                UIStroke5.Thickness = 2.2
                UIStroke5.Transparency = 0.25
                UIStroke5.Parent = Frame8
                local Frame9 = Instance.new("Frame")
                Frame9.AnchorPoint = Vector2.new(0.5, 0.5)
                Frame9.Position = UDim2.fromScale(0.5, 0.4)
                Frame9.Size = UDim2.fromOffset(200, 200)
                Frame9.BackgroundTransparency = 1
                Frame9.ZIndex = 51
                Frame9.Parent = CanvasGroup4
                Instance.new("UICorner", Frame9).CornerRadius = UDim.new(1, 0)
                local UIStroke6 = Instance.new("UIStroke")
                UIStroke6.Color = value5_3
                UIStroke6.Thickness = 1.6
                UIStroke6.Transparency = 0.4
                UIStroke6.Parent = Frame9
                local ImageLabel2 = Instance.new("ImageLabel")
                ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
                ImageLabel2.Position = UDim2.fromScale(0.5, 0.4)
                ImageLabel2.Size = UDim2.fromOffset(90, 90)
                ImageLabel2.Image = t2.value26
                ImageLabel2.ScaleType = Enum.ScaleType.Fit
                ImageLabel2.BackgroundTransparency = 1
                ImageLabel2.ZIndex = 53
                ImageLabel2.Parent = CanvasGroup4
                local t13 = {}
                for i = 1, 12 do
                    local v824 = i
                    local Frame10 = Instance.new("Frame")

                    Frame10.AnchorPoint = Vector2.new(0.5, 0.5)

                    local fromOffset = UDim2.fromOffset
                    local v827 = 4 + v824 % 3

                    Frame10.Size = fromOffset(4 + v824 % 3, v827)
                    Frame10.BackgroundColor3 = v824 % 2 == 0 and value5_3 or value5_2
                    Frame10.BackgroundTransparency = 0.2
                    Frame10.BorderSizePixel = 0
                    Frame10.ZIndex = 55
                    Frame10.Parent = CanvasGroup4
                    Instance.new("UICorner", Frame10).CornerRadius = UDim.new(1, 0)

                    local v828 = v824 / 12 * 3.141592653589793 * 2
                    local v829 = 0.8 + v824 % 4 * 0.2

                    t9.value24 = 75 + v824 % 4 * 15
                    t13[v824] = {
						gui = Frame10,
						angle = v828,
						speed = v829,
						radius = t9.value24
					}
                end
                local Frame11 = Instance.new("Frame")
                Frame11.AnchorPoint = Vector2.new(0.5, 0.5)
                Frame11.Position = UDim2.fromScale(0.5, 0.72)
                Frame11.Size = UDim2.new(0.58, 0, 0, 16)
                Frame11.BackgroundColor3 = Color3.fromRGB(15, 12, 28)
                Frame11.BackgroundTransparency = 0.2
                Frame11.BorderSizePixel = 0
                Frame11.ClipsDescendants = true
                Frame11.ZIndex = 60
                Frame11.Parent = CanvasGroup4
                Instance.new("UICorner", Frame11).CornerRadius = UDim.new(1, 0)
                local UIStroke7 = Instance.new("UIStroke")
                UIStroke7.Color = value5_3
                UIStroke7.Thickness = 1.2
                UIStroke7.Transparency = 0.3
                UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                UIStroke7.Parent = Frame11
                local Frame12 = Instance.new("Frame")
                Frame12.Size = UDim2.fromScale(0, 1)
                Frame12.BackgroundColor3 = value5_3
                Frame12.BorderSizePixel = 0
                Frame12.ZIndex = 61
                Frame12.Parent = Frame11
                Instance.new("UICorner", Frame12).CornerRadius = UDim.new(1, 0)
                local UIGradient3 = Instance.new("UIGradient", Frame12)
                local new = ColorSequence.new
                local colorSequenceKeypoint4 = ColorSequenceKeypoint.new(0, value5_3)
                local colorSequenceKeypoint5 = ColorSequenceKeypoint.new(0.5, value5_2)
                local new2 = ColorSequenceKeypoint.new
                t9.value23 = Color3.fromRGB
                UIGradient3.Color = new({
					colorSequenceKeypoint4,
					colorSequenceKeypoint5,
					new2(1, t9.value23(247, 37, 133))
				})
                local TextLabel5 = Instance.new("TextLabel")
                TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5)
                TextLabel5.Position = UDim2.fromScale(0.5, 0.81)
                TextLabel5.Size = UDim2.new(0.5, 0, 0.06, 0)
                TextLabel5.BackgroundTransparency = 1
                TextLabel5.Text = "0%"
                TextLabel5.TextColor3 = color3_3
                TextLabel5.Font = Enum.Font.GothamBlack
                TextLabel5.TextScaled = true
                TextLabel5.ZIndex = 62
                TextLabel5.Parent = CanvasGroup4
                local TextLabel6 = Instance.new("TextLabel")
                TextLabel6.AnchorPoint = Vector2.new(0.5, 0.5)
                TextLabel6.Position = UDim2.fromScale(0.5, 0.89)
                TextLabel6.Size = UDim2.new(0.85, 0, 0.045, 0)
                TextLabel6.BackgroundTransparency = 1
                TextLabel6.Text = "INITIALIZING HYPERION ENGINE..."
                TextLabel6.TextColor3 = value5_3
                TextLabel6.Font = Enum.Font.GothamBold
                TextLabel6.TextScaled = true
                TextLabel6.ZIndex = 62
                TextLabel6.Parent = CanvasGroup4
                local TextButton = Instance.new("TextButton")
                TextButton.AnchorPoint = Vector2.new(1, 1)
                TextButton.Position = UDim2.new(1, -20, 1, -20)
                TextButton.Size = UDim2.fromOffset(105, 34)
                TextButton.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
                TextButton.BackgroundTransparency = 0.2
                TextButton.BorderSizePixel = 0
                TextButton.Text = "SKIP >>"
                TextButton.TextColor3 = color3_3
                TextButton.Font = Enum.Font.GothamBold
                TextButton.TextSize = 11
                TextButton.AutoButtonColor = true
                TextButton.ZIndex = 990
                TextButton.Parent = ScreenGui
                Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)
                local UIStroke8 = Instance.new("UIStroke", TextButton)
                UIStroke8.Color = value5_2
                UIStroke8.Thickness = 1.2
                UIStroke8.Transparency = 0.3
                local function v842()
                    local ViewportSize = CurrentCamera.ViewportSize
                    local v1275 = math.clamp(ViewportSize.X * 0.72, 340, 520)
                    local v1276 = math.clamp(ViewportSize.Y * 0.74, 380, 560)

                    CanvasGroup.Size = UDim2.fromOffset(v1275, v1276)
                end
                local ViewportSize = CurrentCamera.ViewportSize
                local v844 = math.clamp(ViewportSize.X * 0.72, 340, 520)
                local v845 = math.clamp(ViewportSize.Y * 0.74, 380, 560)
                CanvasGroup.Size = UDim2.fromOffset(v844, v845)
                pcall(function()
                    if CurrentCamera then
                        CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v842)
                    end
                end)
                local function v846(p125, p126)
                    local CanvasGroupPosition = CanvasGroup.Position
                    local timestamp = tick()

                    while p126 > tick() - timestamp and u760 do
                        local v1281 = 1 - (tick() - timestamp) / p126
                        local v1282 = (math.random() - 0.5) * p125 * v1281
                        local v1283 = (math.random() - 0.5) * p125 * v1281

                        CanvasGroup.Position = UDim2.new(CanvasGroupPosition.X.Scale, CanvasGroupPosition.X.Offset + v1282, CanvasGroupPosition.Y.Scale, CanvasGroupPosition.Y.Offset + v1283)
                        value6_2.RenderStepped:Wait()
                    end

                    if CanvasGroup and CanvasGroup.Parent then
                        CanvasGroup.Position = CanvasGroupPosition
                    end
                end
                local function v847(p127)
                    local Frame13 = Instance.new("Frame")

                    Frame13.AnchorPoint = Vector2.new(0.5, 0.5)
                    Frame13.Position = UDim2.fromScale(0.5, 0.5)
                    Frame13.Size = UDim2.fromOffset(30, 30)
                    Frame13.BackgroundTransparency = 1
                    Frame13.ZIndex = 96
                    Frame13.Parent = CanvasGroup
                    Instance.new("UICorner", Frame13).CornerRadius = UDim.new(1, 0)

                    local UIStroke9 = Instance.new("UIStroke", Frame13)

                    if not p127 then
                        p127 = value5
                    end

                    UIStroke9.Color = p127
                    UIStroke9.Thickness = 4
                    UIStroke9.Transparency = 0.1
                    v767(Frame13, 0.65, {
						Size = UDim2.fromOffset(560, 560)
					}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                    v767(UIStroke9, 0.65, {
						Transparency = 1,
						Thickness = 0.5
					}, Enum.EasingStyle.Quad)
                    task.delay(0.7, function()
                        pcall(function()
                            Frame13:Destroy()
                        end)
                    end)
                end
                local function v848()
                    if not u760 then
                        t2.value180 = false

                        return
                    end

                    u760 = false

                    if u761 then
                        u761:Disconnect()
                        u761 = nil
                    end

                    pcall(function()
                        v767(ScreenGui, 0.35, {})
                        v767(Sound, 0.45, {
							Volume = 0
						})
                        v767(Sound2, 0.3, {
							Volume = 0
						})
                    end)
                    task.wait(0.35)
                    pcall(function()
                        Sound:Stop()
                        Sound:Destroy()
                        Sound2:Stop()
                        Sound2:Destroy()
                        ScreenGui:Destroy()
                    end)
                    t2.value180 = false
                end
                local MouseButton1Click = TextButton.MouseButton1Click
                t9.value23 = MouseButton1Click.Connect
                function t9.value25()
                    if not u760 then
                        return
                    end

                    if not not u760 then
                        task.spawn(function()
                            local timestamp = tick()

                            while u760 and (not u766 and tick() - timestamp < 8) do
                                task.wait(0.05)
                            end

                            if not u760 then
                                return
                            end

                            if u766 then
                                pcall(function()
                                    Sound.SoundId = u766
                                    Sound.TimePosition = 0
                                    Sound.Volume = 0.55
                                    Sound:Play()
                                end)
                            end
                        end)
                    end

                    Frame.BackgroundColor3 = value5_2
                    Frame.BackgroundTransparency = 0.2

                    local v1287 = v767
                    local v1288 = Frame
                    local _Enum = Enum

                    v1287(v1288, 0.4, {
						BackgroundTransparency = 1
					}, _Enum.EasingStyle.Quad)
                    v847(value5_3)

                    if CanvasGroup3 then
                        v767(CanvasGroup3, 0.35, {
							GroupTransparency = 0.75
						}, Enum.EasingStyle.Quad)
                    end

                    CanvasGroup4.Visible = true
                    CanvasGroup4.GroupTransparency = 1

                    local v1290 = v767
                    local v1291 = CanvasGroup4
                    local _Enum2 = Enum

                    v1290(v1291, 0.35, {
						GroupTransparency = 0
					}, _Enum2.EasingStyle.Quad)

                    local t14 = {
						"INITIALIZING HYPERION ENGINE...",
						"HOOKING DUEL REMOTES...",
						"CALIBRATING AIMBOT...",
						"BYPASSING DUEL ANTICHEAT...",
						"SYNCHRONIZING CLIENT...",
						"HYPERION SUPREMACY READY"
					}
                    local elapsed = os.clock()

                    u761 = value6_2.RenderStepped:Connect(function()
                        if not u760 then
                            return
                        end

                        local v1537 = os.clock() - elapsed
                        local v1538 = math.clamp(v1537 * 16, 0, 100)
                        local v1539 = math.floor(v1538)

                        if v1539 ~= -1 then
                            TextLabel5.Text = tostring(v1539) .. "%"
                            TextLabel6.Text = t14[math.clamp(math.floor(v1538 / 20) + 1, 1, #t14)]
                        end

                        Frame12.Size = UDim2.fromScale(v1538 / 100, 1)
                        Frame8.Rotation = v1537 * 65
                        Frame9.Rotation = -v1537 * 45

                        local v1540 = math.sin(v1537 * 4) * 0.05 + 1

                        Frame8.Size = UDim2.fromOffset(160 * v1540, 160 * v1540)

                        local v1541 = Frame9
                        local fromOffset = UDim2.fromOffset
                        local v1543 = 200 * v1540

                        v1541.Size = fromOffset(200 * v1540, v1543)

                        for _, v in ipairs(t13) do
                            local v1546 = v.angle + v1537 * v.speed
                            local v1547 = v.radius * (math.sin(v1537 * 2 + v.angle) * 0.08 + 1)

                            v.gui.Position = UDim2.new(0.5, math.cos(v1546) * v1547, 0.4, math.sin(v1546) * v1547)
                        end
                    end)
                    task.wait(6.25)

                    if u761 then
                        u761:Disconnect()
                    end

                    TextLabel5.Text = "100%"
                    TextLabel6.Text = "HYPERION SUPREMACY READY"
                    Frame12.Size = UDim2.fromScale(1, 1)
                    task.wait(0.3)
                    v848()
                end
                t9.value23(MouseButton1Click, v848)
                function t9.value24()
                    if not u760 then
                        return
                    end
                    if not not u760 then
                        task.spawn(function()
                            local timestamp = tick()

                            while u760 and (not u766 and tick() - timestamp < 8) do
                                task.wait(0.05)
                            end

                            if not u760 then
                                return
                            end

                            if u766 then
                                pcall(function()
                                    Sound.SoundId = u766
                                    Sound.TimePosition = 0
                                    Sound.Volume = 0.55
                                    Sound:Play()
                                end)
                            end
                        end)
                    end
                    Frame.BackgroundColor3 = value5
                    Frame.BackgroundTransparency = 0.05
                    v767(Frame, 0.45, {
						BackgroundTransparency = 1
					}, Enum.EasingStyle.Quad)
                    task.spawn(v846, 24, 0.35)
                    v847(value5_2)
                    for v1297, v1298 in ipairs(t12) do

                        v767(v1298.group, 0.25, {
							GroupTransparency = 1
						}, Enum.EasingStyle.Quad)
                        v767(v1298.scale, 0.25, {
							Scale = 0.65
						}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                    end
                    task.wait(0.2)
                    for _, v in ipairs(t12) do
                        v.group.Visible = false
                    end
                    Frame2.Visible = false
                    CanvasGroup3.Visible = true
                    CanvasGroup3.GroupTransparency = 1
                    Frame6.Size = UDim2.fromOffset(210, 210)
                    TextLabel3.TextTransparency = 1
                    TextLabel4.TextTransparency = 1
                    Frame7.BackgroundTransparency = 1
                    TextLabel.TextTransparency = 1
                    local v1301 = v767
                    local v1302 = CanvasGroup3
                    local _Enum = Enum
                    v1301(v1302, 0.4, {
						GroupTransparency = 0
					}, _Enum.EasingStyle.Quad)
                    v767(Frame6, 0.5, {
						Size = UDim2.fromOffset(135, 135)
					}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    task.wait(0.2)
                    local v1304 = v767
                    local v1305 = TextLabel3
                    local _Enum3 = Enum
                    v1304(v1305, 0.4, {
						TextTransparency = 0
					}, _Enum3.EasingStyle.Quint)
                    local v1307 = v767
                    local v1308 = Frame7
                    local _Enum4 = Enum
                    v1307(v1308, 0.4, {
						BackgroundTransparency = 0.15
					}, _Enum4.EasingStyle.Quint)
                    local v1310 = v767
                    local v1311 = TextLabel
                    local _Enum5 = Enum
                    v1310(v1311, 0.4, {
						TextTransparency = 0
					}, _Enum5.EasingStyle.Quint)
                    v767(TextLabel4, 0.4, {
						TextTransparency = 0
					}, Enum.EasingStyle.Quint)
                    v847(value5_3)
                    task.spawn(v846, 16, 0.3)
                    local elapsed = os.clock()
                    while u760 and os.clock() - elapsed < 1.65 do
                        UIStroke.Color = math.sin((os.clock() - elapsed) * 6) > 0 and value5_2 or value5_3
                        UIGradient.Rotation = (UIGradient.Rotation + 3) % 360
                        UIGradient2.Rotation = (UIGradient2.Rotation + 4) % 360
                        value6_2.RenderStepped:Wait()
                    end
                end
                local function v850(p128)
                    if not u760 then
                        return
                    end

                    p128.group.GroupTransparency = 1
                    p128.scale.Scale = 1.2

                    local v1315 = v767
                    local group = p128.group
                    local _Enum = Enum

                    v1315(group, 0.42, {
						GroupTransparency = 0
					}, _Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

                    local v1318 = v767
                    local scale = p128.scale
                    local _Enum6 = Enum

                    v1318(scale, 0.42, {
						Scale = 1
					}, _Enum6.EasingStyle.Back, Enum.EasingDirection.Out)
                    p128.stroke.Color = value5_3
                    p128.stroke.Transparency = 0.05
                    task.wait(0.42)

                    if not u760 then
                        return
                    end

                    v762()
                    v847(value5)
                    task.spawn(v846, 12, 0.22)
                    p128.stroke.Color = value5

                    local v1321 = v767
                    local darken = p128.darken
                    local _Enum7 = Enum

                    v1321(darken, 0.25, {
						BackgroundTransparency = 0.1
					}, _Enum7.EasingStyle.Quad)
                    p128.bar.Position = UDim2.fromScale(-0.55, 0.58)
                    p128.bar.BackgroundTransparency = 0.05
                    v767(p128.bar, 0.34, {
						Position = UDim2.fromScale(0.5, 0.58)
					}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    task.wait(0.82)
                end
                local value24 = t9.value24
                local value25 = t9.value25
                task.spawn(function()
                    for _, v in ipairs(t12) do
                        if not u760 then
                            return
                        end

                        v850(v)
                        task.wait(0.2)
                    end

                    if not u760 then
                        return
                    end

                    task.wait(0.2)
                    value24()

                    if not u760 then
                        return
                    end

                    value25()
                end)
            end

            playIntroAnimation = t2.value181
            showIntro = t2.value181
            t2.value182 = Instance.new("ScreenGui")
            t2.value182.Name = "HyperionVS"
            t2.value182.ResetOnSpawn = false
            t2.value182.IgnoreGuiInset = true
            t2.value182.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            t2.value182.DisplayOrder = 60
            t2.value182.Enabled = true
            pcall(function()
                if syn and syn.protect_gui then
                    syn.protect_gui(t2.value182)
                end
            end)

            if not pcall(function()
                t2.value182.Parent = game:GetService("CoreGui")
            end) then
                t2.value182.Parent = t2.value7
            end

            t2.value183 = 340
            t2.value184 = 480

            function t2.value185(p129)
                local v854 = tonumber(p129) or 0.6

                return UDim2.new(0.5, -(t2.value183 * v854) / 2, 0.5, -(t2.value184 * v854) / 2)
            end

            local value38 = t2.value38
            local uDim2 = UDim2.new(0, t2.value183, 0, t2.value184)
            local vector2 = Vector2.new(0, 0)
            local v65 = t2.value185(t2.value29.guiScale)

            t2.value186 = value38("Frame", {
				Name = "MainClip",
				Size = uDim2,
				AnchorPoint = vector2,
				Position = v65,
				BackgroundColor3 = t2.value17,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Active = true,
				Visible = true,
				Parent = t2.value182
			})
            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 14),
				Parent = t2.value186
			})
            v35(t2.value186, 1.6)
            t2.value187 = t2.value38("UIScale", {
				Scale = t2.value29.guiScale or 0.6,
				Parent = t2.value186
			})

            local value38_13 = t2.value38
            local uDim2_35 = UDim2.new(1, 0, 1, 0)

            v68 = value38_13("Frame", {
				Name = "Main",
				Size = uDim2_35,
				BackgroundColor3 = t2.value17,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Active = true,
				Visible = true,
				Parent = t2.value186
			})
            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 14),
				Parent = v68
			})

            local value38_14 = t2.value38
            local uDim2_36 = UDim2.new(1, 0, 1, 0)
            local value25 = t2.value25
            local Crop = Enum.ScaleType.Crop
            local v73 = value38_14("ImageLabel", {
				Name = "BackgroundAsset",
				Size = uDim2_36,
				BackgroundTransparency = 1,
				Image = value25,
				ImageTransparency = 0.42,
				ScaleType = Crop,
				ZIndex = 1,
				Active = false,
				Parent = v68
			})

            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 14),
				Parent = v73
			})

            local value38_15 = t2.value38
            local uDim2_37 = UDim2.new(1, 0, 0, 46)
            local color3 = Color3.fromRGB(15, 12, 26)

            v77 = value38_15("Frame", {
				Name = "TopBar",
				Size = uDim2_37,
				BackgroundColor3 = color3,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				ZIndex = 5,
				Active = true,
				Parent = v68
			})
        end

        t2.value38("UICorner", {
			CornerRadius = UDim.new(0, 14),
			Parent = v77
		})

        do
            local value38 = t2.value38
            local uDim2 = UDim2.new(1, 0, 0, 14)
            local uDim2_38 = UDim2.new(0, 0, 1, -14)
            local color3 = Color3.fromRGB(15, 12, 26)

            value38("Frame", {
				Size = uDim2,
				Position = uDim2_38,
				BackgroundColor3 = color3,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				ZIndex = 5,
				Parent = v77
			})

            local value38_16 = t2.value38
            local uDim2_39 = UDim2.new(0, 26, 0, 26)
            local uDim2_40 = UDim2.new(0, 12, 0.5, -13)
            local value26 = t2.value26
            local Fit = Enum.ScaleType.Fit

            value38_16("ImageLabel", {
				Name = "TitleLogo",
				Size = uDim2_39,
				Position = uDim2_40,
				BackgroundTransparency = 1,
				Image = value26,
				ScaleType = Fit,
				ZIndex = 6,
				Active = false,
				Parent = v77
			})

            local value38_17 = t2.value38
            local uDim2_41 = UDim2.new(0, 100, 0, 26)
            local uDim2_42 = UDim2.new(0, 44, 0.5, -13)
            local value19 = t2.value19
            local GothamBlack = Enum.Font.GothamBlack
            local Left = Enum.TextXAlignment.Left
            local v93 = value38_17("TextLabel", {
				Name = "Title",
				Size = uDim2_41,
				Position = uDim2_42,
				BackgroundTransparency = 1,
				Text = "HYPERION",
				TextColor3 = value19,
				Font = GothamBlack,
				TextSize = 15,
				TextXAlignment = Left,
				ZIndex = 7,
				Active = false,
				Parent = v77
			})
            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = Color3.fromRGB(168, 85, 247)
            UIStroke.Thickness = 1
            UIStroke.Transparency = 0.25
            UIStroke.Parent = v93
        end

        do
            local value38 = t2.value38
            local uDim2 = UDim2.new(0, 46, 0, 18)
            local uDim2_43 = UDim2.new(0, 138, 0.5, -9)
            local color3 = Color3.fromRGB(16, 50, 32)
            local v99 = value38("Frame", {
				Name = "DuelsBadge",
				Size = uDim2,
				Position = uDim2_43,
				BackgroundColor3 = color3,
				BorderSizePixel = 0,
				ZIndex = 7,
				Parent = v77
			})

            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 5),
				Parent = v99
			})

            local UIStroke = Instance.new("UIStroke", v99)

            UIStroke.Thickness = 1
            UIStroke.Color = Color3.fromRGB(46, 204, 113)
            UIStroke.Transparency = 0.4

            local value38_18 = t2.value38
            local uDim2_44 = UDim2.new(1, 0, 1, 0)
            local color3_5 = Color3.fromRGB(140, 255, 190)
            local GothamBlack = Enum.Font.GothamBlack

            value38_18("TextLabel", {
				Size = uDim2_44,
				BackgroundTransparency = 1,
				Text = "DUELS",
				TextColor3 = color3_5,
				Font = GothamBlack,
				TextSize = 9,
				ZIndex = 8,
				Parent = v99
			})

            local value38_19 = t2.value38
            local uDim2_45 = UDim2.new(0, 28, 0, 28)
            local uDim2_46 = UDim2.new(1, -36, 0.5, -14)
            local color3_6 = Color3.fromRGB(38, 16, 24)
            local value19 = t2.value19
            local GothamBold = Enum.Font.GothamBold

            v111 = value38_19("TextButton", {
				Name = "Close",
				Size = uDim2_45,
				Position = uDim2_46,
				BackgroundColor3 = color3_6,
				BorderSizePixel = 0,
				Text = "X",
				TextColor3 = value19,
				Font = GothamBold,
				TextSize = 18,
				AutoButtonColor = true,
				ZIndex = 8,
				Parent = v77
			})
        end

        t2.value38("UICorner", {
			CornerRadius = UDim.new(0, 7),
			Parent = v111
		})

        do
            local UIStroke = Instance.new("UIStroke", v111)

            UIStroke.Thickness = 1
            UIStroke.Color = Color3.fromRGB(140, 40, 60)
            UIStroke.Transparency = 0.3

            local value38 = t2.value38
            local uDim2 = UDim2.new(0, 32, 0, 26)
            local uDim2_47 = UDim2.new(1, -74, 0.5, -13)
            local color3 = Color3.fromRGB(18, 15, 30)
            local value19 = t2.value19
            local GothamBold = Enum.Font.GothamBold

            t2.value188 = value38("TextButton", {
				Name = "Lock",
				Size = uDim2,
				Position = uDim2_47,
				BackgroundColor3 = color3,
				BorderSizePixel = 0,
				Text = "LOCK",
				TextColor3 = value19,
				Font = GothamBold,
				TextSize = 8.5,
				AutoButtonColor = true,
				ZIndex = 8,
				Parent = v77
			})
            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 7),
				Parent = t2.value188
			})

            local UIStroke10 = Instance.new("UIStroke", t2.value188)

            UIStroke10.Thickness = 1
            UIStroke10.Color = Color3.fromRGB(46, 204, 113)
            UIStroke10.Transparency = 0.3
            _G.HyperionGuiLocked = t2.value29.guiLocked == true

            function t2.value189()
                if not t2.value188 then
                    return
                end

                t2.value188.Text = not _G.HyperionGuiLocked and "LOCK" or "UNLOCK"
                t2.value188.BackgroundColor3 = _G.HyperionGuiLocked and Color3.fromRGB(14, 12, 22) or Color3.fromRGB(18, 15, 30)

                local UIStroke11 = t2.value188:FindFirstChildWhichIsA("UIStroke")

                if UIStroke11 then
                    UIStroke11.Color = _G.HyperionGuiLocked and Color3.fromRGB(140, 140, 150) or Color3.fromRGB(46, 204, 113)
                    UIStroke11.Transparency = not _G.HyperionGuiLocked and 0.2 or 0.55
                end
            end

            t2.value188.MouseButton1Click:Connect(function()
                _G.HyperionGuiLocked = not _G.HyperionGuiLocked
                t2.value29.guiLocked = _G.HyperionGuiLocked
                t2.value189()
                t2.value35()
            end)
            t2.value189()

            local value38_20 = t2.value38
            local uDim2_48 = UDim2.new(1, -16, 0, 32)
            local uDim2_49 = UDim2.new(0, 8, 0, 52)

            t2.value190 = value38_20("Frame", {
				Name = "Tabs",
				Size = uDim2_48,
				Position = uDim2_49,
				BackgroundTransparency = 1,
				ZIndex = 5,
				Active = true,
				Parent = v68
			})
        end

        local value38 = t2.value38
        local Horizontal = Enum.FillDirection.Horizontal
        local uDim = UDim.new(0, 6)
        local SortOrderLayoutOrder = Enum.SortOrder.LayoutOrder

        value38("UIListLayout", {
			FillDirection = Horizontal,
			Padding = uDim,
			SortOrder = SortOrderLayoutOrder,
			Parent = t2.value190
		})

        local value38_21 = t2.value38
        local uDim2 = UDim2.new(1, -16, 1, -96)
        local uDim2_50 = UDim2.new(0, 8, 0, 88)

        t2.value191 = value38_21("Frame", {
			Name = "Content",
			Size = uDim2,
			Position = uDim2_50,
			BackgroundTransparency = 1,
			ZIndex = 4,
			Active = true,
			ClipsDescendants = true,
			Parent = v68
		})
        t2.value192 = {}

        local function v130(p130)
            local value38_22 = t2.value38
            local uDim2_51 = UDim2.new(1, 0, 1, 0)
            local color3 = Color3.fromRGB(140, 90, 240)
            local uDim2_52 = UDim2.new(0, 0, 0, 0)
            local AutomaticSizeY = Enum.AutomaticSize.Y
            local ScrollingDirectionY = Enum.ScrollingDirection.Y
            local v863 = value38_22("ScrollingFrame", {
				Name = p130,
				Size = uDim2_51,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = color3,
				ScrollBarImageTransparency = 0.3,
				CanvasSize = uDim2_52,
				AutomaticCanvasSize = AutomaticSizeY,
				ScrollingDirection = ScrollingDirectionY,
				Visible = false,
				Active = true,
				ZIndex = 4,
				Parent = t2.value191
			})
            local value38_23 = t2.value38
            local SortOrderLayoutOrder2 = Enum.SortOrder.LayoutOrder
            local uDim4 = UDim.new(0, 6)

            value38_23("UIListLayout", {
				SortOrder = SortOrderLayoutOrder2,
				Padding = uDim4,
				Parent = v863
			})

            local value38_24 = t2.value38
            local uDim5 = UDim.new(0, 4)
            local uDim6 = UDim.new(0, 16)
            local uDim7 = UDim.new(0, 2)
            local uDim8 = UDim.new(0, 6)

            value38_24("UIPadding", {
				PaddingTop = uDim5,
				PaddingBottom = uDim6,
				PaddingLeft = uDim7,
				PaddingRight = uDim8,
				Parent = v863
			})
            t2.value192[p130] = v863

            return v863
        end

        v131 = v130("MOVEMENT")
        v132 = v130("COMBAT")
        v133 = v130("UTILITY")
        v134 = v130("SETTINGS")

        local function v135(p131, p132)
            local value38_25 = t2.value38
            local uDim2_53 = UDim2.new(0, 76, 1, 0)
            local color3 = Color3.fromRGB(16, 13, 26)
            local value20 = t2.value20
            local GothamBold = Enum.Font.GothamBold
            local v879 = value38_25("TextButton", {
				Name = p131,
				Size = uDim2_53,
				BackgroundColor3 = color3,
				BackgroundTransparency = 0.4,
				BorderSizePixel = 0,
				Text = p131,
				TextColor3 = value20,
				Font = GothamBold,
				TextSize = 10.5,
				AutoButtonColor = true,
				LayoutOrder = p132,
				ZIndex = 6,
				Parent = t2.value190
			})

            t2.value38("UICorner", {
				CornerRadius = UDim.new(0, 7),
				Parent = v879
			})

            local value38_26 = t2.value38
            local color3_7 = Color3.fromRGB(55, 45, 80)
            local Border = Enum.ApplyStrokeMode.Border

            value38_26("UIStroke", {
				Color = color3_7,
				Thickness = 1,
				ApplyStrokeMode = Border,
				Parent = v879
			})

            return v879
        end

        v135("MOVEMENT", 1)
        v135("COMBAT", 2)
        v135("UTILITY", 3)
        v135("SETTINGS", 4)

        function t2.value193(p133)

            for v886, v887 in pairs(t2.value192) do

                v887.Visible = v886 == p133
            end
            for _, child in ipairs(t2.value190:GetChildren()) do
                if child:IsA("TextButton") then
                    local v890 = p133 == child.Name

                    child.BackgroundTransparency = not v890 and 0.55 or 0.15
                    child.BackgroundColor3 = v890 and Color3.fromRGB(34, 26, 60) or Color3.fromRGB(16, 13, 26)
                    child.TextColor3 = v890 and t2.value19 or t2.value20

                    local UIStroke = child:FindFirstChildWhichIsA("UIStroke")

                    if UIStroke then
                        UIStroke.Color = v890 and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(45, 38, 70)
                        UIStroke.Thickness = not v890 and 1 or 1.4
                    end
                end
            end
        end

        for _, child in ipairs(t2.value190:GetChildren()) do
            local v138 = child

            if v138:IsA("TextButton") then
                v138.MouseButton1Click:Connect(function()
                    t2.value193(v138.Name)
                end)
            end
        end

        t2.value193("MOVEMENT")

        function makeGuiDraggable(p134, p135, p136, p137)
            local u896 = false
            local inputPosition
            local p134Position
            local function v899()
                return p137 and _G.HyperionGuiLocked == true
            end
            local function v900()
                if not u896 then
                    return
                end

                if p136 and writefile then
                    local p134Position2 = p134.Position

                    pcall(function()
                        writefile(p136, string.format("%.4f,%.1f,%.4f,%.1f", p134Position2.X.Scale, p134Position2.X.Offset, p134Position2.Y.Scale, p134Position2.Y.Offset))
                    end)
                end

                u896 = false
            end
            p135.InputBegan:Connect(function(input)
                if u896 or v899() then
                    return
                end

                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                u896 = true
                inputPosition = input.Position
                p134Position = p134.Position
            end)
            p135.InputEnded:Connect(v900)
            t2.value4.InputBegan:Connect(function(input)
                if u896 or v899() then
                    return
                end

                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                local AbsolutePosition = p135.AbsolutePosition
                local AbsoluteSize = p135.AbsoluteSize

                if not AbsolutePosition or not AbsoluteSize then
                    return
                end

                local inputPosition2 = input.Position
                local v1334 = inputPosition2.X >= AbsolutePosition.X

                if v1334 then
                    v1334 = inputPosition2.X <= AbsolutePosition.X + AbsoluteSize.X and (inputPosition2.Y >= AbsolutePosition.Y and inputPosition2.Y <= AbsolutePosition.Y + AbsoluteSize.Y)
                end

                if v1334 then
                    local _ = p134.Position
                end
            end)
            t2.value4.InputChanged:Connect(function(input)
                if not u896 then
                    return
                end

                if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                local v1328 = input.Position - inputPosition

                p134.Position = UDim2.new(p134Position.X.Scale, p134Position.X.Offset + v1328.X, p134Position.Y.Scale, p134Position.Y.Offset + v1328.Y)
            end)
            t2.value4.InputEnded:Connect(v900)
        end
        function loadGuiPos(p138, p139, p140)

            local u904 = p139
            local u905
            t2.value8(function()
                u905 = readfile(u904)
            end)
            if u905 and u905 ~= "" then
                local t15 = {}
                for v909 in string.gmatch(u905, "[^,]+") do

                    table.insert(t15, v909)
                end
                if #t15 >= 4 then
                    local num = tonumber(t15[1])
                    local num2 = tonumber(t15[2])
                    local num3 = tonumber(t15[3])
                    local num4 = tonumber(t15[4])
                    local v914 = num

                    if num then
                        v914 = num2

                        if num2 then
                            v914 = num3

                            if num3 then
                                v914 = num4

                                if num4 then
                                    v914 = num >= 0

                                    if v914 then
                                        v914 = num <= 1

                                        if v914 then
                                            v914 = num3 >= 0

                                            if v914 then
                                                v914 = num3 <= 1 and (math.abs(num2) < 100000 and math.abs(num4) < 100000)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    if v914 then
                        p138.Position = UDim2.new(num, num2, num3, num4)

                        return
                    end
                end
            end
            if p140 then
                p138.Position = p140
            end
        end

        loadGuiPos(t2.value186, "HyperionVSPos_v2.txt", t2.value185(t2.value29.guiScale))
        makeGuiDraggable(t2.value186, v77, "HyperionVSPos_v2.txt", true)

        local value38_27 = t2.value38
        local uDim2_54 = UDim2.new(0, 52, 0, 52)
        local uDim2_55 = UDim2.new(0, 18, 0.5, -26)

        t2.value194 = value38_27("Frame", {
			Name = "HyperionFloat",
			Size = uDim2_54,
			Position = uDim2_55,
			BackgroundColor3 = t2.value17,
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0,
			Visible = false,
			Active = true,
			ZIndex = 40,
			Parent = t2.value182
		})
        t2.value38("UICorner", {
			CornerRadius = UDim.new(1, 0),
			Parent = t2.value194
		})
        v35(t2.value194, 1.4)
    end

    local value38 = t2.value38
    local uDim2 = UDim2.new(1, -8, 1, -8)
    local uDim2_56 = UDim2.new(0, 4, 0, 4)
    local value26 = t2.value26
    local Fit = Enum.ScaleType.Fit
    local v147 = value38("ImageButton", {
		Size = uDim2,
		Position = uDim2_56,
		BackgroundTransparency = 1,
		Image = value26,
		ScaleType = Fit,
		ZIndex = 41,
		Parent = t2.value194
	})

    v111.MouseButton1Click:Connect(function()
        t2.value186.Visible = false
        t2.value194.Visible = true
    end)
    v147.MouseButton1Click:Connect(function()
        t2.value186.Visible = true
        t2.value194.Visible = false
    end)
    v147.MouseButton1Click:Connect(function()
        loadGuiPos(t2.value194, "HyperionFloatPos.txt", UDim2.new(0, 18, 0.5, -26))
        makeGuiDraggable(t2.value194, t2.value194, "HyperionFloatPos.txt")
        t2.value186.Visible = true
        t2.value194.Visible = false
    end)
    t2.value195 = {}
    v38("Speed", "SPEED", v131)

    local _, v149 = v37("NormalSpeed", "Normal Speed", t2.value29.normalSpeed, v131)

    t2.value196 = v149

    local _, v151 = v37("CarrySpeed", "Carry Speed", t2.value29.carrySpeed, v131)

    t2.value197 = v151

    local _, v153 = v37("LaggerSpeed", "Lagger Speed", t2.value29.laggerSpeed, v131)

    t2.value198 = v153
    t2.value195.speed = v39("SpeedMode", "Carry Mode", v131)
    t2.value195.lagger = v39("LaggerMode", "Lagger", v131)
    v38("Paths", "PATHS", v131)
    t2.value195.autoLeft = v39("AutoLeft", "Auto Left", v131)
    t2.value195.autoRight = v39("AutoRight", "Auto Right", v131)
    t2.value195.autoTp = v39("AutoTpDown", "Auto TP Down", v131)

    local v154

    v154, v155 = v37("TpDownY", "TP Down Radius", t2.value29.autoTpDownY, v131)
    v38("Jump", "JUMP", v131)
    t2.value195.infJump = v39("InfJump", "Infinite Jump", v131)
    v156 = (function(p141, p142, p143, p144)
        local v356 = t2.value44(p141, p144)

        t2.value41(v356)
        t2.value43(v356, p142, 11)

        local value38_28 = t2.value38
        local uDim2_57 = UDim2.new(1, -150, 0, 0)
        local uDim2_58 = UDim2.new(0, 138, 1, 0)
        local value19 = t2.value19
        local GothamMedium = Enum.Font.GothamMedium
        local Right = Enum.TextXAlignment.Right

        value38_28("TextLabel", {
			Name = "ModeValue",
			ZIndex = 6,
			Position = uDim2_57,
			Size = uDim2_58,
			BackgroundTransparency = 1,
			Text = p143,
			TextColor3 = value19,
			TextSize = 12,
			Font = GothamMedium,
			TextXAlignment = Right,
			Parent = v356
		})

        local value38_29 = t2.value38
        local uDim2_59 = UDim2.new(1, 0, 1, 0)

        value38_29("TextButton", {
			Name = "ModeClick",
			ZIndex = 30,
			Size = uDim2_59,
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Parent = v356
		})

        return v356
    end)("JumpMode", "Jump Mode", t2.value29.infJumpMode:upper(), v131)
    t2.value195.unwalk = v39("Unwalk", "Unwalk", v131)
    v38("BatTP", "BAT / TP", v132)
    t2.value195.tpBat = v39("TPBat", "TP Bat (Regular)", v132)
    t2.value195.batCounter = v39("BatCounter", "Bat Counter", v132)
    t2.value195.medusaCounter = v39("MedusaCounter", "Medusa Counter", v132)
    t2.value195.batAimbot = v39("BatAimbot", "Bat Aimbot", v132)
    t2.value195.aimbotTpSpam = v39("AimbotTpSpam", "Aimbot TP Down Spammer", v132)
    t2.value199 = t2.value44("AimbotMode", v132)
    t2.value41(t2.value199)
    t2.value43(t2.value199, "Aimbot Mode", 11)

    local function v157(p145, p146, p147)
        local value38_30 = t2.value38
        local uDim2_60 = UDim2.new(1, p147, 0.5, -12)
        local uDim2_61 = UDim2.new(0, 62, 0, 24)
        local value18 = t2.value18
        local value19 = t2.value19
        local GothamBold = Enum.Font.GothamBold
        local v924 = value38_30("TextButton", {
			Name = p145,
			ZIndex = 7,
			Position = uDim2_60,
			Size = uDim2_61,
			BackgroundColor3 = value18,
			BackgroundTransparency = 0.18,
			BorderSizePixel = 0,
			Text = p146,
			TextColor3 = value19,
			TextSize = 10,
			Font = GothamBold,
			AutoButtonColor = false,
			Parent = t2.value199
		})

        t2.value38("UICorner", {
			CornerRadius = UDim.new(0, 7),
			Parent = v924
		})

        local value38_31 = t2.value38
        local value19_3 = t2.value19
        local Border = Enum.ApplyStrokeMode.Border

        return v924, (value38_31("UIStroke", {
			Color = value19_3,
			Thickness = 1,
			ApplyStrokeMode = Border,
			Parent = v924
		}))
    end

    local v158, v159 = v157("ModeBtnNormal", "NORMAL", -134)

    t2.value200 = v158
    t2.value201 = v159

    local v160, v161 = v157("ModeBtnV2", "V2", -68)

    t2.value202 = v160
    t2.value203 = v161
    t2.value204 = Color3.fromRGB(0, 230, 255)
    t2.value205 = Color3.fromRGB(90, 80, 120)

    local function v162()
        local v928 = t2.value29.batAimbotMode == "v2"

        t2.value200.BackgroundColor3 = v928 and t2.value18 or t2.value17
        t2.value200.BackgroundTransparency = not v928 and 0 or 0.18
        t2.value200.TextColor3 = v928 and t2.value20 or t2.value19
        t2.value201.Color = v928 and t2.value205 or t2.value204
        t2.value201.Thickness = not v928 and 1.5 or 1
        t2.value202.BackgroundColor3 = v928 and t2.value17 or t2.value18
        t2.value202.BackgroundTransparency = not v928 and 0.18 or 0
        t2.value202.TextColor3 = v928 and t2.value19 or t2.value20
        t2.value203.Color = v928 and t2.value204 or t2.value205
        t2.value203.Thickness = not v928 and 1 or 1.5
    end

    t2.value200.MouseButton1Click:Connect(function()
        if t2.value29.batAimbotMode ~= "v1" then
            t2.value29.batAimbotMode = "v1"
            v162()
            t2.value35()
        end
    end)
    t2.value202.MouseButton1Click:Connect(function()
        if t2.value29.batAimbotMode ~= "v2" then
            t2.value29.batAimbotMode = "v2"
            v162()
            t2.value35()
        end
    end)
    v162()
end
t2.value195.mirrorTp = v39("MirrorTP", "Mirror TP Down", v132)
v38("Defense", "DEFENSE", v132)
t2.value195.antiRag = v39("AntiRag", "Anti Ragdoll", v132)
t2.value195.antiDie = v39("AntiDie", "Anti Die", v132)
t2.value195.medusaReset = v39("MedusaReset", "Medusa Reset", v132)
t2.value195.safeMode = v39("SafeMode", "Safe Mode", v132)
v38("Steal", "STEAL", v132)
t2.value195.instaGrab = v39("InstaGrab", "Auto Grab", v132)
local v163 = t2.value44("SemiOnlyInfo", v132)
t2.value41(v163)
t2.value43(v163, "Radius")
local value38 = t2.value38
local uDim2 = UDim2.new(1, -150, 0, 0)
local uDim2_62 = UDim2.new(0, 138, 1, 0)
local value19 = t2.value19
local GothamBold = Enum.Font.GothamBold
local Right = Enum.TextXAlignment.Right
value38("TextLabel", {
	Name = "SemiRadius",
	ZIndex = 6,
	Position = uDim2,
	Size = uDim2_62,
	BackgroundTransparency = 1,
	Text = "12",
	TextColor3 = value19,
	TextSize = 12,
	Font = GothamBold,
	TextXAlignment = Right,
	Parent = v163
})
v38("Quick", "ACTIONS", v133)
t2.value195.drop = v36("DropBrainrot", "Drop Brainrot", v133)
t2.value195.tpDown = v36("TPDown", "TP Down Now", v133)
t2.value195.tpFloor = v36("TPFloor", "TP Floor", v133)
t2.value195.reset = v36("InstaReset", "Instant Reset", v133)
v38("Music", "MUSIC", v133)
t2.value195.music = v36("MusicPanel", "Open Music Player", v133)
v38("Visuals", "VISUALS", v133)
t2.value195.animPack = v39("AnimPack", "Anim Pack", v133)
t2.value195.speedEsp = v39("SpeedESP", "Speed ESP", v133)
v38("Interface", "INTERFACE", v134)
t2.value195.intro = v39("IntroAnimation", "Intro Animation", v134)
t2.value195.mobile = v39("MobileButtons", "Mobile Buttons", v134)
t2.value195.lock = v39("LockButtons", "Lock Mobile Buttons", v134)
local _, v171 = v37("GuiScale", "GUI Scale", t2.value29.guiScale, v134)
t2.value206 = v171
local _, v173 = v37("FOV", "Field of View", t2.value29.fov, v134)
t2.value207 = v173
t2.value195.stealBar = v39("StealBar", "Steal Bar", v134)
v38("Keybinds", "KEYBINDS", v134)
v41("KeyAutoLeft", "Auto Left", "keyAutoLeft", v134)
v41("KeyAutoRight", "Auto Right", "keyAutoRight", v134)
v41("KeyDropBR", "Drop Brainrot", "keyDropBR", v134)
v41("KeyTpDown", "TP Down", "keyTpDown", v134)
v41("KeyCarrySpeed", "Carry Speed", "keyCarrySpeed", v134)
v41("KeyLagger", "Lagger", "keyLagger", v134)
v41("KeyAutoGrab", "Auto Grab", "keyAutoGrab", v134)
v41("KeyInfJump", "Infinite Jump", "keyInfJump", v134)
v41("KeyAutoTpDown", "Auto TP Down", "keyAutoTpDown", v134)
v41("KeyAntiRag", "Anti Ragdoll", "keyAntiRag", v134)
v41("KeyMedusaCounter", "Medusa Counter", "keyMedusaCounter", v134)
v41("KeyMedusaReset", "Medusa Reset", "keyMedusaReset", v134)
v41("KeyAntiDie", "Anti Die", "keyAntiDie", v134)
v41("KeyUnwalk", "Unwalk", "keyUnwalk", v134)
v41("KeyBatCounter", "Bat Counter", "keyBatCounter", v134)
v41("KeyInstantReset", "Insta Reset", "keyInstantReset", v134)
v41("KeySafeMode", "Safe Mode", "keySafeMode", v134)
v41("KeyAutoBat", "Bat Aimbot", "keyAutoBat", v134)
v38("Save", "SAVE", v134)
t2.value208 = t1.value1("SAVE SETTINGS", "SAVE CONFIG", v134)
local v174 = v36("ResetButtonPositions", "Reset Button Positions", v134)
t1.value1 = t2.value195
local function v175(p148, p149, p150)
    local ToggleArea = p148:FindFirstChild("ToggleArea")

    if not ToggleArea then
        return
    end;

    (ToggleArea:FindFirstChild("ToggleClick") or ToggleArea).MouseButton1Click:Connect(function()
        if t2.value56() then
            return
        end

        local v1336 = not (t2.value32[p148] or false)

        v40(p148, v1336)
        p150(v1336)
        t2.value35()
    end)

    local v933 = v40
    local t16 = { p149() }

    v933(p148, v3(t16))
end
v175(t1.value1.speed, function()
    return t2.value29.speedType == "carry"
end, function(p151)
    t2.value29.speedType = not p151 and "normal" or "carry"

    if t2.value31.Buttons.carrySpeed then
        t2.value31.Buttons.carrySpeed(p151)
    end
end)
v175(t2.value195.lagger, function()
    return t2.value29.laggerActive
end, function(p152)
    t2.value29.laggerActive = p152

    if t2.value31.Buttons.lagger then
        t2.value31.Buttons.lagger(p152)
    end
end)
local __G = _G
t1.value1 = "HyperionSetSpeedToggleVisual"
__G[t1.value1] = function(p153)
    v40(t2.value195.speed, not not p153)
end
local __G2 = _G
t1.value1 = "HyperionSetAutoLeftVisual"
__G2[t1.value1] = function(p154)
    v40(t2.value195.autoLeft, not not p154)
end
local __G3 = _G
t1.value1 = "HyperionSetAutoRightVisual"
__G3[t1.value1] = function(p155)
    v40(t2.value195.autoRight, not not p155)
end
local __G4 = _G
t1.value1 = "HyperionSetBatAimbotVisual"
__G4[t1.value1] = function(p156)
    v40(t2.value195.batAimbot, not not p156)
end
t1.value1 = t2.value195.autoLeft
v175(t1.value1, function()
    return t2.value29.autoLeftEnabled
end, function(p157)
    if p157 then
        v52()
        v40(t2.value195.autoRight, false)
    else
        v50()
    end

    if t2.value31.Buttons.autoLeft then
        t2.value31.Buttons.autoLeft(t2.value29.autoLeftEnabled)
    end
end)
v175(t2.value195.autoRight, function()
    return t2.value29.autoRightEnabled
end, function(p158)
    if p158 then
        t2.value93()
        v40(t2.value195.autoLeft, false)
    else
        v51()
    end

    if t2.value31.Buttons.autoRight then
        t2.value31.Buttons.autoRight(t2.value29.autoRightEnabled)
    end
end)
v175(t2.value195.autoTp, function()
    return t2.value29.autoTpDownEnabled
end, function(p159)
    t2.value29.autoTpDownEnabled = p159

    if p159 then
        t2.value104()

        return
    end

    t2.value105()
end)
t1.value1 = t2.value195.infJump
v175(t1.value1, function()
    return t2.value29.infJumpEnabled
end, function(p160)
    t2.value29.infJumpEnabled = p160

    if p160 then
        t2.value142()

        return
    end

    t2.value143()
end)
v175(t2.value195.unwalk, function()
    return t2.value29.unwalkEnabled
end, function(p161)
    if p161 then
        v58()

        return
    end

    t2.value147()
end)
v175(t2.value195.tpBat, function()
    return t2.value29.tpBatEnabled
end, function(p162)
    if p162 then
        v61()

        return
    end

    t2.value47()
end)
v175(t2.value195.batCounter, function()
    return t2.value29.batCounterEnabled
end, function(p163)
    t2.value29.batCounterEnabled = p163

    if p163 then
        if t2.value109 then
            return
        end

        t2.value110 = false
        t2.value2.Heartbeat:Connect(function()
            if not t2.value29.batCounterEnabled then
                return
            end

            if t2.value56() then
                return
            end

            if t2.value110 then
                return
            end

            local Character = t2.value6.Character

            if not Character then
                return
            end

            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

            if not Humanoid then
                return
            end

            if t2.value112(Humanoid) then
                task.spawn(function()
                    local v1549 = t2.value64()

                    if v1549 then
                        local Character3 = t2.value6.Character

                        if Character3 and Character3 ~= v1549.Parent then
                            local Humanoid2 = Character3:FindFirstChildOfClass("Humanoid")

                            if Humanoid2 then
                                pcall(function()
                                    Humanoid2:EquipTool(v1549)
                                end)
                            end
                        end

                        t2.value65(v1549)
                        task.wait(0.2)
                        t2.value65(v1549)
                    end

                    task.wait(0.3)
                end)
            end
        end)

        return
    end

    t2.value113()
end)
t1.value1 = t2.value195.medusaCounter
v175(t1.value1, function()
    return t2.value29.medusaCounterEnabled
end, function(p164)
    t2.value29.medusaCounterEnabled = p164

    if p164 then
        v53(t2.value6.Character)

        return
    end

    t2.value45()
end)
v175(t2.value195.antiRag, function()
    return t2.value29.antiRagdollEnabled
end, function(p165)
    t2.value29.antiRagdollEnabled = p165

    if p165 then
        v55()

        return
    end

    t2.value123()
end)
v175(t2.value195.antiDie, function()
    return t2.value29.antiDieEnabled
end, function(p166)
    if p166 then
        v56()

        return
    end

    t2.value129()
end)
t1.value1 = t2.value195.medusaReset
v175(t1.value1, function()
    return t2.value29.medusaResetEnabled
end, function(p167)
    t2.value29.medusaResetEnabled = p167

    if p167 then
        t2.value139(t2.value6.Character)

        return
    end

    t2.value46()
end)
v175(t2.value195.safeMode, function()
    return t2.value29.safeMode
end, function(p168)
    t2.value29.safeMode = p168
end)
t1.value1 = t2.value195.batAimbot
v175(t1.value1, function()
    return t2.value29.autoBatToggled
end, function(p169)
    t2.value29.autoBatToggled = p169

    if p169 then
        if t2.value29.autoLeftEnabled then
            t2.value29.autoLeftEnabled = false
            v40(t2.value195.autoLeft, false)
        end

        if t2.value29.autoRightEnabled then
            t2.value29.autoRightEnabled = false
            v40(t2.value195.autoRight, false)
        end

        t2.value48()

        return
    end

    t2.value49()
end)
t1.value1 = t2.value195.aimbotTpSpam
v175(t1.value1, function()
    return t2.value29.aimbotTpDownSpam
end, function(p170)
    t2.value29.aimbotTpDownSpam = p170

    if _G.HyperionAimbotTpSpamSync then
        pcall(_G.HyperionAimbotTpSpamSync)
    end
end)
v175(t2.value195.mirrorTp, function()
    return t2.value29.mirrorTPDownEnabled
end, function(p171)
    t2.value29.mirrorTPDownEnabled = p171

    if _G.HyperionSetMirrorTPDown then
        _G.HyperionSetMirrorTPDown(p171)
    end
end)
t1.value1 = t2.value195.animPack
v175(t1.value1, function()
    return t2.value29.animEnabled
end, function(p172)
    t2.value29.animEnabled = p172

    local Character = t2.value6.Character

    if not Character then
        return
    end

    if p172 then
        if saveOriginalAnims then
            saveOriginalAnims(Character)
        end

        if applyAnimPack then
            applyAnimPack(Character)

            return
        end
    elseif restoreOriginalAnims then
        restoreOriginalAnims(Character)
    end
end)
v175(t2.value195.speedEsp, function()
    return t2.value29.speedESPEnabled
end, function(p173)
    t2.value29.speedESPEnabled = p173
    _G.HyperionSpeedESPEnabled = p173
end)
t1.value1 = t2.value195.stealBar
v175(t1.value1, function()
    return t2.value29.stealBarEnabled ~= false
end, function(p174)
    t2.value29.stealBarEnabled = p174

    if _G.HyperionSetStealBarVisible then
        _G.HyperionSetStealBarVisible(p174)
    end
end)
v175(t2.value195.instaGrab, function()
    return t2.value30.Enabled
end, function(p175)
    t2.value30.Enabled = p175

    if p175 then
        v59()

        return
    end

    t2.value161()
end)
t1.value1 = t2.value195.mobile
v175(t1.value1, function()
    return t2.value31.Visible ~= false
end, function(p176)
    t2.value31.Visible = p176

    for _, v in ipairs(t2.value31.Containers) do
        if v and v.Parent then
            v.Visible = p176
        end
    end
end)
t1.value1 = t2.value195.lock
v175(t1.value1, function()
    return t2.value31.Locked == true
end, function(p177)
    t2.value31.Locked = p177
end)
v175(t2.value195.intro, function()
    return t2.value29.introEnabled ~= false
end, function(p178)
    t2.value29.introEnabled = not not p178
end)
local function v180(p179, p180, p181, p182)
    p179.FocusLost:Connect(function()
        local num = tonumber(p179.Text)

        if num then
            local v1340 = math.clamp(num, p181 or 0, p182 or 9999)

            t2.value29[p180] = v1340
            p179.Text = tostring(v1340)
            t2.value35()

            return
        end

        p179.Text = tostring(t2.value29[p180])
    end)
end
v180(t2.value196, "normalSpeed", 1, 500)
v180(t2.value197, "carrySpeed", 1, 500)
v180(t2.value198, "laggerSpeed", 1, 200)
v180(v155, "autoTpDownY", 0, 20)
t1.value1 = t2.value206.FocusLost
t1.value1:Connect(function()
    local num = tonumber(t2.value206.Text)

    if num then
        t2.value29.guiScale = math.clamp(num, 0.3, 2)
        t2.value187.Scale = t2.value29.guiScale
        t2.value186.Position = t2.value185(t2.value29.guiScale)
        t2.value206.Text = tostring(t2.value29.guiScale)
        t2.value35()
    end
end)
function t1.value1()
    pcall(function()
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = t2.value29.fov
        end
    end)
end
t2.value209 = t1.value1
t1.value1 = t2.value207.FocusLost
t1.value1:Connect(function()
    local num = tonumber(t2.value207.Text)

    if num then
        t2.value29.fov = math.clamp(num, 30, 120)
        t2.value207.Text = tostring(t2.value29.fov)
        t2.value35()
        t2.value209()

        return
    end

    t2.value207.Text = tostring(t2.value29.fov)
end)
t1.value1 = v156:FindFirstChild("ModeValue")
t2.value210 = t1.value1
t1.value1 = v156:FindFirstChild("ModeClick").MouseButton1Click
t1.value1:Connect(function()
    t2.value29.infJumpMode = t2.value29.infJumpMode ~= "manual" and "manual" or "hold"

    if t2.value210 then
        t2.value210.Text = t2.value29.infJumpMode:upper()
    end

    t2.value35()
end)
t1.value1 = t2.value208:FindFirstChild("BigClick").MouseButton1Click
t1.value1:Connect(function()
    local v972 = t2.value35()
    local BigLabel = t2.value208:FindFirstChild("BigLabel")

    if BigLabel then
        BigLabel.Text = not v972 and "FAILED" or "SAVED"
        task.delay(1.2, function()
            if BigLabel then
                BigLabel.Text = "SAVE CONFIG"
            end
        end)
    end
end)
v174:FindFirstChild("ActionClick").MouseButton1Click:Connect(function()
    local t17 = {
		UDim2.new(1, -127, 0.35, -147.5),
		"HyperionBtn_drop.txt"
	}
    local t18 = {
		UDim2.new(1, -67, 0.35, -147.5),
		"HyperionBtn_autoleft.txt"
	}
    local t19 = {
		UDim2.new(1, -127, 0.35, -87.5),
		"HyperionBtn_aimbot.txt"
	}
    local t20 = {
		UDim2.new(1, -67, 0.35, -87.5),
		"HyperionBtn_autoright.txt"
	}
    local t21 = {
		UDim2.new(1, -127, 0.35, -27.5),
		"HyperionBtn_tpdown.txt"
	}
    local t22 = {
		UDim2.new(1, -67, 0.35, -27.5),
		"HyperionBtn_carry.txt"
	}
    local t23 = {
		UDim2.new(1, -67, 0.35, 32.5),
		"HyperionBtn_lagger.txt"
	}
    local t24 = {
		UDim2.new(1, -127, 0.35, 92.5),
		"HyperionBtn_reset.txt"
	}
    local t25 = {
		UDim2.new(1, -67, 0.35, 92.5),
		"HyperionBtn_tpbat.txt"
	}
    local t26 = {
		BtnDropBR = t17,
		BtnAutoLeft = t18,
		BtnAimbot = t19,
		BtnAutoRight = t20,
		BtnTpDown = t21,
		BtnCarrySpd = t22,
		BtnLagger = t23,
		BtnInstaReset = t24,
		BtnTPBat = t25
	}

    for _, v in ipairs(t2.value31.Containers or {}) do
        local v986 = t26[v.Name]

        if v986 then
            v.Position = v986[1]
            pcall(function()
                if delfile then
                    delfile(v986[2])
                end
            end)
        end
    end
end)
t2.value195.drop:FindFirstChild("ActionClick").MouseButton1Click:Connect(function()
    t2.value111()
end)
t2.value195.tpDown:FindFirstChild("ActionClick").MouseButton1Click:Connect(function()
    t2.value107()
end)
t2.value195.tpFloor:FindFirstChild("ActionClick").MouseButton1Click:Connect(function()
    t2.value107()
end)
t1.value1 = t2.value195.reset:FindFirstChild("ActionClick").MouseButton1Click
t1.value1:Connect(function()
    t2.value140()
end)
t1.value1 = t2.value195.music:FindFirstChild("ActionClick").MouseButton1Click
t1.value1:Connect(function()
    pcall(function()
        if _G.OpenMusicPanel then
            _G.OpenMusicPanel()
        end
    end)
end)
local function v181()
    t2.value29.laggerActive = false
    t2.value29.speedType = "normal"
    v40(t2.value195.lagger, false)
    v40(t2.value195.speed, false)

    if t2.value31.Buttons.lagger then
        t2.value31.Buttons.lagger(false)
    end

    if t2.value31.Buttons.carrySpeed then
        t2.value31.Buttons.carrySpeed(false)
    end
end
local function v182(p183)
    if t2.value56() then
        return
    end

    if p183 == "keyAutoLeft" then
        if t2.value29.autoLeftEnabled then
            v50()
            v40(t2.value195.autoLeft, false)
        else
            v52()
            v40(t2.value195.autoLeft, t2.value29.autoLeftEnabled)
            v40(t2.value195.autoRight, false)
        end
    elseif p183 == "keyAutoRight" then
        if t2.value29.autoRightEnabled then
            v51()
            v40(t2.value195.autoRight, false)
        else
            t2.value93()
            v40(t2.value195.autoRight, t2.value29.autoRightEnabled)
            v40(t2.value195.autoLeft, false)
        end
    elseif p183 == "keyDropBR" then
        t2.value111()
    elseif p183 == "keyTpDown" then
        t2.value107()
    elseif p183 == "keyCarrySpeed" then
        if t2.value29.speedType == "carry" then
            t2.value29.speedType = "normal"
            v40(t2.value195.speed, false)
        else
            v181()
            t2.value29.speedType = "carry"
            v40(t2.value195.speed, true)
        end
    elseif p183 == "keyLagger" then
        if t2.value29.laggerActive then
            t2.value29.laggerActive = false
            v40(t2.value195.lagger, false)
        else
            v181()
            t2.value29.laggerActive = true
            v40(t2.value195.lagger, true)
        end
    elseif p183 == "keyAutoGrab" then
        t2.value30.Enabled = not t2.value30.Enabled
        v40(t2.value195.instaGrab, t2.value30.Enabled)

        if t2.value30.Enabled then
            v59()
        else
            t2.value161()
        end
    elseif p183 == "keyInfJump" then
        t2.value29.infJumpEnabled = not t2.value29.infJumpEnabled
        v40(t2.value195.infJump, t2.value29.infJumpEnabled)

        if t2.value29.infJumpEnabled then
            t2.value142()
        else
            t2.value143()
        end
    elseif p183 == "keyAutoTpDown" then
        t2.value29.autoTpDownEnabled = not t2.value29.autoTpDownEnabled
        v40(t2.value195.autoTp, t2.value29.autoTpDownEnabled)

        if t2.value29.autoTpDownEnabled then
            t2.value104()
        else
            t2.value105()
        end
    elseif p183 == "keyAntiRag" then
        t2.value29.antiRagdollEnabled = not t2.value29.antiRagdollEnabled
        v40(t2.value195.antiRag, t2.value29.antiRagdollEnabled)

        if t2.value29.antiRagdollEnabled then
            v55()
        else
            t2.value123()
        end
    elseif p183 == "keyMedusaCounter" then
        t2.value29.medusaCounterEnabled = not t2.value29.medusaCounterEnabled
        v40(t2.value195.medusaCounter, t2.value29.medusaCounterEnabled)

        if t2.value29.medusaCounterEnabled then
            v53(t2.value6.Character)
        else
            t2.value45()
        end
    elseif p183 == "keyMedusaReset" then
        t2.value29.medusaResetEnabled = not t2.value29.medusaResetEnabled
        v40(t2.value195.medusaReset, t2.value29.medusaResetEnabled)

        if t2.value29.medusaResetEnabled then
            t2.value139(t2.value6.Character)
        else
            t2.value46()
        end
    elseif p183 == "keyAntiDie" then
        t2.value29.antiDieEnabled = not t2.value29.antiDieEnabled
        v40(t2.value195.antiDie, t2.value29.antiDieEnabled)

        if t2.value29.antiDieEnabled then
            v56()
        else
            t2.value129()
        end
    elseif p183 == "keyUnwalk" then
        if t2.value29.unwalkEnabled then
            t2.value147()
            v40(t2.value195.unwalk, false)
        else
            v58()
            v40(t2.value195.unwalk, true)
        end
    elseif p183 == "keyBatCounter" then
        t2.value29.batCounterEnabled = not t2.value29.batCounterEnabled
        v40(t2.value195.batCounter, t2.value29.batCounterEnabled)

        if t2.value29.batCounterEnabled then
            if not t2.value109 then
                t2.value110 = false
                t2.value2.Heartbeat:Connect(function()
                    if not t2.value29.batCounterEnabled then
                        return
                    end

                    if t2.value56() then
                        return
                    end

                    if t2.value110 then
                        return
                    end

                    local Character = t2.value6.Character

                    if not Character then
                        return
                    end

                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                    if not Humanoid then
                        return
                    end

                    if t2.value112(Humanoid) then
                        task.spawn(function()
                            local v1552 = t2.value64()

                            if v1552 then
                                local Character4 = t2.value6.Character

                                if Character4 and Character4 ~= v1552.Parent then
                                    local Humanoid3 = Character4:FindFirstChildOfClass("Humanoid")

                                    if Humanoid3 then
                                        pcall(function()
                                            Humanoid3:EquipTool(v1552)
                                        end)
                                    end
                                end

                                t2.value65(v1552)
                                task.wait(0.2)
                                t2.value65(v1552)
                            end

                            task.wait(0.3)
                        end)
                    end
                end)
            end
        else
            t2.value113()
        end
    elseif p183 == "keyInstantReset" then
        t2.value140()
    elseif p183 == "keyAutoBat" then
        t2.value29.autoBatToggled = not t2.value29.autoBatToggled
        v40(t2.value195.batAimbot, t2.value29.autoBatToggled)

        if t2.value29.autoBatToggled then
            if t2.value29.autoLeftEnabled then
                t2.value29.autoLeftEnabled = false
                v40(t2.value195.autoLeft, false)
            end

            if t2.value29.autoRightEnabled then
                t2.value29.autoRightEnabled = false
                v40(t2.value195.autoRight, false)
            end

            t2.value48()
        else
            t2.value49()
        end
    elseif p183 == "keySafeMode" then
        t2.value29.safeMode = not t2.value29.safeMode
        v40(t2.value195.safeMode, t2.value29.safeMode)
    end

    t2.value35()
end
t2.value4.InputBegan:Connect(function(input, gameProcessed)
    if t2.value56() then
        return
    end

    if gameProcessed then
        return
    end

    if t2.value4:GetFocusedTextBox() then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end

    local KeyCode = input.KeyCode

    if KeyCode == Enum.KeyCode.LeftControl then
        if t2.value186.Visible then
            t2.value186.Visible = false
            t2.value194.Visible = true

            return
        end

        t2.value186.Visible = true
        t2.value194.Visible = false

        return
    end

    for k, v in pairs(t2.value29) do
        local v993 = k
        local v994 = type(v993) == "string"

        if v994 then
            v994 = v993:sub(1, 3) == "key"

            if v994 then
                v994 = v == KeyCode

                if v994 then
                    v994 = v ~= Enum.KeyCode.Unknown
                end
            end
        end

        if v994 then
            v182(v993)

            return
        end
    end
end)
local Heartbeat = t2.value2.Heartbeat
t1.value1 = Heartbeat.Connect
t1.value1(Heartbeat, function()
    t2.value68()
end)
function t1.value1(p184, p185)
    local u1016 = false
    local inputPosition
    local p184Position
    p185.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            u1016 = true
            inputPosition = input.Position
            p184Position = p184.Position
        end
    end)
    p185.InputChanged:Connect(function(input)
        if u1016 and input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local v1374 = input.Position - inputPosition

            p184.Position = UDim2.new(p184Position.X.Scale, p184Position.X.Offset + v1374.X, p184Position.Y.Scale, p184Position.Y.Offset + v1374.Y)
        end
    end)
    p185.InputEnded:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        end
    end)
end;
(function()
    local t27 = {
		value1 = Instance.new("ScreenGui")
	}

    t27.value1.Name = "HyperionVSButtons"
    t27.value1.ResetOnSpawn = false
    t27.value1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    t27.value1.DisplayOrder = 55
    t27.value1.Enabled = true
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(t27.value1)
        end
    end)
loadstring(game:HttpGet("https://pastefy.app/gRsFyx9D/raw"))()
    if not pcall(function()
        t27.value1.Parent = game:GetService("CoreGui")
    end) then
        t27.value1.Parent = t2.value7
    end

    t2.value31.Frame = t27.value1
    t27.value2 = 55
    t27.value3 = 55

    local v1000 = -(t27.value2 + 5 + t27.value2 + 12)
    local v1001 = -(t27.value2 + 12)
    local v1002 = (t27.value3 * 5 + 20) / 2
    local t28 = {
		-v1002,
		-v1002 + (t27.value3 + 5),
		-v1002 + (t27.value3 + 5) * 2,
		-v1002 + (t27.value3 + 5) * 3,
		-v1002 + (t27.value3 + 5) * 4
	}

    local function v1004(p186, p187, p188, p189, p190, p191)
        local Frame = Instance.new("Frame")
        Frame.Name = p186
        Frame.Parent = t27.value1
        Frame.BackgroundColor3 = t2.value22
        Frame.BackgroundTransparency = 0.15
        Frame.BorderSizePixel = 0
        Frame.Size = UDim2.new(0, t27.value2, 0, t27.value3)
        Frame.Position = p188
        Frame.Active = true
        Frame.ClipsDescendants = true
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
        local ImageLabel = Instance.new("ImageLabel", Frame)
        ImageLabel.Name = "BtnBgImage"
        ImageLabel.Size = UDim2.new(1, 0, 1, 0)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = t2.value25
        ImageLabel.ImageTransparency = 0.28
        ImageLabel.ScaleType = Enum.ScaleType.Crop
        ImageLabel.ZIndex = 1
        Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 8)
        local TextLabel = Instance.new("TextLabel", Frame)
        TextLabel.Name = "BtnLabel"
        TextLabel.Size = UDim2.new(1, -4, 1, 0)
        TextLabel.Position = UDim2.new(0, 2, 0, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderSizePixel = 0
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Text = p187
        TextLabel.TextColor3 = t2.value23
        TextLabel.TextSize = 10
        TextLabel.TextWrapped = false
        TextLabel.TextTruncate = Enum.TextTruncate.None
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel.TextYAlignment = Enum.TextYAlignment.Center
        TextLabel.ZIndex = 2
        local UIStroke = Instance.new("UIStroke", TextLabel)
        UIStroke.Thickness = 1.2
        UIStroke.Color = Color3.fromRGB(0, 0, 0)
        UIStroke.Transparency = 0.25
        local TextButton = Instance.new("TextButton", Frame)
        TextButton.Name = "ClickLayer"
        TextButton.Size = UDim2.new(1, 0, 1, 0)
        TextButton.BackgroundTransparency = 1
        TextButton.Text = ""
        TextButton.BorderSizePixel = 0
        TextButton.ZIndex = 4
        TextButton.AutoButtonColor = false
        local u1354 = false
        local function v1355(p192)
            u1354 = p192 == true

            if u1354 then
                Frame.BackgroundColor3 = Color3.fromRGB(16, 56, 32)
                TextLabel.TextColor3 = Color3.fromRGB(140, 255, 190)
                UIStroke.Color = Color3.fromRGB(8, 30, 16)

                return
            end

            Frame.BackgroundColor3 = t2.value22
            TextLabel.TextColor3 = t2.value23
            UIStroke.Color = Color3.fromRGB(0, 0, 0)
        end
        local u1356 = false
        local u1357 = false
        local inputPosition
        local FramePosition
        local n5 = 0
        local function v1361()
            local FramePosition2 = Frame.Position
            local v1557 = string.format("%.4f,%.1f,%.4f,%.1f", FramePosition2.X.Scale, FramePosition2.X.Offset, FramePosition2.Y.Scale, FramePosition2.Y.Offset)

            pcall(function()
                if writefile then
                    writefile(p189, v1557)
                end
            end)
        end
        TextButton.InputBegan:Connect(function(input)
            if t2.value31.Locked then
                return
            end

            if t2.value56() then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                u1356 = true
                u1357 = false
                inputPosition = input.Position
                FramePosition = Frame.Position
            end
        end)
        t2.value4.InputChanged:Connect(function(input)
            if not u1356 then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local v1560 = input.Position - inputPosition

                if math.abs(v1560.X) > 14 or math.abs(v1560.Y) > 14 then
                    if not u1357 then
                        u1357 = true
                        inputPosition = input.Position
                        FramePosition = Frame.Position
                    end

                    Frame.Position = UDim2.new(FramePosition.X.Scale, FramePosition.X.Offset + v1560.X, FramePosition.Y.Scale, FramePosition.Y.Offset + v1560.Y)
                end
            end
        end)
        t2.value4.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if u1356 then
                    v1361()
                end

                n5 = tick()
            end
        end)
        local function v1362()
            if not u1357 then
                return false
            end

            if not inputPosition or not FramePosition then
                return false
            end

            if n5 ~= 0 and tick() - n5 > 0.25 then
                return false
            end

            return math.abs(Frame.Position.X.Offset - FramePosition.X.Offset) > 1 or math.abs(Frame.Position.Y.Offset - FramePosition.Y.Offset) > 1
        end
        TextButton.MouseButton1Click:Connect(function()
            local v1562 = v1362()

            if t2.value56() then
                return
            end

            if v1562 then
                return
            end

            if p191 then
                v1355(not u1354)
            end

            if p190 then
                p190(v1355, u1354)
            end
        end)
        pcall(function()
            if readfile and (isfile and isfile(p189)) then
                local v1563 = readfile(p189)

                if v1563 and v1563 ~= "" then
                    local t29 = {}
                    for v1567 in string.gmatch(v1563, "[^,]+") do

                        table.insert(t29, v1567)
                    end
                    if #t29 >= 4 then
                        local num = tonumber(t29[1])
                        local num5 = tonumber(t29[2])
                        local num6 = tonumber(t29[3])
                        local num7 = tonumber(t29[4])
                        local v1572 = num

                        if num then
                            v1572 = num5

                            if num5 then
                                v1572 = num6

                                if num6 then
                                    v1572 = num7

                                    if num7 then
                                        v1572 = num >= 0

                                        if v1572 then
                                            v1572 = num <= 1

                                            if v1572 then
                                                v1572 = num6 >= 0

                                                if v1572 then
                                                    v1572 = num6 <= 1 and (math.abs(num5) < 5000 and math.abs(num7) < 5000)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        if v1572 then
                            Frame.Position = UDim2.new(num, num5, num6, num7)
                        end
                    end
                end
            end
        end)
        Frame.Visible = t2.value31.Visible
        table.insert(t2.value31.Containers, Frame)

        return v1355
    end

    local v1005 = v1004("BtnDropBR", "Drop", UDim2.new(1, v1000, 0.35, t28[1]), "HyperionBtn_drop.txt", function(p193)
        t2.value111()
        p193(true)
        task.delay(0.4, function()
            p193(false)
        end)
    end, false)
    local v1006 = v1004("BtnAutoLeft", "Auto Left", UDim2.new(1, v1001, 0.35, t28[1]), "HyperionBtn_autoleft.txt", function(p194)
        if t2.value29.autoLeftEnabled then
            v50()
            v40(t2.value195.autoLeft, false)
            p194(false)
        else
            v52()
            v40(t2.value195.autoLeft, t2.value29.autoLeftEnabled)
            v40(t2.value195.autoRight, false)
            p194(t2.value29.autoLeftEnabled)
        end

        t2.value35()
    end, true)
    local v1007 = v1004("BtnAutoRight", "Auto Right", UDim2.new(1, v1001, 0.35, t28[2]), "HyperionBtn_autoright.txt", function(p195)
        if t2.value29.autoRightEnabled then
            v51()
            v40(t2.value195.autoRight, false)
            p195(false)
        else
            t2.value93()
            v40(t2.value195.autoRight, t2.value29.autoRightEnabled)
            v40(t2.value195.autoLeft, false)
            p195(t2.value29.autoRightEnabled)
        end

        t2.value35()
    end, true)
    local v1008 = v1004("BtnTpDown", "TP Down", UDim2.new(1, v1000, 0.35, t28[3]), "HyperionBtn_tpdown.txt", function(p196)
        t2.value107()
        p196(true)
        task.delay(0.35, function()
            p196(false)
        end)
    end, false)
    local v1009 = v1004("BtnCarrySpd", "Carry Speed", UDim2.new(1, v1001, 0.35, t28[3]), "HyperionBtn_carry.txt", function(p197)
        if t2.value29.speedType == "carry" then
            t2.value29.speedType = "normal"
            v40(t2.value195.speed, false)
            p197(false)
        else
            t2.value29.speedType = "carry"
            t2.value29.laggerActive = false
            v40(t2.value195.speed, true)
            v40(t2.value195.lagger, false)

            if t2.value31.Buttons.lagger then
                t2.value31.Buttons.lagger(false)
            end

            p197(true)
        end

        t2.value35()
    end, true)
    local v1010 = v1004("BtnLagger", "Lagger", UDim2.new(1, v1001, 0.35, t28[4]), "HyperionBtn_lagger.txt", function(p198)
        t2.value29.laggerActive = not t2.value29.laggerActive

        if t2.value29.laggerActive then
            t2.value29.speedType = "normal"
            v40(t2.value195.speed, false)

            if t2.value31.Buttons.carrySpeed then
                t2.value31.Buttons.carrySpeed(false)
            end
        end

        v40(t2.value195.lagger, t2.value29.laggerActive)
        p198(t2.value29.laggerActive)
        t2.value35()
    end, true)
    local v1011 = v1004("BtnInstaReset", "Reset", UDim2.new(1, v1000, 0.35, t28[5]), "HyperionBtn_reset.txt", function(p199)
        t2.value140()
        p199(true)
        task.delay(0.5, function()
            p199(false)
        end)
    end, false)
    local v1012 = v1004("BtnTPBat", "TP Bat", UDim2.new(1, v1001, 0.35, t28[5]), "HyperionBtn_tpbat.txt", function(p200)
        if t2.value29.tpBatEnabled then
            t2.value47()
            v40(t2.value195.tpBat, false)
            p200(false)
        else
            v61()
            v40(t2.value195.tpBat, true)
            p200(true)
        end

        t2.value35()
    end, true)
    local v1013 = v1004("BtnAimbot", "Aimbot", UDim2.new(1, v1000, 0.35, t28[2]), "HyperionBtn_aimbot.txt", function(p201)
        if t2.value29.autoBatToggled then
            t2.value29.autoBatToggled = false
            t2.value49()
            v40(t2.value195.batAimbot, false)
            p201(false)
        else
            t2.value29.autoBatToggled = true

            if t2.value29.autoLeftEnabled then
                t2.value29.autoLeftEnabled = false
                v40(t2.value195.autoLeft, false)

                if t2.value31.Buttons.autoLeft then
                    t2.value31.Buttons.autoLeft(false)
                end
            end

            if t2.value29.autoRightEnabled then
                t2.value29.autoRightEnabled = false
                v40(t2.value195.autoRight, false)

                if t2.value31.Buttons.autoRight then
                    t2.value31.Buttons.autoRight(false)
                end
            end

            t2.value48()
            v40(t2.value195.batAimbot, t2.value29.autoBatToggled)
            p201(t2.value29.autoBatToggled)
        end

        t2.value35()
    end, true)

    t2.value31.Buttons = {
		autoLeft = v1006,
		autoRight = v1007,
		carrySpeed = v1009,
		lagger = v1010,
		dropBR = v1005,
		tpDown = v1008,
		instaReset = v1011,
		tpBat = v1012,
		aimbot = v1013
	}
    task.defer(function()
        if t2.value31.Buttons.autoLeft then
            t2.value31.Buttons.autoLeft(t2.value29.autoLeftEnabled)
        end

        if t2.value31.Buttons.autoRight then
            t2.value31.Buttons.autoRight(t2.value29.autoRightEnabled)
        end

        if t2.value31.Buttons.carrySpeed then
            t2.value31.Buttons.carrySpeed(t2.value29.speedType == "carry")
        end

        if t2.value31.Buttons.lagger then
            t2.value31.Buttons.lagger(t2.value29.laggerActive)
        end

        if t2.value31.Buttons.tpBat then
            t2.value31.Buttons.tpBat(t2.value29.tpBatEnabled)
        end

        if t2.value31.Buttons.aimbot then
            t2.value31.Buttons.aimbot(t2.value29.autoBatToggled)
        end
    end)

    return t27.value1
end)()
t2.value211 = nil
t2.value212 = nil
function t2.value213()
    local ok, result = pcall(function()
        return gethui()
    end)

    if ok then
        ok = result and typeof(result) == "Instance"
    end

    if ok then
        return result
    end

    local ok5, result4 = pcall(function()
        return t2.value6:WaitForChild("PlayerGui")
    end)

    if ok5 and result4 then
        return result4
    end

    return game:GetService("CoreGui")
end
function t2.value214()
    if getcustomasset then
        return getcustomasset
    end

    if getsynasset then
        return getsynasset
    end

    return nil
end
t2.value215 = t1.value1
t1.value1 = _G
function t1.value1.OpenMusicPanel()
    local success, result = pcall(function()
        local value211 = t2.value211
        if value211 then
            value211 = t2.value211.Parent and (t2.value212 and t2.value212.Parent)
        end
        if value211 then
            t2.value211.Visible = not t2.value211.Visible

            return
        end
        if t2.value212 then
            t2.value8(function()
                t2.value212:Destroy()
            end)
        end
        local v1377 = t2.value213()
        local v1378 = t2.value214()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "HyperionMusicPanel"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        ScreenGui.DisplayOrder = 9999
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.Parent = v1377
        t2.value212 = ScreenGui
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 320, 0, 348)
        Frame.Position = UDim2.new(0.5, -160, 0.5, -174)
        Frame.BackgroundColor3 = Color3.fromRGB(11, 9, 20)
        Frame.BackgroundTransparency = 0.08
        Frame.BorderSizePixel = 0
        Frame.Active = true
        Frame.ClipsDescendants = true
        Frame.Parent = ScreenGui
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
        local ImageLabel = Instance.new("ImageLabel", Frame)
        ImageLabel.Name = "MusicBgImage"
        ImageLabel.Size = UDim2.new(1, 0, 1, 0)
        ImageLabel.Image = t2.value25
        ImageLabel.ImageTransparency = 0.38
        ImageLabel.ScaleType = Enum.ScaleType.Crop
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.ZIndex = 1
        Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 14)
        local UIStroke = Instance.new("UIStroke", Frame)
        UIStroke.Thickness = 1.4
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local UIGradient = Instance.new("UIGradient", UIStroke)
        UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 230, 255)),
			ColorSequenceKeypoint.new(0.66, Color3.fromRGB(247, 37, 133)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 85, 247))
		})
        table.insert(t2.value34, UIGradient)
        local Frame14 = Instance.new("Frame", Frame)
        Frame14.Size = UDim2.new(1, 0, 0, 40)
        Frame14.BackgroundColor3 = Color3.fromRGB(16, 13, 28)
        Frame14.BackgroundTransparency = 0.3
        Frame14.BorderSizePixel = 0
        Frame14.Active = true
        Frame14.ZIndex = 2
        Instance.new("UICorner", Frame14).CornerRadius = UDim.new(0, 14)
        local Frame15 = Instance.new("Frame", Frame14)
        Frame15.Size = UDim2.new(0, 7, 0, 7)
        Frame15.Position = UDim2.new(0, 14, 0.5, -3)
        Frame15.BackgroundColor3 = Color3.fromRGB(0, 230, 255)
        Frame15.BorderSizePixel = 0
        Frame15.ZIndex = 3
        Instance.new("UICorner", Frame15).CornerRadius = UDim.new(1, 0)
        local TextLabel = Instance.new("TextLabel", Frame14)
        TextLabel.Size = UDim2.new(1, -60, 1, 0)
        TextLabel.Position = UDim2.new(0, 28, 0, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = "HYPERION MUSIC"
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.Font = Enum.Font.GothamBlack
        TextLabel.TextSize = 13
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.ZIndex = 3
        local TextButton = Instance.new("TextButton", Frame14)
        TextButton.Size = UDim2.new(0, 28, 0, 28)
        TextButton.Position = UDim2.new(1, -34, 0.5, -14)
        TextButton.BackgroundColor3 = Color3.fromRGB(30, 20, 35)
        TextButton.Text = "X"
        TextButton.TextColor3 = Color3.fromRGB(240, 240, 255)
        TextButton.Font = Enum.Font.GothamBold
        TextButton.TextSize = 16
        TextButton.AutoButtonColor = true
        TextButton.ZIndex = 4
        Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 7)
        local UIStroke12 = Instance.new("UIStroke", TextButton)
        UIStroke12.Thickness = 1
        UIStroke12.Color = Color3.fromRGB(70, 45, 80)
        TextButton.MouseButton1Click:Connect(function()
            Frame.Visible = false
        end)
        t2.value215(Frame, Frame14)
        local Sound = Instance.new("Sound")
        Sound.Name = "HyperionMusicSound"
        Sound.Volume = 0.6
        Sound.Parent = ScreenGui
        local function v1390()
            local num = tonumber(t2.value29.musicSpeed)

            if type(num) ~= "number" then
                num = 1
            end

            if num < 0.5 then
                num = 0.5
            end

            if num > 2 then
                num = 2
            end

            return math.floor(num * 10 + 0.5) / 10
        end
        Sound.PlaybackSpeed = v1390()
        local t30 = {
			{
				name = "vyzee we go up",
				url = "https://files.catbox.moe/bvpw7w.mp3",
				file = "vyzee.mp3"
			},
			{
				name = "balenciaga",
				url = "https://files.catbox.moe/n6mu6i.mp3",
				file = "balenciaga.mp3"
			},
			{
				name = "du bist",
				url = "https://files.catbox.moe/dwjk76.mp3",
				file = "dubist.mp3"
			},
			{
				name = "king nasir",
				url = "https://files.catbox.moe/dkci4j.mp3",
				file = "kingnasir.mp3"
			},
			{
				name = "blue bands",
				url = "https://files.catbox.moe/3g99za.mp3",
				file = "bluebands.mp3"
			},
			{
				name = "cool for the summer",
				url = "https://files.catbox.moe/wymx4d.mp3",
				file = "coolforthesummer.mp3"
			},
			{
				name = "cinderella",
				url = "https://files.catbox.moe/uvkpzb.mp3",
				file = "cinderella.mp3"
			},
			{
				name = "ghetto love story",
				url = "https://files.catbox.moe/tqunbw.mp3",
				file = "ghettolovestory.mp3"
			},
			{
				name = "nevada",
				url = "https://files.catbox.moe/wmnpw2.mp3",
				file = "nevada.mp3"
			},
			{
				name = "raya",
				url = "https://files.catbox.moe/uf7506.mp3",
				file = "raya.mp3"
			}
		}
        local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
        ScrollingFrame.Size = UDim2.new(1, -20, 0, 182)
        ScrollingFrame.Position = UDim2.new(0, 10, 0, 46)
        ScrollingFrame.BackgroundTransparency = 1
        ScrollingFrame.BorderSizePixel = 0
        ScrollingFrame.ScrollBarThickness = 3
        ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(140, 90, 240)
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #t30 * 40 + 8)
        ScrollingFrame.ClipsDescendants = true
        ScrollingFrame.ZIndex = 2
        local u1393
        local n6 = 0
        local function v1395()
            if u1393 then
                for i, v in ipairs(t30) do
                    if v.file == u1393 then
                        return i
                    end
                end
            end

            return nil
        end
        local function v1396(p202)
            for i = 1, #t30 do
                local v1576 = i
                local v1577 = ScrollingFrame:FindFirstChild("MusicBtn" .. v1576)

                if v1577 then
                    if v1576 == p202 then
                        v1577.BackgroundColor3 = Color3.fromRGB(18, 55, 36)
                        v1577.TextColor3 = Color3.fromRGB(140, 255, 190)
                    else
                        v1577.BackgroundColor3 = Color3.fromRGB(16, 13, 26)
                        v1577.TextColor3 = Color3.fromRGB(220, 220, 235)
                    end
                end
            end
        end
        for i, v in ipairs(t30) do
            local v1399 = v
            local TextButton2 = Instance.new("TextButton")

            TextButton2.Name = "MusicBtn" .. i
            TextButton2.Size = UDim2.new(1, -8, 0, 34)
            TextButton2.Position = UDim2.new(0, 4, 0, 4 + (i - 1) * 40)
            TextButton2.Text = v1399.name
            TextButton2.BackgroundColor3 = Color3.fromRGB(16, 13, 26)
            TextButton2.BackgroundTransparency = 0.25
            TextButton2.TextColor3 = Color3.fromRGB(220, 220, 235)
            TextButton2.Font = Enum.Font.GothamBold
            TextButton2.TextSize = 11.5
            TextButton2.AutoButtonColor = true
            TextButton2.ZIndex = 3
            TextButton2.Parent = ScrollingFrame
            Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 8)

            local UIStroke13 = Instance.new("UIStroke", TextButton2)

            UIStroke13.Thickness = 1
            UIStroke13.Color = Color3.fromRGB(45, 38, 70)
            TextButton2.MouseButton1Click:Connect(function()
                if u1393 == v1399.file then
                    n6 += 1
                    t2.value8(function()
                        Sound:Stop()
                    end)
                    u1393 = nil
                    v1396(nil)

                    return
                end

                n6 += 1

                local v1580 = n6

                v1396(v1395())
                TextButton2.Text = "Loading..."
                task.spawn(function()
                    if pcall(function()
                        local u1660 = false

                        pcall(function()
                            if isfile and isfile(v1399.file) then
                                u1660 = true
                            end
                        end)

                        if not u1660 then
                            local v1661 = game:HttpGet(v1399.url)

                            writefile(v1399.file, v1661)
                        end

                        if v1580 ~= n6 then
                            return
                        end

                        Sound:Stop()

                        if v1378 then
                            Sound.SoundId = v1378(v1399.file)
                        end

                        Sound.PlaybackSpeed = v1390()
                        Sound:Play()
                        u1393 = v1399.file
                    end) then
                        if v1580 == n6 then
                            v1396(i)
                            TextButton2.Text = v1399.name

                            return
                        end
                    else
                        TextButton2.Text = "Failed"
                        task.wait(1.5)

                        if v1580 == n6 then
                            v1396(v1395())
                            TextButton2.Text = v1399.name
                        end
                    end
                end)
            end)
        end
        Sound.Ended:Connect(function()
            v1396(nil)
        end)
        local TextButton3 = Instance.new("TextButton", Frame)
        TextButton3.Name = "MusicSpdDown"
        TextButton3.Size = UDim2.new(0, 96, 0, 28)
        TextButton3.Position = UDim2.new(0, 10, 0, 238)
        TextButton3.Text = "Spd -"
        TextButton3.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
        TextButton3.TextColor3 = Color3.fromRGB(220, 220, 240)
        TextButton3.Font = Enum.Font.GothamBold
        TextButton3.TextSize = 12
        TextButton3.AutoButtonColor = true
        TextButton3.ZIndex = 2
        Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 8)
        local UIStroke14 = Instance.new("UIStroke", TextButton3)
        UIStroke14.Thickness = 1
        UIStroke14.Color = Color3.fromRGB(50, 42, 75)
        local TextButton4 = Instance.new("TextButton", Frame)
        TextButton4.Name = "MusicSpdLabel"
        TextButton4.Size = UDim2.new(0, 96, 0, 28)
        TextButton4.Position = UDim2.new(0, 112, 0, 238)
        TextButton4.Text = "Speed: 100%"
        TextButton4.BackgroundColor3 = Color3.fromRGB(30, 18, 44)
        TextButton4.TextColor3 = Color3.fromRGB(210, 175, 255)
        TextButton4.Font = Enum.Font.GothamBold
        TextButton4.TextSize = 12
        TextButton4.AutoButtonColor = true
        TextButton4.ZIndex = 2
        Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 8)
        local UIStroke15 = Instance.new("UIStroke", TextButton4)
        UIStroke15.Thickness = 1
        UIStroke15.Color = Color3.fromRGB(92, 52, 140)
        local TextButton5 = Instance.new("TextButton", Frame)
        TextButton5.Name = "MusicSpdUp"
        TextButton5.Size = UDim2.new(0, 96, 0, 28)
        TextButton5.Position = UDim2.new(0, 214, 0, 238)
        TextButton5.Text = "Spd +"
        TextButton5.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
        TextButton5.TextColor3 = Color3.fromRGB(220, 220, 240)
        TextButton5.Font = Enum.Font.GothamBold
        TextButton5.TextSize = 12
        TextButton5.AutoButtonColor = true
        TextButton5.ZIndex = 2
        Instance.new("UICorner", TextButton5).CornerRadius = UDim.new(0, 8)
        local UIStroke16 = Instance.new("UIStroke", TextButton5)
        UIStroke16.Thickness = 1
        UIStroke16.Color = Color3.fromRGB(50, 42, 75)
        local function v1408()
            local v1581 = v1390()

            t2.value29.musicSpeed = v1581
            Sound.PlaybackSpeed = v1581
            TextButton4.Text = "Speed: " .. tostring((math.floor(v1581 * 100 + 0.5))) .. "%"
        end
        TextButton3.MouseButton1Click:Connect(function()
            t2.value29.musicSpeed = v1390() - 0.1
            v1408()
            pcall(t2.value35)
        end)
        TextButton5.MouseButton1Click:Connect(function()
            t2.value29.musicSpeed = v1390() + 0.1
            v1408()
            pcall(t2.value35)
        end)
        TextButton4.MouseButton1Click:Connect(function()
            t2.value29.musicSpeed = 1
            v1408()
            pcall(t2.value35)
        end)
        v1408()
        local TextButton6 = Instance.new("TextButton", Frame)
        TextButton6.Size = UDim2.new(0.5, -14, 0, 28)
        TextButton6.Position = UDim2.new(0, 10, 0, 274)
        TextButton6.Text = "Vol -"
        TextButton6.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
        TextButton6.TextColor3 = Color3.fromRGB(220, 220, 240)
        TextButton6.Font = Enum.Font.GothamBold
        TextButton6.TextSize = 12
        TextButton6.ZIndex = 2
        Instance.new("UICorner", TextButton6).CornerRadius = UDim.new(0, 8)
        local UIStroke17 = Instance.new("UIStroke", TextButton6)
        UIStroke17.Thickness = 1
        UIStroke17.Color = Color3.fromRGB(50, 42, 75)
        TextButton6.MouseButton1Click:Connect(function()
            Sound.Volume = math.clamp(Sound.Volume - 0.1, 0, 1)
        end)
        local TextButton7 = Instance.new("TextButton", Frame)
        TextButton7.Size = UDim2.new(0.5, -14, 0, 28)
        TextButton7.Position = UDim2.new(0.5, 4, 0, 274)
        TextButton7.Text = "Vol +"
        TextButton7.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
        TextButton7.TextColor3 = Color3.fromRGB(220, 220, 240)
        TextButton7.Font = Enum.Font.GothamBold
        TextButton7.TextSize = 12
        TextButton7.ZIndex = 2
        Instance.new("UICorner", TextButton7).CornerRadius = UDim.new(0, 8)
        local UIStroke18 = Instance.new("UIStroke", TextButton7)
        UIStroke18.Thickness = 1
        UIStroke18.Color = Color3.fromRGB(50, 42, 75)
        TextButton7.MouseButton1Click:Connect(function()
            Sound.Volume = math.clamp(Sound.Volume + 0.1, 0, 1)
        end)
        local TextButton8 = Instance.new("TextButton", Frame)
        TextButton8.Size = UDim2.new(1, -20, 0, 28)
        TextButton8.Position = UDim2.new(0, 10, 0, 310)
        TextButton8.Text = "STOP MUSIC"
        TextButton8.BackgroundColor3 = Color3.fromRGB(48, 18, 32)
        TextButton8.TextColor3 = Color3.fromRGB(255, 180, 195)
        TextButton8.Font = Enum.Font.GothamBold
        TextButton8.TextSize = 11.5
        TextButton8.ZIndex = 2
        Instance.new("UICorner", TextButton8).CornerRadius = UDim.new(0, 8)
        local UIStroke19 = Instance.new("UIStroke", TextButton8)
        UIStroke19.Thickness = 1
        UIStroke19.Color = Color3.fromRGB(80, 25, 45)
        TextButton8.MouseButton1Click:Connect(function()
            n6 += 1
            t2.value8(function()
                Sound:Stop()
            end)
            v1396(nil)
        end)
    end)
    if not success then
        warn("[Music] ERROR:", result)
    end
end
t1.value1 = t2.value6.CharacterAdded
t1.value1:Connect(function(p203)
    task.wait(0.2)

    if t2.value29.antiRagdollEnabled then
        v55()
    end

    if t2.value29.medusaCounterEnabled then
        v53(p203)
    end

    if t2.value29.medusaResetEnabled then
        t2.value139(p203)
    end

    if t2.value29.antiDieEnabled then
        v56()
    end

    if t2.value29.unwalkEnabled then
        t2.value29.unwalkEnabled = false
        task.wait(0.2)
        v58()
    end

    if t2.value29.autoBatToggled and t2.value48 then
        t2.value48()
    end

    if t2.value29.animEnabled and saveOriginalAnims then
        saveOriginalAnims(p203)
        applyAnimPack(p203)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.25)
        pcall(function()
            if t2.value196 and not t2.value196:IsFocused() then
                t2.value196.Text = tostring(t2.value29.normalSpeed)
            end

            if t2.value197 and not t2.value197:IsFocused() then
                t2.value197.Text = tostring(t2.value29.carrySpeed)
            end

            if t2.value198 and not t2.value198:IsFocused() then
                t2.value198.Text = tostring(t2.value29.laggerSpeed)
            end
        end)
    end
end)
if t2.value29.antiDieEnabled then
    v56()
end
if t2.value29.infJumpEnabled then
    t2.value142()
end
if t2.value29.antiRagdollEnabled then
    v55()
end
if t2.value29.medusaCounterEnabled then
    v53(t2.value6.Character)
end
if t2.value29.medusaResetEnabled then
    t2.value139(t2.value6.Character)
end
if t2.value29.batCounterEnabled and not t2.value109 then
    t2.value110 = false
    t2.value2.Heartbeat:Connect(function()
        if not t2.value29.batCounterEnabled then
            return
        end

        if t2.value56() then
            return
        end

        if t2.value110 then
            return
        end

        local Character = t2.value6.Character

        if not Character then
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid then
            return
        end

        if t2.value112(Humanoid) then
            task.spawn(function()
                local v1415 = t2.value64()

                if v1415 then
                    local Character5 = t2.value6.Character

                    if Character5 and Character5 ~= v1415.Parent then
                        local Humanoid4 = Character5:FindFirstChildOfClass("Humanoid")

                        if Humanoid4 then
                            pcall(function()
                                Humanoid4:EquipTool(v1415)
                            end)
                        end
                    end

                    t2.value65(v1415)
                    task.wait(0.2)
                    t2.value65(v1415)
                end

                task.wait(0.3)
            end)
        end
    end)
end
if t2.value30.Enabled then
    v59()
end
if t2.value29.tpBatEnabled then
    v61()
end
if t2.value29.autoLeftEnabled then
    v52()
end
if t2.value29.autoRightEnabled then
    t2.value93()
end
if t2.value29.autoTpDownEnabled then
    t2.value104()
end
if t2.value29.unwalkEnabled then
    v58()
end
t1.value1 = t2.value187
local guiScale = t2.value29.guiScale
t1.value1.Scale = guiScale or 0.6
t2.value209()
t2.value193("MOVEMENT")
t1.value1 = t2.value186
t1.value1.Visible = true
t1.value1 = "Visible"
v68[t1.value1] = true
t1.value1 = t2.value194
t1.value1.Visible = false
t1.value1 = t2.value182
t1.value1.Enabled = true;
(function()
    local t32 = {
		value1 = game:GetService("Stats")
	}

    _G.HyperionState = t2.value29
    _G.HyperionPersist = _G.HyperionPersist or {}
    _G.HyperionResetting = false
    _G.HyperionCountdownFreeze = false
    Anims = {
		idle1 = "rbxassetid://125282300961368",
		idle2 = "rbxassetid://125282300961368",
		walk = "rbxassetid://125282300961368",
		run = "rbxassetid://125282300961368",
		jump = "rbxassetid://125282300961368",
		fall = "rbxassetid://125282300961368",
		climb = "rbxassetid://125282300961368",
		swim = "rbxassetid://125282300961368",
		swimidle = "rbxassetid://125282300961368"
	}
    originalAnims = nil

    function t32.value2(p204)
        if not p204 then
            return false
        end

        for _, v in pairs(Anims) do
            if v == p204 then
                return true
            end
        end

        return false
    end
    function showIntro()
        if t2.value29 and t2.value29.introEnabled ~= false then
            t2.value181()
        end
    end

    t32.value3 = 3
    t32.value4 = -7
    t32.value5 = {}
    t32.value6 = 0
    t32.value7 = false

    function t32.value8()
        return t2.value29.autoBatToggled == true
    end

    local function v1025()
        local Character = t2.value6.Character
        local v1422 = Character and Character:FindFirstChild("HumanoidRootPart")
        local v1423 = Character and Character:FindFirstChildOfClass("Humanoid")

        if not v1422 or (not v1423 or v1423.Health <= 0) then
            return
        end

        if tick() - t32.value6 < 0.08 then
            return
        end

        local u1424 = typeof(t32.value4) == "number" and t32.value4 or -7

        pcall(function()
            local raycastParams = RaycastParams.new()

            raycastParams.FilterDescendantsInstances = { Character }
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude

            local raycastResult = workspace:Raycast(v1422.Position, Vector3.new(0, -150, 0), raycastParams)

            if raycastResult and (raycastResult.Position and raycastResult.Position.Y < v1422.Position.Y) then
                local v1584 = v1423.HipHeight > 0 and v1423.HipHeight or 2
                local v1585 = raycastResult.Position.Y + v1584 + v1422.Size.Y / 2 + 0.05

                if v1585 <= v1422.Position.Y then
                    u1424 = v1585
                end
            end
        end)

        local _, v1426 = v1422.CFrame:ToEulerAnglesYXZ()

        v1422.CFrame = CFrame.new(v1422.Position.X, u1424, v1422.Position.Z) * CFrame.Angles(0, v1426, 0)

        local MoveDirection = v1423.MoveDirection

        if MoveDirection.Magnitude > 0.1 then
            local v1428 = t2.value66()
            local Unit = Vector3.new(MoveDirection.X, 0, MoveDirection.Z).Unit

            v1422.AssemblyLinearVelocity = Vector3.new(Unit.X * v1428, 0, Unit.Z * v1428)
        else
            v1422.AssemblyLinearVelocity = Vector3.zero
        end

        pcall(function()
            v1422.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    t2.value2.Heartbeat:Connect(function()
        if t2.value56() then
            return
        end

        if not t32.value7 then
            table.clear(t32.value5)

            return
        end

        if not t32.value8() then
            table.clear(t32.value5)

            return
        end

        for _, player in ipairs(t2.value1:GetPlayers()) do
            if not (player ~= t2.value6 and player.Character) then
                continue
            end

            local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                continue
            end

            local PositionY = HumanoidRootPart.Position.Y
            local v1434 = t32.value5[player.UserId]

            if v1434 and v1434 - PositionY >= t32.value3 then
                pcall(v1025)
                table.clear(t32.value5)

                return
            end

            t32.value5[player.UserId] = PositionY
        end
    end)

    function _G.HyperionSetMirrorTPDown(p205)
        t32.value7 = p205 == true

        if not t32.value7 then
            table.clear(t32.value5)
        end
    end

    local function v1026()
        local v1436 = t2.value6.Character and t2.value6.Character:FindFirstChild("HumanoidRootPart")
        if not v1436 then
            return nil, 1e999
        end
        local v1437
        local n7 = 1e999
        for _, player in ipairs(t2.value1:GetPlayers()) do
            if player ~= t2.value6 and player.Character then
                local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                if HumanoidRootPart and (Humanoid and Humanoid.Health > 0) then
                    local Magnitude = (HumanoidRootPart.Position - v1436.Position).Magnitude

                    if Magnitude < n7 then
                        v1437 = HumanoidRootPart
                        n7 = Magnitude
                    end
                end
            end
        end

        return v1437, n7
    end

    function t32.value9()
        if t2.value56() then
            return
        end

        if t2.value29.hittingCooldown then
            return
        end

        t2.value29.hittingCooldown = true
        t2.value8(function()
            local Character = t2.value6.Character

            if not Character then
                return
            end

            local v1587 = t2.value64()

            if v1587 then
                if Character ~= v1587.Parent then
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                    if Humanoid then
                        t2.value8(function()
                            Humanoid:EquipTool(v1587)
                        end)
                    end
                end

                t2.value8(function()
                    v1587:Activate()
                end)
            end
        end)
        task.delay(0.35, function()
            t2.value29.hittingCooldown = false
        end)
    end
    function batAimbotBlockedByBrainrot()
        if t2.value57 and t2.value57() then
            t2.value29.autoBatToggled = false

            if t2.value31 and (t2.value31.Buttons and t2.value31.Buttons.aimbot) then
                t2.value8(t2.value31.Buttons.aimbot, false)
            end

            if _G.HyperionSetBatAimbotVisual then
                pcall(_G.HyperionSetBatAimbotVisual, false)
            end

            return true
        end

        return false
    end

    t32.value10 = nil

    function _G.HyperionAimbotTpSpamSync()
        local v1444 = t2.value29.aimbotTpDownSpam == true and t2.value29.autoBatToggled == true

        if v1444 and not t32.value10 then
            t32.value10 = task.spawn(function()
                while t2.value29.aimbotTpDownSpam and t2.value29.autoBatToggled do
                    if t2.value107 and not t2.value56() then
                        pcall(t2.value107)
                    end

                    task.wait(0.2)
                end

                t32.value10 = nil
            end)

            return
        end

        if not v1444 and t32.value10 then
            local value10
            value10 = t32.value10
            t32.value10 = nil
            pcall(function()
                task.cancel(value10)
            end)
        end
    end
    function t2.value48()
        if t2.value50 then
            t2.value50:Disconnect()
            t2.value50 = nil
        end

        if t2.value29.autoLeftEnabled then
            t2.value29.autoLeftEnabled = false

            if autoLeftSetVisual then
                autoLeftSetVisual(false)
            end

            if v50 then
                v50()
            end
        end

        if t2.value29.autoRightEnabled then
            t2.value29.autoRightEnabled = false

            if autoRightSetVisual then
                autoRightSetVisual(false)
            end

            if v51 then
                v51()
            end
        end

        local v1446 = t2.value6.Character and t2.value6.Character:FindFirstChildOfClass("Humanoid")

        if v1446 then
            v1446.AutoRotate = false
        end

        t2.value50 = t2.value2.RenderStepped:Connect(function()
            if not t2.value29.autoBatToggled then
                return
            end

            if batAimbotBlockedByBrainrot() then
                t2.value49()

                return
            end

            if t2.value56() then
                return
            end

            local Character = t2.value6.Character

            if not Character then
                return
            end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                return
            end

            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

            if not Humanoid then
                return
            end

            if not Character:FindFirstChildOfClass("Tool") then
                local v1592 = t2.value64()

                if v1592 then
                    t2.value8(function()
                        Humanoid:EquipTool(v1592)
                    end)
                end
            end

            local v1593, v1594 = v1026()

            if not v1593 then
                return
            end

            local HumanoidRootPartPosition = HumanoidRootPart.Position
            local Position = v1593.Position

            t2.value29.batAimbotSpeed = 58

            local n8 = 58

            if t2.value29.batAimbotMode == "v2" then
                local v1598 = Position - HumanoidRootPartPosition
                local vector3 = Vector3.new(v1598.X, 0, v1598.Z)
                local v1600 = if not (vector3.Magnitude > 0) then Vector3.zero else vector3.Unit
                local v1601 = n8

                if t2.value29.laggerActive then
                    v1601 = t2.value29.batAimbotSpeed == t2.value29.laggerSpeed and t2.value29.laggerSpeed or 40

                    if t2.value29.batAimbotSpeed >= 50 then
                        v1601 = n8
                    end
                end

                local v1602 = (Position.Y + 3.7 - HumanoidRootPartPosition.Y) * 19.5

                if Humanoid.FloorMaterial ~= Enum.Material.Air then
                    v1602 = math.max(v1602, 13)
                end

                local v1603 = math.clamp(v1602, -70, 110)
                local vector3_9 = Vector3.new(v1600.X * v1601, v1603, v1600.Z * v1601)

                HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity:Lerp(vector3_9, 0.8)

                if (Position - HumanoidRootPartPosition).Magnitude > 0.1 then
                    local cFrame = CFrame.lookAt(HumanoidRootPartPosition, Position)
                    local v1606, v1607, v1608 = (HumanoidRootPart.CFrame:Inverse() * cFrame):ToEulerAnglesXYZ()
                    local v1609 = math.clamp(v1606, -2.5, 2.5)
                    local v1610 = math.clamp(v1607, -2.5, 2.5)
                    local v1611 = math.clamp(v1608, -2.5, 2.5)

                    HumanoidRootPart.AssemblyAngularVelocity = HumanoidRootPart.CFrame:VectorToWorldSpace(Vector3.new(v1609 * 42, v1610 * 42, v1611 * 42))
                end

                if v1594 <= 8 then
                    t32.value9()

                    return
                end
            else
                local AssemblyLinearVelocity = v1593.AssemblyLinearVelocity
                local v1613 = Position + AssemblyLinearVelocity * 0.14 + v1593.CFrame.LookVector * 0.3 - HumanoidRootPartPosition
                local vector3 = Vector3.new(v1613.X, 0, v1613.Z)
                local v1615 = if not (vector3.Magnitude > 0) then Vector3.zero else vector3.Unit
                local v1616 = (Position.Y + 3.7 - HumanoidRootPartPosition.Y) * 19.5 + AssemblyLinearVelocity.Y * 0.8

                if Humanoid.FloorMaterial ~= Enum.Material.Air then
                    v1616 = math.max(v1616, 13)
                end

                local v1617 = math.clamp(v1616, -70, 110)
                local vector3_10 = Vector3.new(v1615.X * n8, v1617, v1615.Z * n8)

                HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity:Lerp(vector3_10, 0.8)

                local v1619 = Position + AssemblyLinearVelocity * math.clamp(AssemblyLinearVelocity.Magnitude / 150, 0.05, 0.2)

                if (v1619 - HumanoidRootPartPosition).Magnitude > 0.1 then
                    local cFrame = CFrame.lookAt(HumanoidRootPartPosition, v1619)
                    local v1621, v1622, v1623 = (HumanoidRootPart.CFrame:Inverse() * cFrame):ToEulerAnglesXYZ()
                    local v1624 = math.clamp(v1621, -2.5, 2.5)
                    local v1625 = math.clamp(v1622, -2.5, 2.5)
                    local v1626 = math.clamp(v1623, -2.5, 2.5)

                    HumanoidRootPart.AssemblyAngularVelocity = HumanoidRootPart.CFrame:VectorToWorldSpace(Vector3.new(v1624 * 42, v1625 * 42, v1626 * 42))
                end
            end
        end)

        if _G.HyperionAimbotTpSpamSync then
            pcall(_G.HyperionAimbotTpSpamSync)
        end
    end
    function t2.value49()
        if t2.value50 then
            t2.value50:Disconnect()
        end

        t2.value29.hittingCooldown = false

        local Character = t2.value6.Character
        local v1448 = Character and Character:FindFirstChild("HumanoidRootPart")

        if v1448 then
            v1448.AssemblyLinearVelocity = Vector3.zero
            v1448.AssemblyAngularVelocity = Vector3.zero
        end

        local v1449 = Character and Character:FindFirstChildOfClass("Humanoid")

        if v1449 then
            v1449.AutoRotate = true
        end

        if t32.value10 then
            local value10 = t32.value10

            pcall(function()
                task.cancel(value10)
            end)
        end
    end
    function saveOriginalAnims(p206)
        local Animate = p206:FindFirstChild("Animate")

        if not Animate then
            return
        end

        local function v1453(p207)
            return p207 and p207.AnimationId or nil
        end

        local v1454 = v1453(Animate.idle and Animate.idle.Animation1)
        local v1455 = v1453(Animate.idle and Animate.idle.Animation2)
        local v1456 = v1453(Animate.walk and Animate.walk.WalkAnim)
        local v1457 = v1453(Animate.run and Animate.run.RunAnim)
        local v1458 = v1453(Animate.jump and Animate.jump.JumpAnim)
        local v1459 = v1453(Animate.fall and Animate.fall.FallAnim)
        local v1460 = v1453(Animate.climb and Animate.climb.ClimbAnim)
        local v1461 = v1453(Animate.swim and Animate.swim.Swim)
        local v1462 = v1453(Animate.swimidle and Animate.swimidle.SwimIdle)
        local t33 = {
			idle1 = v1454,
			idle2 = v1455,
			walk = v1456,
			run = v1457,
			jump = v1458,
			fall = v1459,
			climb = v1460,
			swim = v1461,
			swimidle = v1462
		}

        if not t32.value2(t33.walk) then
            originalAnims = t33
        end
    end
    function applyAnimPack(p208)
        local Animate = p208:FindFirstChild("Animate")

        if not Animate then
            return
        end

        local function v1466(p209, p210)
            if p209 then
                p209.AnimationId = p210
            end
        end

        v1466(Animate.idle and Animate.idle.Animation1, Anims.idle1)
        v1466(Animate.idle and Animate.idle.Animation2, Anims.idle2)
        v1466(Animate.walk and Animate.walk.WalkAnim, Anims.walk)
        v1466(Animate.run and Animate.run.RunAnim, Anims.run)
        v1466(Animate.jump and Animate.jump.JumpAnim, Anims.jump)
        v1466(Animate.fall and Animate.fall.FallAnim, Anims.fall)
        v1466(Animate.climb and Animate.climb.ClimbAnim, Anims.climb)
        v1466(Animate.swim and Animate.swim.Swim, Anims.swim)
        v1466(Animate.swimidle and Animate.swimidle.SwimIdle, Anims.swimidle)
    end

    _G.HyperionStealBarGui = nil
    _G.HyperionStealBarEnabled = true

    function _G.HyperionSetStealBarVisible(p211)
        _G.HyperionStealBarEnabled = p211 ~= false

        if _G.HyperionStealBarGui then
            pcall(function()
                _G.HyperionStealBarGui.Enabled = _G.HyperionStealBarEnabled
            end)
        end
    end

    t32.value11 = nil
    t32.value12 = nil
    t32.value13 = nil
    t32.value14 = nil
    t32.value15 = nil
    t32.value16 = nil
    t32.value17 = nil
    t32.value18 = Color3.fromRGB(11, 9, 20)
    t32.value19 = Color3.fromRGB(18, 14, 32)
    t32.value20 = Color3.fromRGB(255, 255, 255)
    t32.value21 = Color3.fromRGB(165, 160, 195)

    function t32.value22()
        if not t32.value14 then
            return
        end

        local n9 = 60
        local n10 = 0
        local n11 = 0
        local timestamp = tick()
        local n12 = 0

        t2.value2.RenderStepped:Connect(function()
            n11 += 1

            if tick() - timestamp >= 1 then
                n9 = n11
                tick()
            end

            local Network = t32.value1:FindFirstChild("Network")

            if Network and Network:FindFirstChild("ServerStatsItem") then
                local v1633 = Network.ServerStatsItem:FindFirstChild("Data Ping")

                if v1633 then
                    local _math = math
                    local GetValue = v1633.GetValue

                    n10 = _math.floor(GetValue(v1633))
                end
            end

            if t32.value14 and t32.value14.Parent then
                t32.value14.Text = n10 .. "ms  " .. n9 .. "fps"
            end

            if t32.value13 and t32.value13.Parent then
                local str = tostring(t2.value30.ProgressStatus or "SEARCHING")

                t32.value13.Text = str:upper()
            end

            if t32.value16 and t32.value16.Parent then
                n12 = (n12 + 0.08) % 6.283185307179586

                local v1637 = (t2.value30.Progress or 0) > 0
                local v1638 = (math.sin(n12) + 1) / 2

                if v1637 then
                    t32.value16.BackgroundColor3 = Color3.fromRGB(46, 204, 113):Lerp(Color3.fromRGB(140, 255, 190), v1638)

                    return
                end

                t32.value16.BackgroundColor3 = Color3.fromRGB(0, 220, 255):Lerp(Color3.fromRGB(168, 85, 247), v1638)
            end
        end)
    end
    function t32.value23()
        pcall(function()
            local v1639 = t2.value6:FindFirstChild("PlayerGui") and t2.value6.PlayerGui:FindFirstChild("HyperionHubStealBar")

            if v1639 then
                v1639:Destroy()
            end

            local HyperionHubStealBar = game:GetService("CoreGui"):FindFirstChild("HyperionHubStealBar")

            if HyperionHubStealBar then
                HyperionHubStealBar:Destroy()
            end
        end)
        t2.value30.ProgressFill = nil
        t2.value30.ProgressText = nil
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "HyperionHubStealBar"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.DisplayOrder = 9
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.Enabled = _G.HyperionStealBarEnabled
        ScreenGui.Parent = t2.value6:FindFirstChild("PlayerGui") or t2.value6:WaitForChild("PlayerGui")
        _G.HyperionStealBarGui = ScreenGui
        local Frame = Instance.new("Frame")
        Frame.Name = "StealBarContainer"
        Frame.Size = UDim2.new(0, 275, 0, 66)
        Frame.Position = UDim2.new(0.5, -137, 1, -106)
        Frame.BackgroundColor3 = t32.value18
        Frame.BackgroundTransparency = 0.12
        Frame.BorderSizePixel = 0
        Frame.ClipsDescendants = true
        Frame.Parent = ScreenGui
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 13)
        local ImageLabel = Instance.new("ImageLabel", Frame)
        ImageLabel.Name = "StealBgImage"
        ImageLabel.Size = UDim2.new(1, 0, 1, 0)
        ImageLabel.Image = t2.value25
        ImageLabel.ImageTransparency = 0.32
        ImageLabel.ScaleType = Enum.ScaleType.Crop
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.ZIndex = 1
        Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 13)
        local UIStroke = Instance.new("UIStroke", Frame)
        UIStroke.Thickness = 1.4
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local UIGradient = Instance.new("UIGradient", UIStroke)
        UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 230, 255)),
			ColorSequenceKeypoint.new(0.66, Color3.fromRGB(247, 37, 133)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 85, 247))
		})
        table.insert(t2.value34, UIGradient)
        local Frame16 = Instance.new("Frame", Frame)
        Frame16.Name = "Sheen"
        Frame16.Size = UDim2.new(1, 0, 0, 22)
        Frame16.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Frame16.BorderSizePixel = 0
        Frame16.ZIndex = 2
        Instance.new("UICorner", Frame16).CornerRadius = UDim.new(0, 13)
        local UIGradient4 = Instance.new("UIGradient", Frame16)
        UIGradient4.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        UIGradient4.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.94),
			NumberSequenceKeypoint.new(0.5, 0.97),
			NumberSequenceKeypoint.new(1, 1)
		})
        UIGradient4.Rotation = 90
        t32.value16 = Instance.new("Frame", Frame)
        t32.value16.Name = "StatusBeacon"
        t32.value16.Size = UDim2.new(0, 7, 0, 7)
        t32.value16.Position = UDim2.new(0, 12, 0, 12)
        t32.value16.BackgroundColor3 = Color3.fromRGB(0, 230, 255)
        t32.value16.BorderSizePixel = 0
        t32.value16.ZIndex = 3
        Instance.new("UICorner", t32.value16).CornerRadius = UDim.new(1, 0)
        local TextLabel = Instance.new("TextLabel", Frame)
        TextLabel.Name = "Title"
        TextLabel.Size = UDim2.new(0, 90, 0, 16)
        TextLabel.Position = UDim2.new(0, 24, 0, 8)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Font = Enum.Font.GothamBlack
        TextLabel.Text = "AUTO STEAL"
        TextLabel.TextSize = 11.5
        TextLabel.TextColor3 = t32.value20
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.ZIndex = 3
        local Frame17 = Instance.new("Frame", Frame)
        Frame17.Name = "TelemetryBadge"
        Frame17.Size = UDim2.new(0, 136, 0, 18)
        Frame17.Position = UDim2.new(1, -148, 0, 7)
        Frame17.BackgroundColor3 = Color3.fromRGB(17, 14, 30)
        Frame17.BackgroundTransparency = 0.3
        Frame17.BorderSizePixel = 0
        Frame17.ZIndex = 3
        Instance.new("UICorner", Frame17).CornerRadius = UDim.new(0, 6)
        local UIStroke20 = Instance.new("UIStroke", Frame17)
        UIStroke20.Thickness = 1
        UIStroke20.Color = Color3.fromRGB(55, 45, 85)
        t32.value14 = Instance.new("TextLabel", Frame17)
        t32.value14.Size = UDim2.new(0.64, 0, 1, 0)
        t32.value14.Position = UDim2.new(0, 0, 0, 0)
        t32.value14.BackgroundTransparency = 1
        t32.value14.Font = Enum.Font.GothamBold
        t32.value14.TextSize = 9.5
        t32.value14.TextColor3 = Color3.fromRGB(190, 185, 220)
        t32.value14.Text = "0ms  60fps"
        t32.value14.ZIndex = 4
        t32.value15 = Instance.new("TextLabel", Frame17)
        t32.value15.Size = UDim2.new(0.36, 0, 1, 0)
        t32.value15.Position = UDim2.new(0.64, 0, 0, 0)
        t32.value15.BackgroundTransparency = 1
        t32.value15.Font = Enum.Font.GothamBold
        t32.value15.TextSize = 9.5
        t32.value15.TextColor3 = Color3.fromRGB(0, 230, 255)
        t32.value15.Text = "R:" .. tostring(t2.value30.Radius or 12)
        t32.value15.ZIndex = 4
        t32.value17 = Instance.new("Frame", Frame)
        t32.value17.Name = "ProgressBarTrack"
        t32.value17.Size = UDim2.new(1, -24, 0, 8)
        t32.value17.Position = UDim2.new(0, 12, 0, 31)
        t32.value17.BackgroundColor3 = t32.value19
        t32.value17.BorderSizePixel = 0
        t32.value17.ZIndex = 3
        Instance.new("UICorner", t32.value17).CornerRadius = UDim.new(1, 0)
        local UIStroke21 = Instance.new("UIStroke", t32.value17)
        UIStroke21.Thickness = 1
        UIStroke21.Color = Color3.fromRGB(45, 38, 70)
        t32.value11 = Instance.new("Frame", t32.value17)
        t32.value11.Name = "Fill"
        t32.value11.Size = UDim2.new(0, 0, 1, 0)
        t32.value11.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        t32.value11.BorderSizePixel = 0
        t32.value11.ZIndex = 4
        Instance.new("UICorner", t32.value11).CornerRadius = UDim.new(1, 0)
        Instance.new("UIGradient", t32.value11).Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 230, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(168, 85, 247)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(247, 37, 133))
		})
        t32.value13 = Instance.new("TextLabel", Frame)
        t32.value13.Name = "StatusText"
        t32.value13.Size = UDim2.new(0.65, 0, 0, 16)
        t32.value13.Position = UDim2.new(0, 14, 0, 44)
        t32.value13.BackgroundTransparency = 1
        t32.value13.Font = Enum.Font.GothamMedium
        t32.value13.TextSize = 10
        t32.value13.TextColor3 = t32.value21
        t32.value13.TextXAlignment = Enum.TextXAlignment.Left
        t32.value13.Text = "SEARCHING"
        t32.value13.ZIndex = 3
        t32.value12 = Instance.new("TextLabel", Frame)
        t32.value12.Name = "PercentText"
        t32.value12.Size = UDim2.new(0.35, 0, 0, 16)
        t32.value12.Position = UDim2.new(0.65, -14, 0, 44)
        t32.value12.BackgroundTransparency = 1
        t32.value12.Font = Enum.Font.GothamBlack
        t32.value12.TextSize = 12
        t32.value12.TextColor3 = t32.value20
        t32.value12.TextXAlignment = Enum.TextXAlignment.Right
        t32.value12.Text = "0%"
        t32.value12.ZIndex = 3
        t32.value22()
        local u1491
        t2.value8(function()
            u1491 = readfile("HyperionStealBarPos.txt")
        end)
        if u1491 and u1491 ~= "" then
            local t34 = {}

            for match in string.gmatch(u1491, "[^,]+") do
                table.insert(t34, match)
            end

            if #t34 >= 4 then
                t2.value8(function()
                    Frame.Position = UDim2.new(tonumber(t34[1]), tonumber(t34[2]), tonumber(t34[3]), (tonumber(t34[4])))
                end)
            end
        end;
        (function(p212)
            local u1642 = false
            local inputPosition
            local p212Position
            local function v1645()
                if not u1642 then
                    return
                end
                local p212Position2 = p212.Position
                local u1654 = p212Position2
                t2.value8(function()
                    writefile("HyperionStealBarPos.txt", string.format("%.4f,%.1f,%.4f,%.1f", u1654.X.Scale, u1654.X.Offset, u1654.Y.Scale, u1654.Y.Offset))
                end)
                u1642 = false
            end
            p212.InputBegan:Connect(function(input)
                if t2.value31.Locked then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    u1642 = true
                    inputPosition = input.Position
                    p212Position = p212.Position
                end
            end)
            p212.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    v1645()
                end
            end)
            t2.value4.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    v1645()
                end
            end)
            t2.value4.InputChanged:Connect(function(input)
                if not u1642 then
                    return
                end

                if t2.value31.Locked then
                    v1645()

                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local v1659 = input.Position - inputPosition

                    p212.Position = UDim2.new(p212Position.X.Scale, p212Position.X.Offset + v1659.X, p212Position.Y.Scale, p212Position.Y.Offset + v1659.Y)
                end
            end)
        end)(Frame)
        t2.value30.ProgressFill = t32.value11
        t2.value30.ProgressText = t32.value12
        local v1494 = math.clamp(tonumber(t2.value30.Progress) or 0, 0, 1)
        t32.value11.Size = UDim2.new(v1494, 0, 1, 0)
        t32.value12.Text = tostring((math.floor(v1494 * 100 + 0.5))) .. "%"
    end

    task.spawn(function()
        task.wait(1.2)
        pcall(t32.value23)
    end)
    _G.HyperionSpeedESPEnabled = false
    task.spawn(function()
        t2.value2.Stepped:Connect(function()
            if not _G.HyperionSpeedESPEnabled then
                return
            end

            for _, player in pairs(t2.value1:GetPlayers()) do
                if player ~= t2.value6 and player.Character then
                    local Head = player.Character:FindFirstChild("Head")
                    local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

                    if Head and HumanoidRootPart then
                        local SpeedESP = Head:FindFirstChild("SpeedESP")

                        if not SpeedESP then
                            SpeedESP = Instance.new("BillboardGui")
                            SpeedESP.Name = "SpeedESP"
                            SpeedESP.Adornee = Head
                            SpeedESP.Size = UDim2.new(0, 150, 0, 30)
                            SpeedESP.StudsOffset = Vector3.new(0, 2.5, 0)
                            SpeedESP.AlwaysOnTop = true
                            SpeedESP.Parent = Head

                            local TextLabel = Instance.new("TextLabel")

                            TextLabel.Size = UDim2.new(1, 0, 1, 0)
                            TextLabel.BackgroundTransparency = 1
                            TextLabel.TextColor3 = Color3.new(1, 1, 1)
                            TextLabel.TextStrokeTransparency = 0
                            TextLabel.TextScaled = true
                            TextLabel.Font = Enum.Font.SourceSansBold
                            TextLabel.Parent = SpeedESP
                        end

                        local v1652 = math.floor(HumanoidRootPart.Velocity.Magnitude)

                        if v1652 > 700 then
                            SpeedESP.TextLabel.Text = "anti bat detected switch to aimbot v2"
                            SpeedESP.TextLabel.TextColor3 = Color3.new(1, 0, 0)
                        else
                            SpeedESP.TextLabel.Text = v1652 .. ""
                            SpeedESP.TextLabel.TextColor3 = Color3.new(1, 1, 1)
                        end
                    end
                end
            end
        end)
    end)
    task.spawn(function()
        task.wait(0.15)

        if t2.value29.autoBatToggled and t2.value48 then
            t2.value48()
        end

        if t2.value29.mirrorTPDownEnabled and _G.HyperionSetMirrorTPDown then
            _G.HyperionSetMirrorTPDown(true)
        end

        if t2.value29.animEnabled and (saveOriginalAnims and t2.value6.Character) then
            saveOriginalAnims(t2.value6.Character)
            applyAnimPack(t2.value6.Character)
        end

        if _G.HyperionSetStealBarVisible then
            _G.HyperionSetStealBarVisible(t2.value29.stealBarEnabled ~= false)
        end

        if t2.value29.speedESPEnabled then
            _G.HyperionSpeedESPEnabled = true
        end
    end)
end)()
function t2.value216(p213)
    if not p213 then
        return
    end

    local Head = p213:WaitForChild("Head", 8)
    local v1029 = not Head
    local HumanoidRootPart = p213:WaitForChild("HumanoidRootPart", 8)

    if not v1029 then
        v1029 = not HumanoidRootPart
    end

    if v1029 then
        return
    end

    local HyperionSpeedCounter = Head:FindFirstChild("HyperionSpeedCounter")

    if HyperionSpeedCounter then
        HyperionSpeedCounter:Destroy()
    end

    local SpeedBillboard = Head:FindFirstChild("SpeedBillboard")

    if SpeedBillboard then
        SpeedBillboard:Destroy()
    end

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "HyperionSpeedCounter"
    BillboardGui.Adornee = Head
    BillboardGui.Size = UDim2.new(0, 180, 0, 28)
    BillboardGui.StudsOffset = Vector3.new(0, 3.25, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.MaxDistance = 150
    BillboardGui.ResetOnSpawn = false
    BillboardGui.Parent = Head

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Speed"
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "SPEED 0.0"
    TextLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextStrokeTransparency = 0.2
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 14
    TextLabel.Parent = BillboardGui
    speedLbl = TextLabel
    _G.HyperionSpeedCounterLabel = TextLabel
end
_G.HyperionAttachSpeedCounter = t2.value216
t2.value6.CharacterAdded:Connect(function(character)
    task.spawn(function()
        t2.value216(character)
    end)
end)
if t2.value6.Character then
    task.spawn(function()
        t2.value216(t2.value6.Character)
    end)
end
task.spawn(function()
    task.wait(0.1)

    if t2.value29.introEnabled ~= false then
        t2.value181()
    end
end)

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()