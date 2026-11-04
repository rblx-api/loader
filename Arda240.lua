-- Arda240 | Dark Silver UI
-- Visual-only Roblox UI mockup.
-- The switch is cosmetic: this script does not fire RemoteEvents,
-- send network traffic, or interfere with other players/servers.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local C = {
    black = Color3.fromRGB(5, 5, 7),
    dark = Color3.fromRGB(12, 12, 15),
    panel = Color3.fromRGB(17, 17, 21),
    panelLight = Color3.fromRGB(28, 28, 34),
    silver = Color3.fromRGB(190, 190, 202),
    white = Color3.fromRGB(245, 245, 250),
    muted = Color3.fromRGB(130, 130, 143),
    line = Color3.fromRGB(80, 80, 94),
}

local gui = Instance.new("ScreenGui")
gui.Name = "Arda240"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(470, 290)
main.Position = UDim2.new(0.5, -235, 0.5, -145)
main.BackgroundColor3 = C.black
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C.silver
mainStroke.Thickness = 1.4
mainStroke.Transparency = 0.2
mainStroke.Parent = main

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 27, 34)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(5, 5, 8)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 29)),
})
bgGradient.Rotation = 135
bgGradient.Parent = main

-- Decorative moon and night-sky accents.
local moon = Instance.new("TextLabel")
moon.Name = "Moon"
moon.Size = UDim2.fromOffset(125, 125)
moon.Position = UDim2.new(1, -145, 0, 45)
moon.BackgroundTransparency = 1
moon.Font = Enum.Font.Gotham
moon.Text = "◕"
moon.TextColor3 = Color3.fromRGB(205, 205, 216)
moon.TextTransparency = 0.12
moon.TextSize = 105
moon.ZIndex = 1
moon.Parent = main

local moonGlow = Instance.new("UIStroke")
moonGlow.Color = C.silver
moonGlow.Thickness = 1
moonGlow.Transparency = 0.65
moonGlow.Parent = moon

local crown = Instance.new("TextLabel")
crown.Size = UDim2.fromOffset(52, 42)
crown.Position = UDim2.fromOffset(19, 12)
crown.BackgroundTransparency = 1
crown.Font = Enum.Font.GothamBlack
crown.Text = "♛"
crown.TextColor3 = C.white
crown.TextSize = 37
crown.ZIndex = 3
crown.Parent = main

local brand = Instance.new("TextLabel")
brand.Size = UDim2.new(1, -115, 0, 58)
brand.Position = UDim2.fromOffset(68, 7)
brand.BackgroundTransparency = 1
brand.Font = Enum.Font.GothamBlack
brand.Text = "Arda240"
brand.TextColor3 = C.white
brand.TextSize = 34
brand.TextXAlignment = Enum.TextXAlignment.Left
brand.ZIndex = 3
brand.Parent = main

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(34, 30)
minimize.Position = UDim2.new(1, -82, 0, 14)
minimize.BackgroundColor3 = C.panel
minimize.BackgroundTransparency = 0.1
minimize.BorderSizePixel = 0
minimize.Font = Enum.Font.GothamBold
minimize.Text = "—"
minimize.TextColor3 = C.white
minimize.TextSize = 18
minimize.ZIndex = 5
minimize.Parent = main
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 8)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 30)
close.Position = UDim2.new(1, -42, 0, 14)
close.BackgroundColor3 = C.panel
close.BackgroundTransparency = 0.1
close.BorderSizePixel = 0
close.Font = Enum.Font.GothamBold
close.Text = "×"
close.TextColor3 = C.white
close.TextSize = 22
close.ZIndex = 5
close.Parent = main
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, -28, 0, 1)
topLine.Position = UDim2.fromOffset(14, 66)
topLine.BackgroundColor3 = C.line
topLine.BackgroundTransparency = 0.25
topLine.BorderSizePixel = 0
topLine.ZIndex = 3
topLine.Parent = main

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -28, 1, -82)
content.Position = UDim2.fromOffset(14, 76)
content.BackgroundColor3 = C.dark
content.BackgroundTransparency = 0.12
content.BorderSizePixel = 0
content.ZIndex = 2
content.Parent = main
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 14)

local contentStroke = Instance.new("UIStroke")
contentStroke.Color = C.line
contentStroke.Transparency = 0.35
contentStroke.Thickness = 1
contentStroke.Parent = content

local bolt = Instance.new("TextLabel")
bolt.Size = UDim2.fromOffset(44, 45)
bolt.Position = UDim2.fromOffset(16, 12)
bolt.BackgroundTransparency = 1
bolt.Font = Enum.Font.GothamBlack
bolt.Text = "ϟ"
bolt.TextColor3 = C.white
bolt.TextSize = 42
bolt.ZIndex = 4
bolt.Parent = content

local heading = Instance.new("TextLabel")
heading.Size = UDim2.new(1, -80, 0, 34)
heading.Position = UDim2.fromOffset(66, 12)
heading.BackgroundTransparency = 1
heading.Font = Enum.Font.GothamBold
heading.Text = "Packet Lagger"
heading.TextColor3 = C.white
heading.TextSize = 21
heading.TextXAlignment = Enum.TextXAlignment.Left
heading.ZIndex = 4
heading.Parent = content

local subheading = Instance.new("TextLabel")
subheading.Size = UDim2.new(1, -80, 0, 22)
subheading.Position = UDim2.fromOffset(67, 43)
subheading.BackgroundTransparency = 1
subheading.Font = Enum.Font.Gotham
subheading.Text = "Arda240  •  Dark Edition"
subheading.TextColor3 = C.muted
subheading.TextSize = 12
subheading.TextXAlignment = Enum.TextXAlignment.Left
subheading.ZIndex = 4
subheading.Parent = content

local toggle = Instance.new("TextButton")
toggle.Name = "VisualToggle"
toggle.Size = UDim2.fromOffset(145, 58)
toggle.Position = UDim2.fromOffset(18, 87)
toggle.BackgroundColor3 = C.panel
toggle.BorderSizePixel = 0
toggle.AutoButtonColor = false
toggle.Font = Enum.Font.GothamBlack
toggle.Text = "●   OFF"
toggle.TextColor3 = C.white
toggle.TextSize = 20
toggle.ZIndex = 4
toggle.Parent = content
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 29)

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = C.line
toggleStroke.Thickness = 1.5
toggleStroke.Parent = toggle

local divider = Instance.new("Frame")
divider.Size = UDim2.fromOffset(1, 66)
divider.Position = UDim2.fromOffset(180, 84)
divider.BackgroundColor3 = C.silver
divider.BackgroundTransparency = 0.35
divider.BorderSizePixel = 0
divider.ZIndex = 4
divider.Parent = content

local status = Instance.new("TextLabel")
status.Size = UDim2.fromOffset(215, 28)
status.Position = UDim2.fromOffset(198, 88)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.Text = "〰  Status: Inactive"
status.TextColor3 = C.silver
status.TextSize = 15
status.TextXAlignment = Enum.TextXAlignment.Left
status.ZIndex = 4
status.Parent = content

local intensity = Instance.new("TextLabel")
intensity.Size = UDim2.fromOffset(215, 28)
intensity.Position = UDim2.fromOffset(198, 120)
intensity.BackgroundTransparency = 1
intensity.Font = Enum.Font.Gotham
intensity.Text = "▮  UI Preview"
intensity.TextColor3 = C.white
intensity.TextSize = 15
intensity.TextXAlignment = Enum.TextXAlignment.Left
intensity.ZIndex = 4
intensity.Parent = content

local keyRow = Instance.new("Frame")
keyRow.Size = UDim2.new(1, -36, 0, 43)
keyRow.Position = UDim2.fromOffset(18, 164)
keyRow.BackgroundColor3 = C.panel
keyRow.BorderSizePixel = 0
keyRow.ZIndex = 4
keyRow.Parent = content
Instance.new("UICorner", keyRow).CornerRadius = UDim.new(0, 9)

local keyStroke = Instance.new("UIStroke")
keyStroke.Color = C.line
keyStroke.Transparency = 0.25
keyStroke.Parent = keyRow

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -100, 1, 0)
keyLabel.Position = UDim2.fromOffset(13, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Font = Enum.Font.GothamBold
keyLabel.Text = "⌨   Keybind"
keyLabel.TextColor3 = C.silver
keyLabel.TextSize = 15
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.ZIndex = 5
keyLabel.Parent = keyRow

local keyValue = Instance.new("TextLabel")
keyValue.Size = UDim2.fromOffset(65, 31)
keyValue.Position = UDim2.new(1, -78, 0.5, -15)
keyValue.BackgroundColor3 = C.dark
keyValue.BorderSizePixel = 0
keyValue.Font = Enum.Font.GothamBold
keyValue.Text = "G"
keyValue.TextColor3 = C.white
keyValue.TextSize = 16
keyValue.ZIndex = 5
keyValue.Parent = keyRow
Instance.new("UICorner", keyValue).CornerRadius = UDim.new(0, 7)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -30, 0, 17)
footer.Position = UDim2.new(0, 15, 1, -20)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Gotham
footer.Text = "♛   Arda240"
footer.TextColor3 = C.muted
footer.TextSize = 11
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.ZIndex = 4
footer.Parent = content

local active = false
local minimized = false

local function setActive(value)
    active = value
    toggle.Text = active and "●   ON" or "●   OFF"
    toggle.TextColor3 = active and C.silver or C.white
    toggle.BackgroundColor3 = active and Color3.fromRGB(43, 43, 51) or C.panel
    toggleStroke.Color = active and C.white or C.line
    status.Text = active and "〰  Status: Preview ON" or "〰  Status: Inactive"
end

toggle.MouseButton1Click:Connect(function()
    setActive(not active)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.G then
        setActive(not active)
    end
end)

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    topLine.Visible = not minimized
    main:TweenSize(
        minimized and UDim2.fromOffset(470, 68) or UDim2.fromOffset(470, 290),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.2,
        true
    )
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Drag panel with mouse or touch using the header area.
local dragging = false
local dragInput
local dragStart
local startPosition

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        local p = input.Position
        if p.Y <= main.AbsolutePosition.Y + 68 then
            dragging = true
            dragStart = p
            startPosition = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
end)

main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)