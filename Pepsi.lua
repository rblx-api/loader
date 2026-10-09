local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local pg = LP:WaitForChild("PlayerGui")

local function parentGui(gui)
	local function tryParent(target)
		pcall(function() gui.Parent = target end)
		return gui.Parent ~= nil
	end
	if tryParent(pg) then return true end
	pcall(function()
		if typeof(gethui) == "function" then
			local h = gethui()
			if h and tryParent(h) then return true end
		end
	end)
	if tryParent(game:GetService("CoreGui")) then return true end
	return false
end

local store = {}

store["KrixHubGUI"] = Instance.new("ScreenGui")
store.KrixHubGUI.Name = "KrixHubGUI"
store.KrixHubGUI.ResetOnSpawn = false
store.KrixHubGUI.DisplayOrder = 1000000
store.KrixHubGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
store.KrixHubGUI.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

store["Outer"] = Instance.new("Frame")
store.Outer.Name = "Outer"
store.Outer.Active = true
store.Outer.Position = UDim2.new(0,7,0,-53)
store.Outer.Size = UDim2.new(0,330,0,470)
store.Outer.BackgroundTransparency = 1
store.Outer.BorderSizePixel = 0
store.Outer.Parent = store.KrixHubGUI

store["Inner"] = Instance.new("Frame")
store.Inner.Name = "Inner"
store.Inner.ClipsDescendants = true
store.Inner.AnchorPoint = Vector2.new(0.5,0.5)
store.Inner.Position = UDim2.new(0.5,0,0.5,0)
store.Inner.Size = UDim2.new(1,0,1,0)
store.Inner.BackgroundColor3 = Color3.fromRGB(8,8,8)
store.Inner.BackgroundTransparency = 1
store.Inner.BorderSizePixel = 0
store.Inner.Parent = store.Outer

store["UICorner"] = Instance.new("UICorner")
store.UICorner.Name = "UICorner"
store.UICorner.CornerRadius = UDim.new(0,24)
store.UICorner.Parent = store.Inner

store["PanelPop"] = Instance.new("UIScale")
store.PanelPop.Name = "PanelPop"
store.PanelPop.Parent = store.Inner

store["BgGradient"] = Instance.new("Frame")
store.BgGradient.Name = "BgGradient"
store.BgGradient.ZIndex = 0
store.BgGradient.Size = UDim2.new(1,0,1,0)
store.BgGradient.BackgroundColor3 = Color3.fromRGB(15,10,18)
store.BgGradient.BorderSizePixel = 0
store.BgGradient.Parent = store.Inner

store["UICorner2"] = Instance.new("UICorner")
store.UICorner2.Name = "UICorner"
store.UICorner2.CornerRadius = UDim.new(0,24)
store.UICorner2.Parent = store.BgGradient

store["UIGradient"] = Instance.new("UIGradient")
store.UIGradient.Name = "UIGradient"
store.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(26,26,26)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(12,12,12)),ColorSequenceKeypoint.new(1,Color3.fromRGB(22,22,22))})
store.UIGradient.Rotation = 135
store.UIGradient.Parent = store.BgGradient

store["BackgroundImage"] = Instance.new("ImageLabel")
store.BackgroundImage.Name = "BackgroundImage"
store.BackgroundImage.Visible = true
store.BackgroundImage.ZIndex = 2
store.BackgroundImage.Size = UDim2.new(1,0,1,0)
store.BackgroundImage.BackgroundColor3 = Color3.fromRGB(15,10,18)
store.BackgroundImage.BackgroundTransparency = 1
store.BackgroundImage.Image = "rbxassetid://123325812442364"
store.BackgroundImage.ScaleType = Enum.ScaleType.Fit
store.BackgroundImage.Parent = store.Inner

store["UICorner3"] = Instance.new("UICorner")
store.UICorner3.Name = "UICorner"
store.UICorner3.CornerRadius = UDim.new(0,24)
store.UICorner3.Parent = store.BackgroundImage

store["Frame"] = Instance.new("Frame")
store.Frame.Name = "Frame"
store.Frame.ZIndex = 5
store.Frame.Size = UDim2.new(1,0,0,64)
store.Frame.BackgroundTransparency = 1
store.Frame.BorderSizePixel = 0
store.Frame.Parent = store.Inner

store["TextButton"] = Instance.new("TextButton")
store.TextButton.Name = "TextButton"
store.TextButton.ZIndex = 6
store.TextButton.Position = UDim2.new(1,-40,0,7)
store.TextButton.Size = UDim2.new(0,30,0,22)
store.TextButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
store.TextButton.BackgroundTransparency = 0.5
store.TextButton.BorderSizePixel = 0
store.TextButton.Text = "-"
store.TextButton.TextColor3 = Color3.fromRGB(255,255,255)
store.TextButton.TextSize = 14
store.TextButton.Font = Enum.Font.GothamBold
store.TextButton.Parent = store.Frame

store["UICorner4"] = Instance.new("UICorner")
store.UICorner4.Name = "UICorner"
store.UICorner4.Parent = store.TextButton

store["Frame2"] = Instance.new("Frame")
store.Frame2.Name = "Frame"
store.Frame2.ZIndex = 6
store.Frame2.BackgroundTransparency = 1
store.Frame2.BorderSizePixel = 0
store.Frame2.Parent = store.Frame

store["HeaderSeparator"] = Instance.new("Frame")
store.HeaderSeparator.Name = "HeaderSeparator"
store.HeaderSeparator.ZIndex = 4
store.HeaderSeparator.Position = UDim2.new(0,14,0,64)
store.HeaderSeparator.Size = UDim2.new(1,-28,0,1)
store.HeaderSeparator.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.HeaderSeparator.BackgroundTransparency = 0.7
store.HeaderSeparator.BorderSizePixel = 0
store.HeaderSeparator.Parent = store.Inner

store["UIGradient2"] = Instance.new("UIGradient")
store.UIGradient2.Name = "UIGradient"
store.UIGradient2.Color = ColorSequence.new(Color3.fromRGB(254,254,254),Color3.fromRGB(254,254,254))
store.UIGradient2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.15,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(0.85,0.3,0),NumberSequenceKeypoint.new(1,1,0)})
store.UIGradient2.Parent = store.HeaderSeparator

store["BottomTabBar"] = Instance.new("ScrollingFrame")
store.BottomTabBar.Name = "BottomTabBar"
store.BottomTabBar.Visible = false
store.BottomTabBar.ZIndex = 4
store.BottomTabBar.Position = UDim2.new(0,8,1,2)
store.BottomTabBar.Size = UDim2.new(1,-16,0,-10)
store.BottomTabBar.BackgroundTransparency = 1
store.BottomTabBar.BorderSizePixel = 0
store.BottomTabBar.ScrollBarThickness = 0
store.BottomTabBar.ScrollingDirection = Enum.ScrollingDirection.X
store.BottomTabBar.CanvasSize = UDim2.new(0,0,0,0)
store.BottomTabBar.ElasticBehavior = Enum.ElasticBehavior.Never
store.BottomTabBar.Parent = store.Inner

store["UIListLayout"] = Instance.new("UIListLayout")
store.UIListLayout.Name = "UIListLayout"
store.UIListLayout.Padding = UDim.new(0,4)
store.UIListLayout.FillDirection = Enum.FillDirection.Horizontal
store.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
store.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout.Parent = store.BottomTabBar

store["UIPadding"] = Instance.new("UIPadding")
store.UIPadding.Name = "UIPadding"
store.UIPadding.PaddingTop = UDim.new(0,4)
store.UIPadding.PaddingBottom = UDim.new(0,4)
store.UIPadding.PaddingLeft = UDim.new(0,6)
store.UIPadding.PaddingRight = UDim.new(0,6)
store.UIPadding.Parent = store.BottomTabBar

-- Speed Tab
store["TextButton2"] = Instance.new("TextButton")
store.TextButton2.Name = "TextButton"
store.TextButton2.ZIndex = 6
store.TextButton2.LayoutOrder = 1
store.TextButton2.Size = UDim2.new(0,82,1,0)
store.TextButton2.BackgroundTransparency = 1
store.TextButton2.BorderSizePixel = 0
store.TextButton2.Text = ""
store.TextButton2.AutoButtonColor = false
store.TextButton2.Parent = store.BottomTabBar

store["Label"] = Instance.new("TextLabel")
store.Label.Name = "Label"
store.Label.ZIndex = 7
store.Label.Size = UDim2.new(1,0,1,0)
store.Label.BackgroundTransparency = 1
store.Label.Text = "Speed"
store.Label.TextColor3 = Color3.fromRGB(130,135,145)
store.Label.TextSize = 13
store.Label.Font = Enum.Font.GothamBold
store.Label.Parent = store.TextButton2

store["Underline"] = Instance.new("Frame")
store.Underline.Name = "Underline"
store.Underline.ZIndex = 8
store.Underline.Position = UDim2.new(0.5,-18,1,-2)
store.Underline.Size = UDim2.new(0,36,0,2)
store.Underline.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline.BackgroundTransparency = 1
store.Underline.BorderSizePixel = 0
store.Underline.Parent = store.TextButton2

-- Steal Tab
store["TextButton4"] = Instance.new("TextButton")
store.TextButton4.Name = "TextButton"
store.TextButton4.ZIndex = 6
store.TextButton4.LayoutOrder = 2
store.TextButton4.Size = UDim2.new(0,82,1,0)
store.TextButton4.BackgroundTransparency = 1
store.TextButton4.BorderSizePixel = 0
store.TextButton4.Text = ""
store.TextButton4.AutoButtonColor = false
store.TextButton4.Parent = store.BottomTabBar

store["Label2"] = Instance.new("TextLabel")
store.Label2.Name = "Label"
store.Label2.ZIndex = 7
store.Label2.Size = UDim2.new(1,0,1,0)
store.Label2.BackgroundTransparency = 1
store.Label2.Text = "Steal"
store.Label2.TextColor3 = Color3.fromRGB(130,135,145)
store.Label2.TextSize = 13
store.Label2.Font = Enum.Font.GothamBold
store.Label2.Parent = store.TextButton4

store["Underline2"] = Instance.new("Frame")
store.Underline2.Name = "Underline"
store.Underline2.ZIndex = 8
store.Underline2.Position = UDim2.new(0.5,-18,1,-2)
store.Underline2.Size = UDim2.new(0,36,0,2)
store.Underline2.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline2.BackgroundTransparency = 1
store.Underline2.BorderSizePixel = 0
store.Underline2.Parent = store.TextButton4

-- Movement Tab
store["TextButton5"] = Instance.new("TextButton")
store.TextButton5.Name = "TextButton"
store.TextButton5.ZIndex = 6
store.TextButton5.LayoutOrder = 3
store.TextButton5.Size = UDim2.new(0,82,1,0)
store.TextButton5.BackgroundTransparency = 1
store.TextButton5.BorderSizePixel = 0
store.TextButton5.Text = ""
store.TextButton5.AutoButtonColor = false
store.TextButton5.Parent = store.BottomTabBar

store["Label3"] = Instance.new("TextLabel")
store.Label3.Name = "Label"
store.Label3.ZIndex = 7
store.Label3.Size = UDim2.new(1,0,1,0)
store.Label3.BackgroundTransparency = 1
store.Label3.Text = "Movement"
store.Label3.TextColor3 = Color3.fromRGB(130,135,145)
store.Label3.TextSize = 13
store.Label3.Font = Enum.Font.GothamBold
store.Label3.Parent = store.TextButton5

store["Underline3"] = Instance.new("Frame")
store.Underline3.Name = "Underline"
store.Underline3.ZIndex = 8
store.Underline3.Position = UDim2.new(0.5,-18,1,-2)
store.Underline3.Size = UDim2.new(0,36,0,2)
store.Underline3.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline3.BackgroundTransparency = 1
store.Underline3.BorderSizePixel = 0
store.Underline3.Parent = store.TextButton5

-- Visual Tab
store["TextButton6"] = Instance.new("TextButton")
store.TextButton6.Name = "TextButton"
store.TextButton6.ZIndex = 6
store.TextButton6.LayoutOrder = 4
store.TextButton6.Size = UDim2.new(0,82,1,0)
store.TextButton6.BackgroundTransparency = 1
store.TextButton6.BorderSizePixel = 0
store.TextButton6.Text = ""
store.TextButton6.AutoButtonColor = false
store.TextButton6.Parent = store.BottomTabBar

store["Label4"] = Instance.new("TextLabel")
store.Label4.Name = "Label"
store.Label4.ZIndex = 7
store.Label4.Size = UDim2.new(1,0,1,0)
store.Label4.BackgroundTransparency = 1
store.Label4.Text = "Visual"
store.Label4.TextColor3 = Color3.fromRGB(130,135,145)
store.Label4.TextSize = 13
store.Label4.Font = Enum.Font.GothamBold
store.Label4.Parent = store.TextButton6

store["Underline4"] = Instance.new("Frame")
store.Underline4.Name = "Underline"
store.Underline4.ZIndex = 8
store.Underline4.Position = UDim2.new(0.5,-18,1,-2)
store.Underline4.Size = UDim2.new(0,36,0,2)
store.Underline4.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline4.BackgroundTransparency = 1
store.Underline4.BorderSizePixel = 0
store.Underline4.Parent = store.TextButton6

-- Auto Tab
store["TextButton7"] = Instance.new("TextButton")
store.TextButton7.Name = "TextButton"
store.TextButton7.ZIndex = 6
store.TextButton7.LayoutOrder = 5
store.TextButton7.Size = UDim2.new(0,82,1,0)
store.TextButton7.BackgroundTransparency = 1
store.TextButton7.BorderSizePixel = 0
store.TextButton7.Text = ""
store.TextButton7.AutoButtonColor = false
store.TextButton7.Parent = store.BottomTabBar

store["Label5"] = Instance.new("TextLabel")
store.Label5.Name = "Label"
store.Label5.ZIndex = 7
store.Label5.Size = UDim2.new(1,0,1,0)
store.Label5.BackgroundTransparency = 1
store.Label5.Text = "Auto"
store.Label5.TextColor3 = Color3.fromRGB(130,135,145)
store.Label5.TextSize = 13
store.Label5.Font = Enum.Font.GothamBold
store.Label5.Parent = store.TextButton7

store["Underline5"] = Instance.new("Frame")
store.Underline5.Name = "Underline"
store.Underline5.ZIndex = 8
store.Underline5.Position = UDim2.new(0.5,-18,1,-2)
store.Underline5.Size = UDim2.new(0,36,0,2)
store.Underline5.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline5.BackgroundTransparency = 1
store.Underline5.BorderSizePixel = 0
store.Underline5.Parent = store.TextButton7

-- Settings Tab
store["TextButton9"] = Instance.new("TextButton")
store.TextButton9.Name = "TextButton"
store.TextButton9.ZIndex = 6
store.TextButton9.LayoutOrder = 6
store.TextButton9.Size = UDim2.new(0,82,1,0)
store.TextButton9.BackgroundTransparency = 1
store.TextButton9.BorderSizePixel = 0
store.TextButton9.Text = ""
store.TextButton9.AutoButtonColor = false
store.TextButton9.Parent = store.BottomTabBar

store["Label6"] = Instance.new("TextLabel")
store.Label6.Name = "Label"
store.Label6.ZIndex = 7
store.Label6.Size = UDim2.new(1,0,1,0)
store.Label6.BackgroundTransparency = 1
store.Label6.Text = "Settings"
store.Label6.TextColor3 = Color3.fromRGB(130,135,145)
store.Label6.TextSize = 13
store.Label6.Font = Enum.Font.GothamBold
store.Label6.Parent = store.TextButton9

store["Underline6"] = Instance.new("Frame")
store.Underline6.Name = "Underline"
store.Underline6.ZIndex = 8
store.Underline6.Position = UDim2.new(0.5,-18,1,-2)
store.Underline6.Size = UDim2.new(0,36,0,2)
store.Underline6.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline6.BackgroundTransparency = 1
store.Underline6.BorderSizePixel = 0
store.Underline6.Parent = store.TextButton9

store["Frame3"] = Instance.new("Frame")
store.Frame3.Name = "Frame"
store.Frame3.Visible = false
store.Frame3.ZIndex = 3
store.Frame3.Position = UDim2.new(0,8,1,2)
store.Frame3.Size = UDim2.new(1,-16,0,2)
store.Frame3.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame3.BackgroundTransparency = 0.65
store.Frame3.BorderSizePixel = 0
store.Frame3.Parent = store.Inner

store["UIGradient3"] = Instance.new("UIGradient")
store.UIGradient3.Name = "UIGradient"
store.UIGradient3.Color = ColorSequence.new(Color3.fromRGB(254,254,254),Color3.fromRGB(254,254,254))
store.UIGradient3.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.15,0.2,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(0.85,0.2,0),NumberSequenceKeypoint.new(1,1,0)})
store.UIGradient3.Parent = store.Frame3

store["Frame4"] = Instance.new("Frame")
store.Frame4.Name = "Frame"
store.Frame4.Visible = false
store.Frame4.BackgroundTransparency = 1
store.Frame4.Parent = store.Inner

store["ScrollingFrame"] = Instance.new("ScrollingFrame")
store.ScrollingFrame.Name = "ScrollingFrame"
store.ScrollingFrame.ZIndex = 3
store.ScrollingFrame.Position = UDim2.new(0,0,0,64)
store.ScrollingFrame.Size = UDim2.new(1,0,1,-74)
store.ScrollingFrame.BackgroundTransparency = 1
store.ScrollingFrame.BorderSizePixel = 0
store.ScrollingFrame.ScrollBarThickness = 3
store.ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(254,254,254)
store.ScrollingFrame.ScrollBarImageTransparency = 0.4
store.ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
store.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
store.ScrollingFrame.Parent = store.Inner

store["UIListLayout2"] = Instance.new("UIListLayout")
store.UIListLayout2.Name = "UIListLayout"
store.UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
store.UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout2.Parent = store.ScrollingFrame

store["UIPadding2"] = Instance.new("UIPadding")
store.UIPadding2.Name = "UIPadding"
store.UIPadding2.PaddingTop = UDim.new(0,2)
store.UIPadding2.PaddingBottom = UDim.new(0,8)
store.UIPadding2.PaddingLeft = UDim.new(0,4)
store.UIPadding2.PaddingRight = UDim.new(0,4)
store.UIPadding2.Parent = store.ScrollingFrame

-- Pages
store["Page_Speed"] = Instance.new("Frame")
store.Page_Speed.Name = "Page_Speed"
store.Page_Speed.ZIndex = 3
store.Page_Speed.LayoutOrder = 1001
store.Page_Speed.Size = UDim2.new(1,0,0,0)
store.Page_Speed.BackgroundTransparency = 1
store.Page_Speed.BorderSizePixel = 0
store.Page_Speed.Parent = store.ScrollingFrame

store["UIListLayout3"] = Instance.new("UIListLayout")
store.UIListLayout3.Name = "UIListLayout"
store.UIListLayout3.Padding = UDim.new(0,10)
store.UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout3.Parent = store.Page_Speed

store["UIPadding3"] = Instance.new("UIPadding")
store.UIPadding3.Name = "UIPadding"
store.UIPadding3.PaddingTop = UDim.new(0,10)
store.UIPadding3.PaddingLeft = UDim.new(0,12)
store.UIPadding3.PaddingRight = UDim.new(0,12)
store.UIPadding3.Parent = store.Page_Speed

-- Speed Page Content
store["Frame5"] = Instance.new("Frame")
store.Frame5.Name = "Frame"
store.Frame5.LayoutOrder = 8
store.Frame5.Size = UDim2.new(1,0,0,24)
store.Frame5.BackgroundTransparency = 1
store.Frame5.BorderSizePixel = 0
store.Frame5.Parent = store.Page_Speed

store["TextLabel"] = Instance.new("TextLabel")
store.TextLabel.Name = "TextLabel"
store.TextLabel.ZIndex = 4
store.TextLabel.Position = UDim2.new(0,0,0,2)
store.TextLabel.Size = UDim2.new(1,0,0,16)
store.TextLabel.BackgroundTransparency = 1
store.TextLabel.Text = "SPEED CONFIGURATION"
store.TextLabel.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel.TextSize = 12
store.TextLabel.Font = Enum.Font.GothamBlack
store.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel.Parent = store.Frame5

store["Frame6"] = Instance.new("Frame")
store.Frame6.Name = "Frame"
store.Frame6.ZIndex = 3
store.Frame6.Position = UDim2.new(0,0,0,20)
store.Frame6.Size = UDim2.new(1,0,0,1)
store.Frame6.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame6.BackgroundTransparency = 0.85
store.Frame6.BorderSizePixel = 0
store.Frame6.Parent = store.Frame5

-- Speed Frame 7
store["Frame7"] = Instance.new("Frame")
store.Frame7.Name = "Frame"
store.Frame7.ZIndex = 4
store.Frame7.LayoutOrder = 12
store.Frame7.Size = UDim2.new(1,0,0,44)
store.Frame7.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame7.BackgroundTransparency = 0.5
store.Frame7.BorderSizePixel = 0
store.Frame7.Parent = store.Page_Speed

store["UICorner5"] = Instance.new("UICorner")
store.UICorner5.Name = "UICorner"
store.UICorner5.CornerRadius = UDim.new(0,12)
store.UICorner5.Parent = store.Frame7

store["UIStroke"] = Instance.new("UIStroke")
store.UIStroke.Name = "UIStroke"
store.UIStroke.Color = Color3.fromRGB(38,38,38)
store.UIStroke.Transparency = 0.5
store.UIStroke.Parent = store.Frame7

store["TextLabel2"] = Instance.new("TextLabel")
store.TextLabel2.Name = "TextLabel"
store.TextLabel2.ZIndex = 5
store.TextLabel2.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel2.Size = UDim2.new(0,110,0,18)
store.TextLabel2.BackgroundTransparency = 1
store.TextLabel2.Text = "Lagger Speed"
store.TextLabel2.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel2.TextSize = 12
store.TextLabel2.Font = Enum.Font.GothamBold
store.TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel2.Parent = store.Frame7

store["Frame8"] = Instance.new("Frame")
store.Frame8.Name = "Frame"
store.Frame8.Visible = false
store.Frame8.ZIndex = 5
store.Frame8.Position = UDim2.new(0,12,0.5,9)
store.Frame8.Size = UDim2.new(0,73,0,1)
store.Frame8.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame8.BackgroundTransparency = 0.5
store.Frame8.BorderSizePixel = 0
store.Frame8.Parent = store.Frame7

store["Frame9"] = Instance.new("Frame")
store.Frame9.Name = "Frame"
store.Frame9.ZIndex = 6
store.Frame9.Position = UDim2.new(1,-56,0.5,-13)
store.Frame9.Size = UDim2.new(0,44,0,26)
store.Frame9.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame9.BackgroundTransparency = 0.5
store.Frame9.BorderSizePixel = 0
store.Frame9.Parent = store.Frame7

store["UICorner6"] = Instance.new("UICorner")
store.UICorner6.Name = "UICorner"
store.UICorner6.Parent = store.Frame9

store["UIStroke2"] = Instance.new("UIStroke")
store.UIStroke2.Name = "UIStroke"
store.UIStroke2.Color = Color3.fromRGB(254,254,254)
store.UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke2.Transparency = 0.45
store.UIStroke2.Parent = store.Frame9

store["UIGradient4"] = Instance.new("UIGradient")
store.UIGradient4.Name = "UIGradient"
store.UIGradient4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient4.Parent = store.UIStroke2

store["TextBox"] = Instance.new("TextBox")
store.TextBox.Name = "TextBox"
store.TextBox.ZIndex = 7
store.TextBox.Size = UDim2.new(1,0,1,0)
store.TextBox.BackgroundTransparency = 1
store.TextBox.Text = "25"
store.TextBox.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox.TextSize = 10
store.TextBox.Font = Enum.Font.GothamBold
store.TextBox.ClearTextOnFocus = false
store.TextBox.Parent = store.Frame9

store["Frame10"] = Instance.new("Frame")
store.Frame10.Name = "Frame"
store.Frame10.ZIndex = 6
store.Frame10.Position = UDim2.new(1,-112,0.5,-13)
store.Frame10.Size = UDim2.new(0,44,0,26)
store.Frame10.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame10.BackgroundTransparency = 0.5
store.Frame10.BorderSizePixel = 0
store.Frame10.Parent = store.Frame7

store["UICorner7"] = Instance.new("UICorner")
store.UICorner7.Name = "UICorner"
store.UICorner7.Parent = store.Frame10

store["UIStroke3"] = Instance.new("UIStroke")
store.UIStroke3.Name = "UIStroke"
store.UIStroke3.Color = Color3.fromRGB(254,254,254)
store.UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke3.Transparency = 0.45
store.UIStroke3.Parent = store.Frame10

store["UIGradient5"] = Instance.new("UIGradient")
store.UIGradient5.Name = "UIGradient"
store.UIGradient5.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient5.Parent = store.UIStroke3

store["TextBox2"] = Instance.new("TextBox")
store.TextBox2.Name = "TextBox"
store.TextBox2.ZIndex = 7
store.TextBox2.Size = UDim2.new(1,0,1,0)
store.TextBox2.BackgroundTransparency = 1
store.TextBox2.Text = "50"
store.TextBox2.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox2.TextSize = 10
store.TextBox2.Font = Enum.Font.GothamBold
store.TextBox2.ClearTextOnFocus = false
store.TextBox2.Parent = store.Frame10

store["TextButton10"] = Instance.new("TextButton")
store.TextButton10.Name = "TextButton"
store.TextButton10.ZIndex = 4
store.TextButton10.Size = UDim2.new(1,0,1,0)
store.TextButton10.BackgroundTransparency = 1
store.TextButton10.Text = ""
store.TextButton10.AutoButtonColor = false
store.TextButton10.Parent = store.Frame7

store["Frame11"] = Instance.new("Frame")
store.Frame11.Name = "Frame"
store.Frame11.ZIndex = 8
store.Frame11.ClipsDescendants = true
store.Frame11.Position = UDim2.new(0,128,0.5,-11)
store.Frame11.Size = UDim2.new(0,46,0,22)
store.Frame11.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame11.BackgroundTransparency = 0.6
store.Frame11.BorderSizePixel = 0
store.Frame11.Parent = store.Frame7

store["UICorner8"] = Instance.new("UICorner")
store.UICorner8.Name = "UICorner"
store.UICorner8.Parent = store.Frame11

store["TextLabel3"] = Instance.new("TextLabel")
store.TextLabel3.Name = "TextLabel"
store.TextLabel3.ZIndex = 9
store.TextLabel3.Size = UDim2.new(1,0,1,0)
store.TextLabel3.BackgroundTransparency = 1
store.TextLabel3.Text = "None"
store.TextLabel3.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel3.TextSize = 12
store.TextLabel3.TextScaled = true
store.TextLabel3.Font = Enum.Font.GothamBold
store.TextLabel3.TextWrapped = true
store.TextLabel3.Parent = store.Frame11

store["UITextSizeConstraint"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint.Name = "UITextSizeConstraint"
store.UITextSizeConstraint.MinTextSize = 6
store.UITextSizeConstraint.MaxTextSize = 12
store.UITextSizeConstraint.Parent = store.TextLabel3

store["TextButton11"] = Instance.new("TextButton")
store.TextButton11.Name = "TextButton"
store.TextButton11.ZIndex = 10
store.TextButton11.Position = UDim2.new(0,-2,0,-2)
store.TextButton11.Size = UDim2.new(1,4,1,4)
store.TextButton11.BackgroundTransparency = 1
store.TextButton11.Text = ""
store.TextButton11.AutoButtonColor = false
store.TextButton11.Parent = store.Frame11

-- Frame12
store["Frame12"] = Instance.new("Frame")
store.Frame12.Name = "Frame"
store.Frame12.ZIndex = 4
store.Frame12.LayoutOrder = 14
store.Frame12.Size = UDim2.new(1,0,0,44)
store.Frame12.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame12.BackgroundTransparency = 0.5
store.Frame12.BorderSizePixel = 0
store.Frame12.Parent = store.Page_Speed

store["UICorner9"] = Instance.new("UICorner")
store.UICorner9.Name = "UICorner"
store.UICorner9.CornerRadius = UDim.new(0,12)
store.UICorner9.Parent = store.Frame12

store["UIStroke4"] = Instance.new("UIStroke")
store.UIStroke4.Name = "UIStroke"
store.UIStroke4.Color = Color3.fromRGB(38,38,38)
store.UIStroke4.Transparency = 0.5
store.UIStroke4.Parent = store.Frame12

store["TextLabel4"] = Instance.new("TextLabel")
store.TextLabel4.Name = "TextLabel"
store.TextLabel4.ZIndex = 5
store.TextLabel4.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel4.Size = UDim2.new(0,110,0,18)
store.TextLabel4.BackgroundTransparency = 1
store.TextLabel4.Text = "Custom Speed"
store.TextLabel4.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel4.TextSize = 12
store.TextLabel4.Font = Enum.Font.GothamBold
store.TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel4.Parent = store.Frame12

store["Frame13"] = Instance.new("Frame")
store.Frame13.Name = "Frame"
store.Frame13.Visible = false
store.Frame13.ZIndex = 5
store.Frame13.Position = UDim2.new(0,12,0.5,9)
store.Frame13.Size = UDim2.new(0,78,0,1)
store.Frame13.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame13.BackgroundTransparency = 0.5
store.Frame13.BorderSizePixel = 0
store.Frame13.Parent = store.Frame12

store["Frame14"] = Instance.new("Frame")
store.Frame14.Name = "Frame"
store.Frame14.ZIndex = 6
store.Frame14.Position = UDim2.new(1,-56,0.5,-13)
store.Frame14.Size = UDim2.new(0,44,0,26)
store.Frame14.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame14.BackgroundTransparency = 0.5
store.Frame14.BorderSizePixel = 0
store.Frame14.Parent = store.Frame12

store["UICorner10"] = Instance.new("UICorner")
store.UICorner10.Name = "UICorner"
store.UICorner10.Parent = store.Frame14

store["UIStroke5"] = Instance.new("UIStroke")
store.UIStroke5.Name = "UIStroke"
store.UIStroke5.Color = Color3.fromRGB(254,254,254)
store.UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke5.Transparency = 0.45
store.UIStroke5.Parent = store.Frame14

store["UIGradient6"] = Instance.new("UIGradient")
store.UIGradient6.Name = "UIGradient"
store.UIGradient6.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient6.Parent = store.UIStroke5

store["TextBox3"] = Instance.new("TextBox")
store.TextBox3.Name = "TextBox"
store.TextBox3.ZIndex = 7
store.TextBox3.Size = UDim2.new(1,0,1,0)
store.TextBox3.BackgroundTransparency = 1
store.TextBox3.Text = "33"
store.TextBox3.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox3.TextSize = 10
store.TextBox3.Font = Enum.Font.GothamBold
store.TextBox3.ClearTextOnFocus = false
store.TextBox3.Parent = store.Frame14

store["Frame15"] = Instance.new("Frame")
store.Frame15.Name = "Frame"
store.Frame15.ZIndex = 6
store.Frame15.Position = UDim2.new(1,-112,0.5,-13)
store.Frame15.Size = UDim2.new(0,44,0,26)
store.Frame15.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame15.BackgroundTransparency = 0.5
store.Frame15.BorderSizePixel = 0
store.Frame15.Parent = store.Frame12

store["UICorner11"] = Instance.new("UICorner")
store.UICorner11.Name = "UICorner"
store.UICorner11.Parent = store.Frame15

store["UIStroke6"] = Instance.new("UIStroke")
store.UIStroke6.Name = "UIStroke"
store.UIStroke6.Color = Color3.fromRGB(254,254,254)
store.UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke6.Transparency = 0.45
store.UIStroke6.Parent = store.Frame15

store["UIGradient7"] = Instance.new("UIGradient")
store.UIGradient7.Name = "UIGradient"
store.UIGradient7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient7.Parent = store.UIStroke6

store["TextBox4"] = Instance.new("TextBox")
store.TextBox4.Name = "TextBox"
store.TextBox4.ZIndex = 7
store.TextBox4.Size = UDim2.new(1,0,1,0)
store.TextBox4.BackgroundTransparency = 1
store.TextBox4.Text = "65"
store.TextBox4.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox4.TextSize = 10
store.TextBox4.Font = Enum.Font.GothamBold
store.TextBox4.ClearTextOnFocus = false
store.TextBox4.Parent = store.Frame15

store["TextButton12"] = Instance.new("TextButton")
store.TextButton12.Name = "TextButton"
store.TextButton12.ZIndex = 4
store.TextButton12.Size = UDim2.new(1,0,1,0)
store.TextButton12.BackgroundTransparency = 1
store.TextButton12.Text = ""
store.TextButton12.AutoButtonColor = false
store.TextButton12.Parent = store.Frame12

store["Frame16"] = Instance.new("Frame")
store.Frame16.Name = "Frame"
store.Frame16.ZIndex = 8
store.Frame16.ClipsDescendants = true
store.Frame16.Position = UDim2.new(0,128,0.5,-11)
store.Frame16.Size = UDim2.new(0,46,0,22)
store.Frame16.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame16.BackgroundTransparency = 0.6
store.Frame16.BorderSizePixel = 0
store.Frame16.Parent = store.Frame12

store["UICorner12"] = Instance.new("UICorner")
store.UICorner12.Name = "UICorner"
store.UICorner12.Parent = store.Frame16

store["TextLabel5"] = Instance.new("TextLabel")
store.TextLabel5.Name = "TextLabel"
store.TextLabel5.ZIndex = 9
store.TextLabel5.Size = UDim2.new(1,0,1,0)
store.TextLabel5.BackgroundTransparency = 1
store.TextLabel5.Text = "None"
store.TextLabel5.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel5.TextSize = 12
store.TextLabel5.TextScaled = true
store.TextLabel5.Font = Enum.Font.GothamBold
store.TextLabel5.TextWrapped = true
store.TextLabel5.Parent = store.Frame16

store["UITextSizeConstraint2"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint2.Name = "UITextSizeConstraint"
store.UITextSizeConstraint2.MinTextSize = 6
store.UITextSizeConstraint2.MaxTextSize = 12
store.UITextSizeConstraint2.Parent = store.TextLabel5

store["TextButton13"] = Instance.new("TextButton")
store.TextButton13.Name = "TextButton"
store.TextButton13.ZIndex = 10
store.TextButton13.Position = UDim2.new(0,-2,0,-2)
store.TextButton13.Size = UDim2.new(1,4,1,4)
store.TextButton13.BackgroundTransparency = 1
store.TextButton13.Text = ""
store.TextButton13.AutoButtonColor = false
store.TextButton13.Parent = store.Frame16

-- Frame17
store["Frame17"] = Instance.new("Frame")
store.Frame17.Name = "Frame"
store.Frame17.ZIndex = 4
store.Frame17.LayoutOrder = 10
store.Frame17.Size = UDim2.new(1,0,0,44)
store.Frame17.BackgroundColor3 = Color3.fromRGB(32,32,32)
store.Frame17.BackgroundTransparency = 0.5
store.Frame17.BorderSizePixel = 0
store.Frame17.Parent = store.Page_Speed

store["UICorner13"] = Instance.new("UICorner")
store.UICorner13.Name = "UICorner"
store.UICorner13.CornerRadius = UDim.new(0,12)
store.UICorner13.Parent = store.Frame17

store["UIStroke7"] = Instance.new("UIStroke")
store.UIStroke7.Name = "UIStroke"
store.UIStroke7.Color = Color3.fromRGB(254,254,254)
store.UIStroke7.Thickness = 1.4
store.UIStroke7.Transparency = 0.2
store.UIStroke7.Parent = store.Frame17

store["TextLabel6"] = Instance.new("TextLabel")
store.TextLabel6.Name = "TextLabel"
store.TextLabel6.ZIndex = 5
store.TextLabel6.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel6.Size = UDim2.new(0,110,0,18)
store.TextLabel6.BackgroundTransparency = 1
store.TextLabel6.Text = "Normal Speed"
store.TextLabel6.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel6.TextSize = 12
store.TextLabel6.Font = Enum.Font.GothamBold
store.TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel6.Parent = store.Frame17

store["Frame18"] = Instance.new("Frame")
store.Frame18.Name = "Frame"
store.Frame18.ZIndex = 5
store.Frame18.Position = UDim2.new(0,12,0.5,9)
store.Frame18.Size = UDim2.new(0,76,0,1)
store.Frame18.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame18.BackgroundTransparency = 0.5
store.Frame18.BorderSizePixel = 0
store.Frame18.Parent = store.Frame17

store["Frame19"] = Instance.new("Frame")
store.Frame19.Name = "Frame"
store.Frame19.ZIndex = 6
store.Frame19.Position = UDim2.new(1,-56,0.5,-13)
store.Frame19.Size = UDim2.new(0,44,0,26)
store.Frame19.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame19.BackgroundTransparency = 0.5
store.Frame19.BorderSizePixel = 0
store.Frame19.Parent = store.Frame17

store["UICorner14"] = Instance.new("UICorner")
store.UICorner14.Name = "UICorner"
store.UICorner14.Parent = store.Frame19

store["UIStroke8"] = Instance.new("UIStroke")
store.UIStroke8.Name = "UIStroke"
store.UIStroke8.Color = Color3.fromRGB(254,254,254)
store.UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke8.Transparency = 0.45
store.UIStroke8.Parent = store.Frame19

store["UIGradient8"] = Instance.new("UIGradient")
store.UIGradient8.Name = "UIGradient"
store.UIGradient8.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient8.Parent = store.UIStroke8

store["TextBox5"] = Instance.new("TextBox")
store.TextBox5.Name = "TextBox"
store.TextBox5.ZIndex = 7
store.TextBox5.Size = UDim2.new(1,0,1,0)
store.TextBox5.BackgroundTransparency = 1
store.TextBox5.Text = "29"
store.TextBox5.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox5.TextSize = 10
store.TextBox5.Font = Enum.Font.GothamBold
store.TextBox5.ClearTextOnFocus = false
store.TextBox5.Parent = store.Frame19

store["Frame20"] = Instance.new("Frame")
store.Frame20.Name = "Frame"
store.Frame20.ZIndex = 6
store.Frame20.Position = UDim2.new(1,-112,0.5,-13)
store.Frame20.Size = UDim2.new(0,44,0,26)
store.Frame20.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame20.BackgroundTransparency = 0.5
store.Frame20.BorderSizePixel = 0
store.Frame20.Parent = store.Frame17

store["UICorner15"] = Instance.new("UICorner")
store.UICorner15.Name = "UICorner"
store.UICorner15.Parent = store.Frame20

store["UIStroke9"] = Instance.new("UIStroke")
store.UIStroke9.Name = "UIStroke"
store.UIStroke9.Color = Color3.fromRGB(254,254,254)
store.UIStroke9.Thickness = 1.8
store.UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke9.Transparency = 0.05
store.UIStroke9.Parent = store.Frame20

store["UIGradient9"] = Instance.new("UIGradient")
store.UIGradient9.Name = "UIGradient"
store.UIGradient9.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient9.Parent = store.UIStroke9

store["TextBox6"] = Instance.new("TextBox")
store.TextBox6.Name = "TextBox"
store.TextBox6.ZIndex = 7
store.TextBox6.Size = UDim2.new(1,0,1,0)
store.TextBox6.BackgroundTransparency = 1
store.TextBox6.Text = "60"
store.TextBox6.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox6.TextSize = 10
store.TextBox6.Font = Enum.Font.GothamBold
store.TextBox6.ClearTextOnFocus = false
store.TextBox6.Parent = store.Frame20

store["TextButton14"] = Instance.new("TextButton")
store.TextButton14.Name = "TextButton"
store.TextButton14.ZIndex = 4
store.TextButton14.Size = UDim2.new(1,0,1,0)
store.TextButton14.BackgroundTransparency = 1
store.TextButton14.Text = ""
store.TextButton14.AutoButtonColor = false
store.TextButton14.Parent = store.Frame17

store["Frame21"] = Instance.new("Frame")
store.Frame21.Name = "Frame"
store.Frame21.ZIndex = 8
store.Frame21.ClipsDescendants = true
store.Frame21.Position = UDim2.new(0,128,0.5,-11)
store.Frame21.Size = UDim2.new(0,46,0,22)
store.Frame21.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame21.BackgroundTransparency = 0.6
store.Frame21.BorderSizePixel = 0
store.Frame21.Parent = store.Frame17

store["UICorner16"] = Instance.new("UICorner")
store.UICorner16.Name = "UICorner"
store.UICorner16.Parent = store.Frame21

store["TextLabel7"] = Instance.new("TextLabel")
store.TextLabel7.Name = "TextLabel"
store.TextLabel7.ZIndex = 9
store.TextLabel7.Size = UDim2.new(1,0,1,0)
store.TextLabel7.BackgroundTransparency = 1
store.TextLabel7.Text = "None"
store.TextLabel7.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel7.TextSize = 12
store.TextLabel7.TextScaled = true
store.TextLabel7.Font = Enum.Font.GothamBold
store.TextLabel7.TextWrapped = true
store.TextLabel7.Parent = store.Frame21

store["UITextSizeConstraint3"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint3.Name = "UITextSizeConstraint"
store.UITextSizeConstraint3.MinTextSize = 6
store.UITextSizeConstraint3.MaxTextSize = 12
store.UITextSizeConstraint3.Parent = store.TextLabel7

store["TextButton15"] = Instance.new("TextButton")
store.TextButton15.Name = "TextButton"
store.TextButton15.ZIndex = 10
store.TextButton15.Position = UDim2.new(0,-2,0,-2)
store.TextButton15.Size = UDim2.new(1,4,1,4)
store.TextButton15.BackgroundTransparency = 1
store.TextButton15.Text = ""
store.TextButton15.AutoButtonColor = false
store.TextButton15.Parent = store.Frame21

-- Frame22
store["Frame22"] = Instance.new("Frame")
store.Frame22.Name = "Frame"
store.Frame22.ZIndex = 4
store.Frame22.LayoutOrder = 9
store.Frame22.Size = UDim2.new(1,0,0,34)
store.Frame22.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame22.BackgroundTransparency = 0.5
store.Frame22.BorderSizePixel = 0
store.Frame22.Parent = store.Page_Speed

store["UICorner17"] = Instance.new("UICorner")
store.UICorner17.Name = "UICorner"
store.UICorner17.CornerRadius = UDim.new(0,12)
store.UICorner17.Parent = store.Frame22

store["UIStroke10"] = Instance.new("UIStroke")
store.UIStroke10.Name = "UIStroke"
store.UIStroke10.Color = Color3.fromRGB(35,35,45)
store.UIStroke10.Transparency = 0.4
store.UIStroke10.Parent = store.Frame22

store["TextLabel8"] = Instance.new("TextLabel")
store.TextLabel8.Name = "TextLabel"
store.TextLabel8.ZIndex = 5
store.TextLabel8.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel8.Size = UDim2.new(1,-136,0,16)
store.TextLabel8.BackgroundTransparency = 1
store.TextLabel8.Text = "Speed Change Method"
store.TextLabel8.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel8.TextSize = 11
store.TextLabel8.Font = Enum.Font.GothamBold
store.TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel8.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel8.Parent = store.Frame22

store["Frame23"] = Instance.new("Frame")
store.Frame23.Name = "Frame"
store.Frame23.Visible = false
store.Frame23.ZIndex = 5
store.Frame23.Position = UDim2.new(0,12,0.5,7)
store.Frame23.Size = UDim2.new(0,112,0,1)
store.Frame23.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame23.BackgroundTransparency = 0.5
store.Frame23.BorderSizePixel = 0
store.Frame23.Parent = store.Frame22

store["TextButton16"] = Instance.new("TextButton")
store.TextButton16.Name = "TextButton"
store.TextButton16.ZIndex = 5
store.TextButton16.Position = UDim2.new(1,-118,0.5,-12)
store.TextButton16.Size = UDim2.new(0,50,0,24)
store.TextButton16.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton16.BackgroundTransparency = 0.5
store.TextButton16.BorderSizePixel = 0
store.TextButton16.Text = "V1"
store.TextButton16.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton16.TextSize = 10
store.TextButton16.Font = Enum.Font.GothamBold
store.TextButton16.AutoButtonColor = false
store.TextButton16.Parent = store.Frame22

store["UICorner18"] = Instance.new("UICorner")
store.UICorner18.Name = "UICorner"
store.UICorner18.Parent = store.TextButton16

store["TextButton17"] = Instance.new("TextButton")
store.TextButton17.Name = "TextButton"
store.TextButton17.ZIndex = 5
store.TextButton17.Position = UDim2.new(1,-62,0.5,-12)
store.TextButton17.Size = UDim2.new(0,50,0,24)
store.TextButton17.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton17.BackgroundTransparency = 0.5
store.TextButton17.BorderSizePixel = 0
store.TextButton17.Text = "V2"
store.TextButton17.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton17.TextSize = 10
store.TextButton17.Font = Enum.Font.GothamBold
store.TextButton17.AutoButtonColor = false
store.TextButton17.Parent = store.Frame22

store["UICorner19"] = Instance.new("UICorner")
store.UICorner19.Name = "UICorner"
store.UICorner19.Parent = store.TextButton17

-- Frame24
store["Frame24"] = Instance.new("Frame")
store.Frame24.Name = "Frame"
store.Frame24.ZIndex = 4
store.Frame24.LayoutOrder = 16
store.Frame24.Size = UDim2.new(1,0,0,40)
store.Frame24.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame24.BackgroundTransparency = 0.5
store.Frame24.BorderSizePixel = 0
store.Frame24.Parent = store.Page_Speed

store["UICorner20"] = Instance.new("UICorner")
store.UICorner20.Name = "UICorner"
store.UICorner20.CornerRadius = UDim.new(0,10)
store.UICorner20.Parent = store.Frame24

store["UIStroke11"] = Instance.new("UIStroke")
store.UIStroke11.Name = "UIStroke"
store.UIStroke11.Color = Color3.fromRGB(28,28,34)
store.UIStroke11.Parent = store.Frame24

store["TextLabel9"] = Instance.new("TextLabel")
store.TextLabel9.Name = "TextLabel"
store.TextLabel9.ZIndex = 5
store.TextLabel9.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel9.Size = UDim2.new(0.6,0,0,16)
store.TextLabel9.BackgroundTransparency = 1
store.TextLabel9.Text = "Auto Speed"
store.TextLabel9.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel9.TextSize = 11
store.TextLabel9.Font = Enum.Font.GothamBold
store.TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel9.Parent = store.Frame24

store["Frame25"] = Instance.new("Frame")
store.Frame25.Name = "Frame"
store.Frame25.Visible = false
store.Frame25.ZIndex = 5
store.Frame25.Position = UDim2.new(0,12,0.5,7)
store.Frame25.Size = UDim2.new(0,57,0,1)
store.Frame25.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame25.BackgroundTransparency = 0.5
store.Frame25.BorderSizePixel = 0
store.Frame25.Parent = store.Frame24

store["Frame26"] = Instance.new("Frame")
store.Frame26.Name = "Frame"
store.Frame26.ZIndex = 6
store.Frame26.Position = UDim2.new(1,-44,0.5,-8)
store.Frame26.Size = UDim2.new(0,32,0,16)
store.Frame26.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame26.BackgroundTransparency = 0.5
store.Frame26.BorderSizePixel = 0
store.Frame26.Parent = store.Frame24

store["UICorner21"] = Instance.new("UICorner")
store.UICorner21.Name = "UICorner"
store.UICorner21.CornerRadius = UDim.new(1,0)
store.UICorner21.Parent = store.Frame26

store["UIStroke12"] = Instance.new("UIStroke")
store.UIStroke12.Name = "UIStroke"
store.UIStroke12.Color = Color3.fromRGB(70,70,70)
store.UIStroke12.Transparency = 0.5
store.UIStroke12.Parent = store.Frame26

store["Frame27"] = Instance.new("Frame")
store.Frame27.Name = "Frame"
store.Frame27.ZIndex = 7
store.Frame27.Position = UDim2.new(0,2,0.5,-6)
store.Frame27.Size = UDim2.new(0,12,0,12)
store.Frame27.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame27.BackgroundTransparency = 0.5
store.Frame27.BorderSizePixel = 0
store.Frame27.Parent = store.Frame26

store["UICorner22"] = Instance.new("UICorner")
store.UICorner22.Name = "UICorner"
store.UICorner22.CornerRadius = UDim.new(1,0)
store.UICorner22.Parent = store.Frame27

store["TextButton18"] = Instance.new("TextButton")
store.TextButton18.Name = "TextButton"
store.TextButton18.ZIndex = 8
store.TextButton18.Size = UDim2.new(1,0,1,0)
store.TextButton18.BackgroundTransparency = 1
store.TextButton18.Text = ""
store.TextButton18.Parent = store.Frame24

store["PressPop"] = Instance.new("UIScale")
store.PressPop.Name = "PressPop"
store.PressPop.Parent = store.Frame24

store["TextButton19"] = Instance.new("TextButton")
store.TextButton19.Name = "TextButton"
store.TextButton19.ZIndex = 12
store.TextButton19.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton19.Size = UDim2.new(0,32,0,22)
store.TextButton19.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton19.BackgroundTransparency = 0.5
store.TextButton19.BorderSizePixel = 0
store.TextButton19.Text = ""
store.TextButton19.AutoButtonColor = false
store.TextButton19.Parent = store.Frame24

store["UICorner23"] = Instance.new("UICorner")
store.UICorner23.Name = "UICorner"
store.UICorner23.CornerRadius = UDim.new(0,6)
store.UICorner23.Parent = store.TextButton19

store["UIStroke13"] = Instance.new("UIStroke")
store.UIStroke13.Name = "UIStroke"
store.UIStroke13.Color = Color3.fromRGB(254,254,254)
store.UIStroke13.Thickness = 1.4
store.UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke13.Transparency = 0.25
store.UIStroke13.Parent = store.TextButton19

store["UIGradient10"] = Instance.new("UIGradient")
store.UIGradient10.Name = "UIGradient"
store.UIGradient10.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient10.Parent = store.UIStroke13

store["TextLabel10"] = Instance.new("TextLabel")
store.TextLabel10.Name = "TextLabel"
store.TextLabel10.ZIndex = 20
store.TextLabel10.Size = UDim2.new(1,0,1,0)
store.TextLabel10.BackgroundTransparency = 1
store.TextLabel10.Text = "▼"
store.TextLabel10.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel10.TextSize = 15
store.TextLabel10.Font = Enum.Font.GothamBlack
store.TextLabel10.Parent = store.TextButton19

store["DropdownPanel"] = Instance.new("Frame")
store.DropdownPanel.Name = "DropdownPanel"
store.DropdownPanel.Visible = false
store.DropdownPanel.ZIndex = 4
store.DropdownPanel.LayoutOrder = 17
store.DropdownPanel.Size = UDim2.new(1,0,0,34)
store.DropdownPanel.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.DropdownPanel.BackgroundTransparency = 0.5
store.DropdownPanel.BorderSizePixel = 0
store.DropdownPanel.Parent = store.Page_Speed

store["UICorner24"] = Instance.new("UICorner")
store.UICorner24.Name = "UICorner"
store.UICorner24.CornerRadius = UDim.new(0,12)
store.UICorner24.Parent = store.DropdownPanel

store["UIStroke14"] = Instance.new("UIStroke")
store.UIStroke14.Name = "UIStroke"
store.UIStroke14.Color = Color3.fromRGB(254,254,254)
store.UIStroke14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke14.Transparency = 0.5
store.UIStroke14.Parent = store.DropdownPanel

store["TextLabel11"] = Instance.new("TextLabel")
store.TextLabel11.Name = "TextLabel"
store.TextLabel11.ZIndex = 5
store.TextLabel11.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel11.Size = UDim2.new(0.5,0,0,16)
store.TextLabel11.BackgroundTransparency = 1
store.TextLabel11.Text = "Auto Speed"
store.TextLabel11.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel11.TextSize = 11
store.TextLabel11.Font = Enum.Font.GothamBold
store.TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel11.Parent = store.DropdownPanel

store["Frame28"] = Instance.new("Frame")
store.Frame28.Name = "Frame"
store.Frame28.Visible = false
store.Frame28.ZIndex = 5
store.Frame28.Position = UDim2.new(0,12,0.5,7)
store.Frame28.Size = UDim2.new(0,57,0,1)
store.Frame28.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame28.BackgroundTransparency = 0.5
store.Frame28.BorderSizePixel = 0
store.Frame28.Parent = store.DropdownPanel

store["TextButton20"] = Instance.new("TextButton")
store.TextButton20.Name = "TextButton"
store.TextButton20.ZIndex = 5
store.TextButton20.Position = UDim2.new(1,-174,0,5)
store.TextButton20.Size = UDim2.new(0,78,0,24)
store.TextButton20.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton20.BackgroundTransparency = 0.5
store.TextButton20.BorderSizePixel = 0
store.TextButton20.Text = "On Pick Up"
store.TextButton20.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton20.TextSize = 10
store.TextButton20.Font = Enum.Font.GothamBold
store.TextButton20.AutoButtonColor = false
store.TextButton20.Parent = store.DropdownPanel

store["UICorner25"] = Instance.new("UICorner")
store.UICorner25.Name = "UICorner"
store.UICorner25.Parent = store.TextButton20

store["TextButton21"] = Instance.new("TextButton")
store.TextButton21.Name = "TextButton"
store.TextButton21.ZIndex = 5
store.TextButton21.Position = UDim2.new(1,-90,0,5)
store.TextButton21.Size = UDim2.new(0,78,0,24)
store.TextButton21.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton21.BackgroundTransparency = 0.5
store.TextButton21.BorderSizePixel = 0
store.TextButton21.Text = "Soft Steal"
store.TextButton21.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton21.TextSize = 10
store.TextButton21.Font = Enum.Font.GothamBold
store.TextButton21.AutoButtonColor = false
store.TextButton21.Parent = store.DropdownPanel

store["UICorner26"] = Instance.new("UICorner")
store.UICorner26.Name = "UICorner"
store.UICorner26.Parent = store.TextButton21

-- Steal Page
store["Page_Steal"] = Instance.new("Frame")
store.Page_Steal.Name = "Page_Steal"
store.Page_Steal.ZIndex = 3
store.Page_Steal.LayoutOrder = 2001
store.Page_Steal.Size = UDim2.new(1,0,0,0)
store.Page_Steal.BackgroundTransparency = 1
store.Page_Steal.BorderSizePixel = 0
store.Page_Steal.Parent = store.ScrollingFrame

store["UIListLayout4"] = Instance.new("UIListLayout")
store.UIListLayout4.Name = "UIListLayout"
store.UIListLayout4.Padding = UDim.new(0,10)
store.UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout4.Parent = store.Page_Steal

store["UIPadding4"] = Instance.new("UIPadding")
store.UIPadding4.Name = "UIPadding"
store.UIPadding4.PaddingTop = UDim.new(0,10)
store.UIPadding4.PaddingLeft = UDim.new(0,12)
store.UIPadding4.PaddingRight = UDim.new(0,12)
store.UIPadding4.Parent = store.Page_Steal

store["Frame29"] = Instance.new("Frame")
store.Frame29.Name = "Frame"
store.Frame29.LayoutOrder = 1
store.Frame29.Size = UDim2.new(1,0,0,42)
store.Frame29.BackgroundTransparency = 1
store.Frame29.BorderSizePixel = 0
store.Frame29.Parent = store.Page_Steal

store["TextLabel12"] = Instance.new("TextLabel")
store.TextLabel12.Name = "TextLabel"
store.TextLabel12.ZIndex = 4
store.TextLabel12.Position = UDim2.new(0,0,0,20)
store.TextLabel12.Size = UDim2.new(1,0,0,16)
store.TextLabel12.BackgroundTransparency = 1
store.TextLabel12.Text = "STEAL CONFIGURATION"
store.TextLabel12.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel12.TextSize = 12
store.TextLabel12.Font = Enum.Font.GothamBlack
store.TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel12.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel12.Parent = store.Frame29

store["Frame30"] = Instance.new("Frame")
store.Frame30.Name = "Frame"
store.Frame30.ZIndex = 3
store.Frame30.Position = UDim2.new(0,0,0,38)
store.Frame30.Size = UDim2.new(1,0,0,1)
store.Frame30.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame30.BackgroundTransparency = 0.85
store.Frame30.BorderSizePixel = 0
store.Frame30.Parent = store.Frame29

store["Frame31"] = Instance.new("Frame")
store.Frame31.Name = "Frame"
store.Frame31.ZIndex = 4
store.Frame31.LayoutOrder = 12
store.Frame31.Size = UDim2.new(1,0,0,40)
store.Frame31.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame31.BackgroundTransparency = 0.5
store.Frame31.BorderSizePixel = 0
store.Frame31.Parent = store.Page_Steal

store["UICorner27"] = Instance.new("UICorner")
store.UICorner27.Name = "UICorner"
store.UICorner27.CornerRadius = UDim.new(0,10)
store.UICorner27.Parent = store.Frame31

store["UIStroke15"] = Instance.new("UIStroke")
store.UIStroke15.Name = "UIStroke"
store.UIStroke15.Color = Color3.fromRGB(28,28,34)
store.UIStroke15.Parent = store.Frame31

store["TextLabel13"] = Instance.new("TextLabel")
store.TextLabel13.Name = "TextLabel"
store.TextLabel13.ZIndex = 5
store.TextLabel13.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel13.Size = UDim2.new(0.6,0,0,16)
store.TextLabel13.BackgroundTransparency = 1
store.TextLabel13.Text = "Radius"
store.TextLabel13.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel13.TextSize = 11
store.TextLabel13.Font = Enum.Font.GothamBold
store.TextLabel13.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel13.Parent = store.Frame31

store["Frame32"] = Instance.new("Frame")
store.Frame32.Name = "Frame"
store.Frame32.Visible = false
store.Frame32.ZIndex = 5
store.Frame32.Position = UDim2.new(0,12,0.5,7)
store.Frame32.Size = UDim2.new(0,33,0,1)
store.Frame32.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame32.BackgroundTransparency = 0.5
store.Frame32.BorderSizePixel = 0
store.Frame32.Parent = store.Frame31

store["Frame33"] = Instance.new("Frame")
store.Frame33.Name = "Frame"
store.Frame33.ZIndex = 6
store.Frame33.Position = UDim2.new(1,-54,0.5,-11)
store.Frame33.Size = UDim2.new(0,46,0,22)
store.Frame33.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame33.BackgroundTransparency = 0.5
store.Frame33.BorderSizePixel = 0
store.Frame33.Parent = store.Frame31

store["UICorner28"] = Instance.new("UICorner")
store.UICorner28.Name = "UICorner"
store.UICorner28.Parent = store.Frame33

store["UIStroke16"] = Instance.new("UIStroke")
store.UIStroke16.Name = "UIStroke"
store.UIStroke16.Color = Color3.fromRGB(254,254,254)
store.UIStroke16.Thickness = 1.4
store.UIStroke16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke16.Transparency = 0.25
store.UIStroke16.Parent = store.Frame33

store["UIGradient11"] = Instance.new("UIGradient")
store.UIGradient11.Name = "UIGradient"
store.UIGradient11.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient11.Parent = store.UIStroke16

store["TextBox7"] = Instance.new("TextBox")
store.TextBox7.Name = "TextBox"
store.TextBox7.ZIndex = 7
store.TextBox7.Size = UDim2.new(1,0,1,0)
store.TextBox7.BackgroundTransparency = 1
store.TextBox7.Text = "62"
store.TextBox7.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox7.TextSize = 11
store.TextBox7.Font = Enum.Font.GothamBold
store.TextBox7.ClearTextOnFocus = false
store.TextBox7.Parent = store.Frame33

store["Frame34"] = Instance.new("Frame")
store.Frame34.Name = "Frame"
store.Frame34.ZIndex = 4
store.Frame34.LayoutOrder = 10
store.Frame34.Size = UDim2.new(1,0,0,40)
store.Frame34.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame34.BackgroundTransparency = 0.5
store.Frame34.BorderSizePixel = 0
store.Frame34.Parent = store.Page_Steal

store["UICorner29"] = Instance.new("UICorner")
store.UICorner29.Name = "UICorner"
store.UICorner29.CornerRadius = UDim.new(0,10)
store.UICorner29.Parent = store.Frame34

store["UIStroke17"] = Instance.new("UIStroke")
store.UIStroke17.Name = "UIStroke"
store.UIStroke17.Color = Color3.fromRGB(28,28,34)
store.UIStroke17.Parent = store.Frame34

store["TextLabel14"] = Instance.new("TextLabel")
store.TextLabel14.Name = "TextLabel"
store.TextLabel14.ZIndex = 5
store.TextLabel14.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel14.Size = UDim2.new(0.6,0,0,16)
store.TextLabel14.BackgroundTransparency = 1
store.TextLabel14.Text = "Auto Steal"
store.TextLabel14.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel14.TextSize = 11
store.TextLabel14.Font = Enum.Font.GothamBold
store.TextLabel14.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel14.Parent = store.Frame34

store["Frame35"] = Instance.new("Frame")
store.Frame35.Name = "Frame"
store.Frame35.Visible = false
store.Frame35.ZIndex = 5
store.Frame35.Position = UDim2.new(0,12,0.5,7)
store.Frame35.Size = UDim2.new(0,50,0,1)
store.Frame35.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame35.BackgroundTransparency = 0.5
store.Frame35.BorderSizePixel = 0
store.Frame35.Parent = store.Frame34

store["Frame36"] = Instance.new("Frame")
store.Frame36.Name = "Frame"
store.Frame36.ZIndex = 6
store.Frame36.Position = UDim2.new(1,-44,0.5,-8)
store.Frame36.Size = UDim2.new(0,32,0,16)
store.Frame36.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame36.BackgroundTransparency = 0.5
store.Frame36.BorderSizePixel = 0
store.Frame36.Parent = store.Frame34

store["UICorner30"] = Instance.new("UICorner")
store.UICorner30.Name = "UICorner"
store.UICorner30.CornerRadius = UDim.new(1,0)
store.UICorner30.Parent = store.Frame36

store["UIStroke18"] = Instance.new("UIStroke")
store.UIStroke18.Name = "UIStroke"
store.UIStroke18.Color = Color3.fromRGB(70,70,70)
store.UIStroke18.Transparency = 0.5
store.UIStroke18.Parent = store.Frame36

store["Frame37"] = Instance.new("Frame")
store.Frame37.Name = "Frame"
store.Frame37.ZIndex = 7
store.Frame37.Position = UDim2.new(0,2,0.5,-6)
store.Frame37.Size = UDim2.new(0,12,0,12)
store.Frame37.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame37.BackgroundTransparency = 0.5
store.Frame37.BorderSizePixel = 0
store.Frame37.Parent = store.Frame36

store["UICorner31"] = Instance.new("UICorner")
store.UICorner31.Name = "UICorner"
store.UICorner31.CornerRadius = UDim.new(1,0)
store.UICorner31.Parent = store.Frame37

store["TextButton22"] = Instance.new("TextButton")
store.TextButton22.Name = "TextButton"
store.TextButton22.ZIndex = 8
store.TextButton22.Size = UDim2.new(1,0,1,0)
store.TextButton22.BackgroundTransparency = 1
store.TextButton22.Text = ""
store.TextButton22.Parent = store.Frame34

store["TextButton23"] = Instance.new("TextButton")
store.TextButton23.Name = "TextButton"
store.TextButton23.ZIndex = 12
store.TextButton23.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton23.Size = UDim2.new(0,32,0,22)
store.TextButton23.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton23.BackgroundTransparency = 0.5
store.TextButton23.BorderSizePixel = 0
store.TextButton23.Text = ""
store.TextButton23.AutoButtonColor = false
store.TextButton23.Parent = store.Frame34

store["UICorner32"] = Instance.new("UICorner")
store.UICorner32.Name = "UICorner"
store.UICorner32.CornerRadius = UDim.new(0,6)
store.UICorner32.Parent = store.TextButton23

store["UIStroke19"] = Instance.new("UIStroke")
store.UIStroke19.Name = "UIStroke"
store.UIStroke19.Color = Color3.fromRGB(254,254,254)
store.UIStroke19.Thickness = 1.4
store.UIStroke19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke19.Transparency = 0.25
store.UIStroke19.Parent = store.TextButton23

store["UIGradient12"] = Instance.new("UIGradient")
store.UIGradient12.Name = "UIGradient"
store.UIGradient12.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient12.Parent = store.UIStroke19

store["TextLabel15"] = Instance.new("TextLabel")
store.TextLabel15.Name = "TextLabel"
store.TextLabel15.ZIndex = 20
store.TextLabel15.Size = UDim2.new(1,0,1,0)
store.TextLabel15.BackgroundTransparency = 1
store.TextLabel15.Text = "▼"
store.TextLabel15.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel15.TextSize = 15
store.TextLabel15.Font = Enum.Font.GothamBlack
store.TextLabel15.Parent = store.TextButton23

store["DropdownPanel2"] = Instance.new("Frame")
store.DropdownPanel2.Name = "DropdownPanel"
store.DropdownPanel2.Visible = false
store.DropdownPanel2.ZIndex = 4
store.DropdownPanel2.LayoutOrder = 11
store.DropdownPanel2.Size = UDim2.new(1,0,0,34)
store.DropdownPanel2.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.DropdownPanel2.BackgroundTransparency = 0.5
store.DropdownPanel2.BorderSizePixel = 0
store.DropdownPanel2.Parent = store.Page_Steal

store["UICorner33"] = Instance.new("UICorner")
store.UICorner33.Name = "UICorner"
store.UICorner33.CornerRadius = UDim.new(0,12)
store.UICorner33.Parent = store.DropdownPanel2

store["UIStroke20"] = Instance.new("UIStroke")
store.UIStroke20.Name = "UIStroke"
store.UIStroke20.Color = Color3.fromRGB(254,254,254)
store.UIStroke20.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke20.Transparency = 0.5
store.UIStroke20.Parent = store.DropdownPanel2

store["TextLabel16"] = Instance.new("TextLabel")
store.TextLabel16.Name = "TextLabel"
store.TextLabel16.ZIndex = 5
store.TextLabel16.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel16.Size = UDim2.new(0.5,0,0,16)
store.TextLabel16.BackgroundTransparency = 1
store.TextLabel16.Text = "Steal Mode"
store.TextLabel16.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel16.TextSize = 11
store.TextLabel16.Font = Enum.Font.GothamBold
store.TextLabel16.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel16.Parent = store.DropdownPanel2

store["Frame38"] = Instance.new("Frame")
store.Frame38.Name = "Frame"
store.Frame38.Visible = false
store.Frame38.ZIndex = 5
store.Frame38.Position = UDim2.new(0,12,0.5,7)
store.Frame38.Size = UDim2.new(0,54,0,1)
store.Frame38.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame38.BackgroundTransparency = 0.5
store.Frame38.BorderSizePixel = 0
store.Frame38.Parent = store.DropdownPanel2

store["TextButton24"] = Instance.new("TextButton")
store.TextButton24.Name = "TextButton"
store.TextButton24.ZIndex = 5
store.TextButton24.Position = UDim2.new(1,-174,0,5)
store.TextButton24.Size = UDim2.new(0,78,0,24)
store.TextButton24.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton24.BackgroundTransparency = 0.5
store.TextButton24.BorderSizePixel = 0
store.TextButton24.Text = "Normal"
store.TextButton24.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton24.TextSize = 10
store.TextButton24.Font = Enum.Font.GothamBold
store.TextButton24.AutoButtonColor = false
store.TextButton24.Parent = store.DropdownPanel2

store["UICorner34"] = Instance.new("UICorner")
store.UICorner34.Name = "UICorner"
store.UICorner34.Parent = store.TextButton24

store["TextButton25"] = Instance.new("TextButton")
store.TextButton25.Name = "TextButton"
store.TextButton25.ZIndex = 5
store.TextButton25.Position = UDim2.new(1,-90,0,5)
store.TextButton25.Size = UDim2.new(0,78,0,24)
store.TextButton25.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton25.BackgroundTransparency = 0.5
store.TextButton25.BorderSizePixel = 0
store.TextButton25.Text = "Semi"
store.TextButton25.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton25.TextSize = 10
store.TextButton25.Font = Enum.Font.GothamBold
store.TextButton25.AutoButtonColor = false
store.TextButton25.Parent = store.DropdownPanel2

store["UICorner35"] = Instance.new("UICorner")
store.UICorner35.Name = "UICorner"
store.UICorner35.Parent = store.TextButton25

store["Frame39"] = Instance.new("Frame")
store.Frame39.Name = "Frame"
store.Frame39.ZIndex = 4
store.Frame39.LayoutOrder = 16
store.Frame39.Size = UDim2.new(1,0,0,40)
store.Frame39.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame39.BackgroundTransparency = 0.5
store.Frame39.BorderSizePixel = 0
store.Frame39.Parent = store.Page_Steal

store["UICorner36"] = Instance.new("UICorner")
store.UICorner36.Name = "UICorner"
store.UICorner36.CornerRadius = UDim.new(0,10)
store.UICorner36.Parent = store.Frame39

store["UIStroke21"] = Instance.new("UIStroke")
store.UIStroke21.Name = "UIStroke"
store.UIStroke21.Color = Color3.fromRGB(28,28,34)
store.UIStroke21.Parent = store.Frame39

store["TextLabel17"] = Instance.new("TextLabel")
store.TextLabel17.Name = "TextLabel"
store.TextLabel17.ZIndex = 5
store.TextLabel17.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel17.Size = UDim2.new(0.6,0,0,16)
store.TextLabel17.BackgroundTransparency = 1
store.TextLabel17.Text = "Ragdoll Steal"
store.TextLabel17.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel17.TextSize = 11
store.TextLabel17.Font = Enum.Font.GothamBold
store.TextLabel17.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel17.Parent = store.Frame39

store["Frame40"] = Instance.new("Frame")
store.Frame40.Name = "Frame"
store.Frame40.Visible = false
store.Frame40.ZIndex = 5
store.Frame40.Position = UDim2.new(0,12,0.5,7)
store.Frame40.Size = UDim2.new(0,64,0,1)
store.Frame40.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame40.BackgroundTransparency = 0.5
store.Frame40.BorderSizePixel = 0
store.Frame40.Parent = store.Frame39

store["Frame41"] = Instance.new("Frame")
store.Frame41.Name = "Frame"
store.Frame41.ZIndex = 6
store.Frame41.Position = UDim2.new(1,-44,0.5,-8)
store.Frame41.Size = UDim2.new(0,32,0,16)
store.Frame41.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame41.BackgroundTransparency = 0.5
store.Frame41.BorderSizePixel = 0
store.Frame41.Parent = store.Frame39

store["UICorner37"] = Instance.new("UICorner")
store.UICorner37.Name = "UICorner"
store.UICorner37.CornerRadius = UDim.new(1,0)
store.UICorner37.Parent = store.Frame41

store["UIStroke22"] = Instance.new("UIStroke")
store.UIStroke22.Name = "UIStroke"
store.UIStroke22.Color = Color3.fromRGB(70,70,70)
store.UIStroke22.Transparency = 0.5
store.UIStroke22.Parent = store.Frame41

store["Frame42"] = Instance.new("Frame")
store.Frame42.Name = "Frame"
store.Frame42.ZIndex = 7
store.Frame42.Position = UDim2.new(0,2,0.5,-6)
store.Frame42.Size = UDim2.new(0,12,0,12)
store.Frame42.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame42.BackgroundTransparency = 0.5
store.Frame42.BorderSizePixel = 0
store.Frame42.Parent = store.Frame41

store["UICorner38"] = Instance.new("UICorner")
store.UICorner38.Name = "UICorner"
store.UICorner38.CornerRadius = UDim.new(1,0)
store.UICorner38.Parent = store.Frame42

store["TextButton26"] = Instance.new("TextButton")
store.TextButton26.Name = "TextButton"
store.TextButton26.ZIndex = 8
store.TextButton26.Size = UDim2.new(1,0,1,0)
store.TextButton26.BackgroundTransparency = 1
store.TextButton26.Text = ""
store.TextButton26.Parent = store.Frame39

store["PressPop2"] = Instance.new("UIScale")
store.PressPop2.Name = "PressPop"
store.PressPop2.Parent = store.Frame39

-- Movement Page
store["Page_Movement"] = Instance.new("Frame")
store.Page_Movement.Name = "Page_Movement"
store.Page_Movement.ZIndex = 3
store.Page_Movement.LayoutOrder = 3001
store.Page_Movement.Size = UDim2.new(1,0,0,0)
store.Page_Movement.BackgroundTransparency = 1
store.Page_Movement.BorderSizePixel = 0
store.Page_Movement.Parent = store.ScrollingFrame

store["UIListLayout5"] = Instance.new("UIListLayout")
store.UIListLayout5.Name = "UIListLayout"
store.UIListLayout5.Padding = UDim.new(0,10)
store.UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout5.Parent = store.Page_Movement

store["UIPadding5"] = Instance.new("UIPadding")
store.UIPadding5.Name = "UIPadding"
store.UIPadding5.PaddingTop = UDim.new(0,10)
store.UIPadding5.PaddingLeft = UDim.new(0,12)
store.UIPadding5.PaddingRight = UDim.new(0,12)
store.UIPadding5.Parent = store.Page_Movement

store["Frame43"] = Instance.new("Frame")
store.Frame43.Name = "Frame"
store.Frame43.LayoutOrder = 55
store.Frame43.Size = UDim2.new(1,0,0,42)
store.Frame43.BackgroundTransparency = 1
store.Frame43.BorderSizePixel = 0
store.Frame43.Parent = store.Page_Movement

store["TextLabel18"] = Instance.new("TextLabel")
store.TextLabel18.Name = "TextLabel"
store.TextLabel18.ZIndex = 4
store.TextLabel18.Position = UDim2.new(0,0,0,20)
store.TextLabel18.Size = UDim2.new(1,0,0,16)
store.TextLabel18.BackgroundTransparency = 1
store.TextLabel18.Text = "COUNTERS CONFIGURATION"
store.TextLabel18.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel18.TextSize = 12
store.TextLabel18.Font = Enum.Font.GothamBlack
store.TextLabel18.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel18.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel18.Parent = store.Frame43

store["Frame44"] = Instance.new("Frame")
store.Frame44.Name = "Frame"
store.Frame44.ZIndex = 3
store.Frame44.Position = UDim2.new(0,0,0,38)
store.Frame44.Size = UDim2.new(1,0,0,1)
store.Frame44.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame44.BackgroundTransparency = 0.85
store.Frame44.BorderSizePixel = 0
store.Frame44.Parent = store.Frame43

store["Frame45"] = Instance.new("Frame")
store.Frame45.Name = "Frame"
store.Frame45.LayoutOrder = 18
store.Frame45.Size = UDim2.new(1,0,0,42)
store.Frame45.BackgroundTransparency = 1
store.Frame45.BorderSizePixel = 0
store.Frame45.Parent = store.Page_Movement

store["TextLabel19"] = Instance.new("TextLabel")
store.TextLabel19.Name = "TextLabel"
store.TextLabel19.ZIndex = 4
store.TextLabel19.Position = UDim2.new(0,0,0,20)
store.TextLabel19.Size = UDim2.new(1,0,0,16)
store.TextLabel19.BackgroundTransparency = 1
store.TextLabel19.Text = "AIMBOT CONFIGURATION"
store.TextLabel19.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel19.TextSize = 12
store.TextLabel19.Font = Enum.Font.GothamBlack
store.TextLabel19.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel19.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel19.Parent = store.Frame45

store["Frame46"] = Instance.new("Frame")
store.Frame46.Name = "Frame"
store.Frame46.ZIndex = 3
store.Frame46.Position = UDim2.new(0,0,0,38)
store.Frame46.Size = UDim2.new(1,0,0,1)
store.Frame46.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame46.BackgroundTransparency = 0.85
store.Frame46.BorderSizePixel = 0
store.Frame46.Parent = store.Frame45

store["Frame47"] = Instance.new("Frame")
store.Frame47.Name = "Frame"
store.Frame47.ZIndex = 4
store.Frame47.LayoutOrder = 20
store.Frame47.Size = UDim2.new(1,0,0,40)
store.Frame47.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame47.BackgroundTransparency = 0.5
store.Frame47.BorderSizePixel = 0
store.Frame47.Parent = store.Page_Movement

store["UICorner39"] = Instance.new("UICorner")
store.UICorner39.Name = "UICorner"
store.UICorner39.CornerRadius = UDim.new(0,10)
store.UICorner39.Parent = store.Frame47

store["UIStroke23"] = Instance.new("UIStroke")
store.UIStroke23.Name = "UIStroke"
store.UIStroke23.Color = Color3.fromRGB(28,28,34)
store.UIStroke23.Parent = store.Frame47

store["TextLabel20"] = Instance.new("TextLabel")
store.TextLabel20.Name = "TextLabel"
store.TextLabel20.ZIndex = 5
store.TextLabel20.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel20.Size = UDim2.new(0.6,0,0,16)
store.TextLabel20.BackgroundTransparency = 1
store.TextLabel20.Text = "Bat Aimbot"
store.TextLabel20.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel20.TextSize = 11
store.TextLabel20.Font = Enum.Font.GothamBold
store.TextLabel20.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel20.Parent = store.Frame47

store["Frame48"] = Instance.new("Frame")
store.Frame48.Name = "Frame"
store.Frame48.Visible = false
store.Frame48.ZIndex = 5
store.Frame48.Position = UDim2.new(0,12,0.5,7)
store.Frame48.Size = UDim2.new(0,55,0,1)
store.Frame48.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame48.BackgroundTransparency = 0.5
store.Frame48.BorderSizePixel = 0
store.Frame48.Parent = store.Frame47

store["Frame49"] = Instance.new("Frame")
store.Frame49.Name = "Frame"
store.Frame49.ZIndex = 9
store.Frame49.ClipsDescendants = true
store.Frame49.Position = UDim2.new(1,-44,0.5,-11)
store.Frame49.Size = UDim2.new(0,32,0,22)
store.Frame49.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame49.BackgroundTransparency = 0.6
store.Frame49.BorderSizePixel = 0
store.Frame49.Parent = store.Frame47

store["UICorner40"] = Instance.new("UICorner")
store.UICorner40.Name = "UICorner"
store.UICorner40.Parent = store.Frame49

store["TextLabel21"] = Instance.new("TextLabel")
store.TextLabel21.Name = "TextLabel"
store.TextLabel21.ZIndex = 10
store.TextLabel21.Size = UDim2.new(1,0,1,0)
store.TextLabel21.BackgroundTransparency = 1
store.TextLabel21.Text = "None"
store.TextLabel21.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel21.TextSize = 10
store.TextLabel21.TextScaled = true
store.TextLabel21.Font = Enum.Font.GothamBold
store.TextLabel21.TextWrapped = true
store.TextLabel21.Parent = store.Frame49

store["UITextSizeConstraint4"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint4.Name = "UITextSizeConstraint"
store.UITextSizeConstraint4.MinTextSize = 6
store.UITextSizeConstraint4.MaxTextSize = 10
store.UITextSizeConstraint4.Parent = store.TextLabel21

store["TextButton27"] = Instance.new("TextButton")
store.TextButton27.Name = "TextButton"
store.TextButton27.ZIndex = 11
store.TextButton27.Size = UDim2.new(1,0,1,0)
store.TextButton27.BackgroundTransparency = 1
store.TextButton27.Text = ""
store.TextButton27.AutoButtonColor = false
store.TextButton27.Parent = store.Frame49

store["TextButton28"] = Instance.new("TextButton")
store.TextButton28.Name = "TextButton"
store.TextButton28.ZIndex = 12
store.TextButton28.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton28.Size = UDim2.new(0,32,0,22)
store.TextButton28.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton28.BackgroundTransparency = 0.5
store.TextButton28.BorderSizePixel = 0
store.TextButton28.Text = ""
store.TextButton28.AutoButtonColor = false
store.TextButton28.Parent = store.Frame47

store["UICorner41"] = Instance.new("UICorner")
store.UICorner41.Name = "UICorner"
store.UICorner41.CornerRadius = UDim.new(0,6)
store.UICorner41.Parent = store.TextButton28

store["UIStroke24"] = Instance.new("UIStroke")
store.UIStroke24.Name = "UIStroke"
store.UIStroke24.Color = Color3.fromRGB(254,254,254)
store.UIStroke24.Thickness = 1.4
store.UIStroke24.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke24.Transparency = 0.25
store.UIStroke24.Parent = store.TextButton28

store["UIGradient13"] = Instance.new("UIGradient")
store.UIGradient13.Name = "UIGradient"
store.UIGradient13.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient13.Parent = store.UIStroke24

store["TextLabel22"] = Instance.new("TextLabel")
store.TextLabel22.Name = "TextLabel"
store.TextLabel22.ZIndex = 20
store.TextLabel22.Size = UDim2.new(1,0,1,0)
store.TextLabel22.BackgroundTransparency = 1
store.TextLabel22.Text = "▼"
store.TextLabel22.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel22.TextSize = 15
store.TextLabel22.Font = Enum.Font.GothamBlack
store.TextLabel22.Parent = store.TextButton28

store["Frame50"] = Instance.new("Frame")
store.Frame50.Name = "Frame"
store.Frame50.Visible = false
store.Frame50.ZIndex = 4
store.Frame50.LayoutOrder = 24
store.Frame50.Size = UDim2.new(1,0,0,34)
store.Frame50.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame50.BackgroundTransparency = 0.5
store.Frame50.BorderSizePixel = 0
store.Frame50.Parent = store.Page_Movement

store["UICorner42"] = Instance.new("UICorner")
store.UICorner42.Name = "UICorner"
store.UICorner42.CornerRadius = UDim.new(0,12)
store.UICorner42.Parent = store.Frame50

store["UIStroke25"] = Instance.new("UIStroke")
store.UIStroke25.Name = "UIStroke"
store.UIStroke25.Color = Color3.fromRGB(35,35,45)
store.UIStroke25.Transparency = 0.4
store.UIStroke25.Parent = store.Frame50

store["TextLabel23"] = Instance.new("TextLabel")
store.TextLabel23.Name = "TextLabel"
store.TextLabel23.ZIndex = 5
store.TextLabel23.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel23.Size = UDim2.new(0.55,0,0,16)
store.TextLabel23.BackgroundTransparency = 1
store.TextLabel23.Text = "Aimbot Normal Speed"
store.TextLabel23.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel23.TextSize = 11
store.TextLabel23.Font = Enum.Font.GothamBold
store.TextLabel23.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel23.Parent = store.Frame50

store["Frame51"] = Instance.new("Frame")
store.Frame51.Name = "Frame"
store.Frame51.Visible = false
store.Frame51.ZIndex = 5
store.Frame51.Position = UDim2.new(0,12,0.5,7)
store.Frame51.Size = UDim2.new(0,108,0,1)
store.Frame51.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame51.BackgroundTransparency = 0.5
store.Frame51.BorderSizePixel = 0
store.Frame51.Parent = store.Frame50

store["TextBox8"] = Instance.new("TextBox")
store.TextBox8.Name = "TextBox"
store.TextBox8.ZIndex = 5
store.TextBox8.Position = UDim2.new(1,-82,0.5,-12)
store.TextBox8.Size = UDim2.new(0,70,0,24)
store.TextBox8.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextBox8.BorderSizePixel = 0
store.TextBox8.Text = "58"
store.TextBox8.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox8.TextSize = 12
store.TextBox8.Font = Enum.Font.GothamBold
store.TextBox8.ClearTextOnFocus = false
store.TextBox8.Parent = store.Frame50

store["UICorner43"] = Instance.new("UICorner")
store.UICorner43.Name = "UICorner"
store.UICorner43.Parent = store.TextBox8

store["UIStroke26"] = Instance.new("UIStroke")
store.UIStroke26.Name = "UIStroke"
store.UIStroke26.Color = Color3.fromRGB(254,254,254)
store.UIStroke26.Thickness = 1.4
store.UIStroke26.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke26.Transparency = 0.25
store.UIStroke26.Parent = store.TextBox8

store["UIGradient14"] = Instance.new("UIGradient")
store.UIGradient14.Name = "UIGradient"
store.UIGradient14.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient14.Parent = store.UIStroke26

store["Frame52"] = Instance.new("Frame")
store.Frame52.Name = "Frame"
store.Frame52.Visible = false
store.Frame52.ZIndex = 4
store.Frame52.LayoutOrder = 26
store.Frame52.Size = UDim2.new(1,0,0,34)
store.Frame52.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame52.BackgroundTransparency = 0.5
store.Frame52.BorderSizePixel = 0
store.Frame52.Parent = store.Page_Movement

store["UICorner44"] = Instance.new("UICorner")
store.UICorner44.Name = "UICorner"
store.UICorner44.CornerRadius = UDim.new(0,12)
store.UICorner44.Parent = store.Frame52

store["UIStroke27"] = Instance.new("UIStroke")
store.UIStroke27.Name = "UIStroke"
store.UIStroke27.Color = Color3.fromRGB(35,35,45)
store.UIStroke27.Transparency = 0.4
store.UIStroke27.Parent = store.Frame52

store["TextLabel24"] = Instance.new("TextLabel")
store.TextLabel24.Name = "TextLabel"
store.TextLabel24.ZIndex = 5
store.TextLabel24.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel24.Size = UDim2.new(0.55,0,0,16)
store.TextLabel24.BackgroundTransparency = 1
store.TextLabel24.Text = "Aimbot Lagger Speed"
store.TextLabel24.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel24.TextSize = 11
store.TextLabel24.Font = Enum.Font.GothamBold
store.TextLabel24.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel24.Parent = store.Frame52

store["Frame53"] = Instance.new("Frame")
store.Frame53.Name = "Frame"
store.Frame53.Visible = false
store.Frame53.ZIndex = 5
store.Frame53.Position = UDim2.new(0,12,0.5,7)
store.Frame53.Size = UDim2.new(0,107,0,1)
store.Frame53.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame53.BackgroundTransparency = 0.5
store.Frame53.BorderSizePixel = 0
store.Frame53.Parent = store.Frame52

store["TextBox9"] = Instance.new("TextBox")
store.TextBox9.Name = "TextBox"
store.TextBox9.ZIndex = 5
store.TextBox9.Position = UDim2.new(1,-82,0.5,-12)
store.TextBox9.Size = UDim2.new(0,70,0,24)
store.TextBox9.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextBox9.BorderSizePixel = 0
store.TextBox9.Text = "40"
store.TextBox9.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox9.TextSize = 12
store.TextBox9.Font = Enum.Font.GothamBold
store.TextBox9.ClearTextOnFocus = false
store.TextBox9.Parent = store.Frame52

store["UICorner45"] = Instance.new("UICorner")
store.UICorner45.Name = "UICorner"
store.UICorner45.Parent = store.TextBox9

store["UIStroke28"] = Instance.new("UIStroke")
store.UIStroke28.Name = "UIStroke"
store.UIStroke28.Color = Color3.fromRGB(254,254,254)
store.UIStroke28.Thickness = 1.4
store.UIStroke28.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke28.Transparency = 0.25
store.UIStroke28.Parent = store.TextBox9

store["UIGradient15"] = Instance.new("UIGradient")
store.UIGradient15.Name = "UIGradient"
store.UIGradient15.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient15.Parent = store.UIStroke28

store["Frame54"] = Instance.new("Frame")
store.Frame54.Name = "Frame"
store.Frame54.Visible = false
store.Frame54.ZIndex = 4
store.Frame54.LayoutOrder = 28
store.Frame54.Size = UDim2.new(1,0,0,34)
store.Frame54.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame54.BackgroundTransparency = 0.5
store.Frame54.BorderSizePixel = 0
store.Frame54.Parent = store.Page_Movement

store["UICorner46"] = Instance.new("UICorner")
store.UICorner46.Name = "UICorner"
store.UICorner46.CornerRadius = UDim.new(0,12)
store.UICorner46.Parent = store.Frame54

store["UIStroke29"] = Instance.new("UIStroke")
store.UIStroke29.Name = "UIStroke"
store.UIStroke29.Color = Color3.fromRGB(35,35,45)
store.UIStroke29.Transparency = 0.4
store.UIStroke29.Parent = store.Frame54

store["TextLabel25"] = Instance.new("TextLabel")
store.TextLabel25.Name = "TextLabel"
store.TextLabel25.ZIndex = 5
store.TextLabel25.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel25.Size = UDim2.new(0.55,0,0,16)
store.TextLabel25.BackgroundTransparency = 1
store.TextLabel25.Text = "Aimbot Custom Speed"
store.TextLabel25.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel25.TextSize = 11
store.TextLabel25.Font = Enum.Font.GothamBold
store.TextLabel25.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel25.Parent = store.Frame54

store["Frame55"] = Instance.new("Frame")
store.Frame55.Name = "Frame"
store.Frame55.Visible = false
store.Frame55.ZIndex = 5
store.Frame55.Position = UDim2.new(0,12,0.5,7)
store.Frame55.Size = UDim2.new(0,110,0,1)
store.Frame55.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame55.BackgroundTransparency = 0.5
store.Frame55.BorderSizePixel = 0
store.Frame55.Parent = store.Frame54

store["TextBox10"] = Instance.new("TextBox")
store.TextBox10.Name = "TextBox"
store.TextBox10.ZIndex = 5
store.TextBox10.Position = UDim2.new(1,-82,0.5,-12)
store.TextBox10.Size = UDim2.new(0,70,0,24)
store.TextBox10.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextBox10.BorderSizePixel = 0
store.TextBox10.Text = "58"
store.TextBox10.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox10.TextSize = 12
store.TextBox10.Font = Enum.Font.GothamBold
store.TextBox10.ClearTextOnFocus = false
store.TextBox10.Parent = store.Frame54

store["UICorner47"] = Instance.new("UICorner")
store.UICorner47.Name = "UICorner"
store.UICorner47.Parent = store.TextBox10

store["UIStroke30"] = Instance.new("UIStroke")
store.UIStroke30.Name = "UIStroke"
store.UIStroke30.Color = Color3.fromRGB(254,254,254)
store.UIStroke30.Thickness = 1.4
store.UIStroke30.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke30.Transparency = 0.25
store.UIStroke30.Parent = store.TextBox10

store["UIGradient16"] = Instance.new("UIGradient")
store.UIGradient16.Name = "UIGradient"
store.UIGradient16.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient16.Parent = store.UIStroke30

store["Frame56"] = Instance.new("Frame")
store.Frame56.Name = "Frame"
store.Frame56.Visible = false
store.Frame56.ZIndex = 4
store.Frame56.LayoutOrder = 29
store.Frame56.Size = UDim2.new(1,0,0,40)
store.Frame56.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame56.BackgroundTransparency = 0.5
store.Frame56.BorderSizePixel = 0
store.Frame56.Parent = store.Page_Movement

store["UICorner48"] = Instance.new("UICorner")
store.UICorner48.Name = "UICorner"
store.UICorner48.CornerRadius = UDim.new(0,10)
store.UICorner48.Parent = store.Frame56

store["UIStroke31"] = Instance.new("UIStroke")
store.UIStroke31.Name = "UIStroke"
store.UIStroke31.Color = Color3.fromRGB(28,28,34)
store.UIStroke31.Parent = store.Frame56

store["TextLabel26"] = Instance.new("TextLabel")
store.TextLabel26.Name = "TextLabel"
store.TextLabel26.ZIndex = 5
store.TextLabel26.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel26.Size = UDim2.new(0.6,0,0,16)
store.TextLabel26.BackgroundTransparency = 1
store.TextLabel26.Text = "Auto Swing"
store.TextLabel26.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel26.TextSize = 11
store.TextLabel26.Font = Enum.Font.GothamBold
store.TextLabel26.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel26.Parent = store.Frame56

store["Frame57"] = Instance.new("Frame")
store.Frame57.Name = "Frame"
store.Frame57.Visible = false
store.Frame57.ZIndex = 5
store.Frame57.Position = UDim2.new(0,12,0.5,7)
store.Frame57.Size = UDim2.new(0,57,0,1)
store.Frame57.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame57.BackgroundTransparency = 0.5
store.Frame57.BorderSizePixel = 0
store.Frame57.Parent = store.Frame56

store["Frame58"] = Instance.new("Frame")
store.Frame58.Name = "Frame"
store.Frame58.ZIndex = 6
store.Frame58.Position = UDim2.new(1,-44,0.5,-8)
store.Frame58.Size = UDim2.new(0,32,0,16)
store.Frame58.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame58.BackgroundTransparency = 0.5
store.Frame58.BorderSizePixel = 0
store.Frame58.Parent = store.Frame56

store["UICorner49"] = Instance.new("UICorner")
store.UICorner49.Name = "UICorner"
store.UICorner49.CornerRadius = UDim.new(1,0)
store.UICorner49.Parent = store.Frame58

store["UIStroke32"] = Instance.new("UIStroke")
store.UIStroke32.Name = "UIStroke"
store.UIStroke32.Color = Color3.fromRGB(255,255,255)
store.UIStroke32.Transparency = 0.4
store.UIStroke32.Parent = store.Frame58

store["Frame59"] = Instance.new("Frame")
store.Frame59.Name = "Frame"
store.Frame59.ZIndex = 7
store.Frame59.Position = UDim2.new(0,18,0.5,-6)
store.Frame59.Size = UDim2.new(0,12,0,12)
store.Frame59.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame59.BackgroundTransparency = 0.5
store.Frame59.BorderSizePixel = 0
store.Frame59.Parent = store.Frame58

store["UICorner50"] = Instance.new("UICorner")
store.UICorner50.Name = "UICorner"
store.UICorner50.CornerRadius = UDim.new(1,0)
store.UICorner50.Parent = store.Frame59

store["TextButton29"] = Instance.new("TextButton")
store.TextButton29.Name = "TextButton"
store.TextButton29.ZIndex = 8
store.TextButton29.Size = UDim2.new(1,0,1,0)
store.TextButton29.BackgroundTransparency = 1
store.TextButton29.Text = ""
store.TextButton29.Parent = store.Frame56

store["PressPop3"] = Instance.new("UIScale")
store.PressPop3.Name = "PressPop"
store.PressPop3.Parent = store.Frame56

store["Frame60"] = Instance.new("Frame")
store.Frame60.Name = "Frame"
store.Frame60.Visible = false
store.Frame60.ZIndex = 4
store.Frame60.LayoutOrder = 38
store.Frame60.Size = UDim2.new(1,0,0,40)
store.Frame60.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame60.BackgroundTransparency = 0.5
store.Frame60.BorderSizePixel = 0
store.Frame60.Parent = store.Page_Movement

store["UICorner51"] = Instance.new("UICorner")
store.UICorner51.Name = "UICorner"
store.UICorner51.CornerRadius = UDim.new(0,10)
store.UICorner51.Parent = store.Frame60

store["UIStroke33"] = Instance.new("UIStroke")
store.UIStroke33.Name = "UIStroke"
store.UIStroke33.Color = Color3.fromRGB(28,28,34)
store.UIStroke33.Parent = store.Frame60

store["TextLabel27"] = Instance.new("TextLabel")
store.TextLabel27.Name = "TextLabel"
store.TextLabel27.ZIndex = 5
store.TextLabel27.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel27.Size = UDim2.new(0.6,0,0,16)
store.TextLabel27.BackgroundTransparency = 1
store.TextLabel27.Text = "Remove Camera Shake"
store.TextLabel27.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel27.TextSize = 11
store.TextLabel27.Font = Enum.Font.GothamBold
store.TextLabel27.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel27.Parent = store.Frame60

store["Frame61"] = Instance.new("Frame")
store.Frame61.Name = "Frame"
store.Frame61.Visible = false
store.Frame61.ZIndex = 5
store.Frame61.Position = UDim2.new(0,12,0.5,7)
store.Frame61.Size = UDim2.new(0,113,0,1)
store.Frame61.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame61.BackgroundTransparency = 0.5
store.Frame61.BorderSizePixel = 0
store.Frame61.Parent = store.Frame60

store["Frame62"] = Instance.new("Frame")
store.Frame62.Name = "Frame"
store.Frame62.ZIndex = 6
store.Frame62.Position = UDim2.new(1,-44,0.5,-8)
store.Frame62.Size = UDim2.new(0,32,0,16)
store.Frame62.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame62.BackgroundTransparency = 0.5
store.Frame62.BorderSizePixel = 0
store.Frame62.Parent = store.Frame60

store["UICorner52"] = Instance.new("UICorner")
store.UICorner52.Name = "UICorner"
store.UICorner52.CornerRadius = UDim.new(1,0)
store.UICorner52.Parent = store.Frame62

store["UIStroke34"] = Instance.new("UIStroke")
store.UIStroke34.Name = "UIStroke"
store.UIStroke34.Color = Color3.fromRGB(70,70,70)
store.UIStroke34.Transparency = 0.5
store.UIStroke34.Parent = store.Frame62

store["Frame63"] = Instance.new("Frame")
store.Frame63.Name = "Frame"
store.Frame63.ZIndex = 7
store.Frame63.Position = UDim2.new(0,2,0.5,-6)
store.Frame63.Size = UDim2.new(0,12,0,12)
store.Frame63.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame63.BackgroundTransparency = 0.5
store.Frame63.BorderSizePixel = 0
store.Frame63.Parent = store.Frame62

store["UICorner53"] = Instance.new("UICorner")
store.UICorner53.Name = "UICorner"
store.UICorner53.CornerRadius = UDim.new(1,0)
store.UICorner53.Parent = store.Frame63

store["TextButton30"] = Instance.new("TextButton")
store.TextButton30.Name = "TextButton"
store.TextButton30.ZIndex = 8
store.TextButton30.Size = UDim2.new(1,0,1,0)
store.TextButton30.BackgroundTransparency = 1
store.TextButton30.Text = ""
store.TextButton30.Parent = store.Frame60

store["PressPop4"] = Instance.new("UIScale")
store.PressPop4.Name = "PressPop"
store.PressPop4.Parent = store.Frame60

store["Frame64"] = Instance.new("Frame")
store.Frame64.Name = "Frame"
store.Frame64.ZIndex = 4
store.Frame64.LayoutOrder = 32
store.Frame64.Size = UDim2.new(1,0,0,40)
store.Frame64.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame64.BackgroundTransparency = 0.5
store.Frame64.BorderSizePixel = 0
store.Frame64.Parent = store.Page_Movement

store["UICorner54"] = Instance.new("UICorner")
store.UICorner54.Name = "UICorner"
store.UICorner54.CornerRadius = UDim.new(0,10)
store.UICorner54.Parent = store.Frame64

store["UIStroke35"] = Instance.new("UIStroke")
store.UIStroke35.Name = "UIStroke"
store.UIStroke35.Color = Color3.fromRGB(28,28,34)
store.UIStroke35.Parent = store.Frame64

store["TextLabel28"] = Instance.new("TextLabel")
store.TextLabel28.Name = "TextLabel"
store.TextLabel28.ZIndex = 5
store.TextLabel28.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel28.Size = UDim2.new(0.6,0,0,16)
store.TextLabel28.BackgroundTransparency = 1
store.TextLabel28.Text = "TP Bat"
store.TextLabel28.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel28.TextSize = 11
store.TextLabel28.Font = Enum.Font.GothamBold
store.TextLabel28.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel28.Parent = store.Frame64

store["Frame65"] = Instance.new("Frame")
store.Frame65.Name = "Frame"
store.Frame65.Visible = false
store.Frame65.ZIndex = 5
store.Frame65.Position = UDim2.new(0,12,0.5,7)
store.Frame65.Size = UDim2.new(0,32,0,1)
store.Frame65.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame65.BackgroundTransparency = 0.5
store.Frame65.BorderSizePixel = 0
store.Frame65.Parent = store.Frame64

store["Frame66"] = Instance.new("Frame")
store.Frame66.Name = "Frame"
store.Frame66.ZIndex = 9
store.Frame66.ClipsDescendants = true
store.Frame66.Position = UDim2.new(1,-44,0.5,-11)
store.Frame66.Size = UDim2.new(0,32,0,22)
store.Frame66.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame66.BackgroundTransparency = 0.6
store.Frame66.BorderSizePixel = 0
store.Frame66.Parent = store.Frame64

store["UICorner55"] = Instance.new("UICorner")
store.UICorner55.Name = "UICorner"
store.UICorner55.Parent = store.Frame66

store["TextLabel29"] = Instance.new("TextLabel")
store.TextLabel29.Name = "TextLabel"
store.TextLabel29.ZIndex = 10
store.TextLabel29.Size = UDim2.new(1,0,1,0)
store.TextLabel29.BackgroundTransparency = 1
store.TextLabel29.Text = "None"
store.TextLabel29.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel29.TextSize = 10
store.TextLabel29.TextScaled = true
store.TextLabel29.Font = Enum.Font.GothamBold
store.TextLabel29.TextWrapped = true
store.TextLabel29.Parent = store.Frame66

store["UITextSizeConstraint5"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint5.Name = "UITextSizeConstraint"
store.UITextSizeConstraint5.MinTextSize = 6
store.UITextSizeConstraint5.MaxTextSize = 10
store.UITextSizeConstraint5.Parent = store.TextLabel29

store["TextButton31"] = Instance.new("TextButton")
store.TextButton31.Name = "TextButton"
store.TextButton31.ZIndex = 11
store.TextButton31.Size = UDim2.new(1,0,1,0)
store.TextButton31.BackgroundTransparency = 1
store.TextButton31.Text = ""
store.TextButton31.AutoButtonColor = false
store.TextButton31.Parent = store.Frame66

store["TextButton32"] = Instance.new("TextButton")
store.TextButton32.Name = "TextButton"
store.TextButton32.ZIndex = 12
store.TextButton32.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton32.Size = UDim2.new(0,32,0,22)
store.TextButton32.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton32.BackgroundTransparency = 0.5
store.TextButton32.BorderSizePixel = 0
store.TextButton32.Text = ""
store.TextButton32.AutoButtonColor = false
store.TextButton32.Parent = store.Frame64

store["UICorner56"] = Instance.new("UICorner")
store.UICorner56.Name = "UICorner"
store.UICorner56.CornerRadius = UDim.new(0,6)
store.UICorner56.Parent = store.TextButton32

store["UIStroke36"] = Instance.new("UIStroke")
store.UIStroke36.Name = "UIStroke"
store.UIStroke36.Color = Color3.fromRGB(254,254,254)
store.UIStroke36.Thickness = 1.4
store.UIStroke36.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke36.Transparency = 0.25
store.UIStroke36.Parent = store.TextButton32

store["UIGradient17"] = Instance.new("UIGradient")
store.UIGradient17.Name = "UIGradient"
store.UIGradient17.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient17.Parent = store.UIStroke36

store["TextLabel30"] = Instance.new("TextLabel")
store.TextLabel30.Name = "TextLabel"
store.TextLabel30.ZIndex = 20
store.TextLabel30.Size = UDim2.new(1,0,1,0)
store.TextLabel30.BackgroundTransparency = 1
store.TextLabel30.Text = "▼"
store.TextLabel30.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel30.TextSize = 15
store.TextLabel30.Font = Enum.Font.GothamBlack
store.TextLabel30.Parent = store.TextButton32

store["Frame67"] = Instance.new("Frame")
store.Frame67.Name = "Frame"
store.Frame67.Visible = false
store.Frame67.ZIndex = 4
store.Frame67.LayoutOrder = 34
store.Frame67.Size = UDim2.new(1,0,0,34)
store.Frame67.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame67.BackgroundTransparency = 0.5
store.Frame67.BorderSizePixel = 0
store.Frame67.Parent = store.Page_Movement

store["UICorner57"] = Instance.new("UICorner")
store.UICorner57.Name = "UICorner"
store.UICorner57.CornerRadius = UDim.new(0,12)
store.UICorner57.Parent = store.Frame67

store["UIStroke37"] = Instance.new("UIStroke")
store.UIStroke37.Name = "UIStroke"
store.UIStroke37.Color = Color3.fromRGB(35,35,45)
store.UIStroke37.Transparency = 0.4
store.UIStroke37.Parent = store.Frame67

store["TextLabel31"] = Instance.new("TextLabel")
store.TextLabel31.Name = "TextLabel"
store.TextLabel31.ZIndex = 5
store.TextLabel31.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel31.Size = UDim2.new(1,-136,0,16)
store.TextLabel31.BackgroundTransparency = 1
store.TextLabel31.Text = "TP Mode"
store.TextLabel31.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel31.TextSize = 11
store.TextLabel31.Font = Enum.Font.GothamBold
store.TextLabel31.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel31.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel31.Parent = store.Frame67

store["Frame68"] = Instance.new("Frame")
store.Frame68.Name = "Frame"
store.Frame68.Visible = false
store.Frame68.ZIndex = 5
store.Frame68.Position = UDim2.new(0,12,0.5,7)
store.Frame68.Size = UDim2.new(0,43,0,1)
store.Frame68.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame68.BackgroundTransparency = 0.5
store.Frame68.BorderSizePixel = 0
store.Frame68.Parent = store.Frame67

store["TextButton33"] = Instance.new("TextButton")
store.TextButton33.Name = "TextButton"
store.TextButton33.ZIndex = 5
store.TextButton33.Position = UDim2.new(1,-118,0.5,-12)
store.TextButton33.Size = UDim2.new(0,50,0,24)
store.TextButton33.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton33.BackgroundTransparency = 0.5
store.TextButton33.BorderSizePixel = 0
store.TextButton33.Text = "V1"
store.TextButton33.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton33.TextSize = 10
store.TextButton33.Font = Enum.Font.GothamBold
store.TextButton33.AutoButtonColor = false
store.TextButton33.Parent = store.Frame67

store["UICorner58"] = Instance.new("UICorner")
store.UICorner58.Name = "UICorner"
store.UICorner58.Parent = store.TextButton33

store["TextButton34"] = Instance.new("TextButton")
store.TextButton34.Name = "TextButton"
store.TextButton34.ZIndex = 5
store.TextButton34.Position = UDim2.new(1,-62,0.5,-12)
store.TextButton34.Size = UDim2.new(0,50,0,24)
store.TextButton34.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton34.BackgroundTransparency = 0.5
store.TextButton34.BorderSizePixel = 0
store.TextButton34.Text = "V2"
store.TextButton34.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton34.TextSize = 10
store.TextButton34.Font = Enum.Font.GothamBold
store.TextButton34.AutoButtonColor = false
store.TextButton34.Parent = store.Frame67

store["UICorner59"] = Instance.new("UICorner")
store.UICorner59.Name = "UICorner"
store.UICorner59.Parent = store.TextButton34

store["Frame69"] = Instance.new("Frame")
store.Frame69.Name = "Frame"
store.Frame69.Visible = false
store.Frame69.ZIndex = 4
store.Frame69.LayoutOrder = 36
store.Frame69.Size = UDim2.new(1,0,0,40)
store.Frame69.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame69.BackgroundTransparency = 0.5
store.Frame69.BorderSizePixel = 0
store.Frame69.Parent = store.Page_Movement

store["UICorner60"] = Instance.new("UICorner")
store.UICorner60.Name = "UICorner"
store.UICorner60.CornerRadius = UDim.new(0,10)
store.UICorner60.Parent = store.Frame69

store["UIStroke38"] = Instance.new("UIStroke")
store.UIStroke38.Name = "UIStroke"
store.UIStroke38.Color = Color3.fromRGB(28,28,34)
store.UIStroke38.Parent = store.Frame69

store["TextLabel32"] = Instance.new("TextLabel")
store.TextLabel32.Name = "TextLabel"
store.TextLabel32.ZIndex = 5
store.TextLabel32.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel32.Size = UDim2.new(0.6,0,0,16)
store.TextLabel32.BackgroundTransparency = 1
store.TextLabel32.Text = "Auto Swing"
store.TextLabel32.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel32.TextSize = 11
store.TextLabel32.Font = Enum.Font.GothamBold
store.TextLabel32.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel32.Parent = store.Frame69

store["Frame70"] = Instance.new("Frame")
store.Frame70.Name = "Frame"
store.Frame70.Visible = false
store.Frame70.ZIndex = 5
store.Frame70.Position = UDim2.new(0,12,0.5,7)
store.Frame70.Size = UDim2.new(0,57,0,1)
store.Frame70.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame70.BackgroundTransparency = 0.5
store.Frame70.BorderSizePixel = 0
store.Frame70.Parent = store.Frame69

store["Frame71"] = Instance.new("Frame")
store.Frame71.Name = "Frame"
store.Frame71.ZIndex = 6
store.Frame71.Position = UDim2.new(1,-44,0.5,-8)
store.Frame71.Size = UDim2.new(0,32,0,16)
store.Frame71.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame71.BackgroundTransparency = 0.5
store.Frame71.BorderSizePixel = 0
store.Frame71.Parent = store.Frame69

store["UICorner61"] = Instance.new("UICorner")
store.UICorner61.Name = "UICorner"
store.UICorner61.CornerRadius = UDim.new(1,0)
store.UICorner61.Parent = store.Frame71

store["UIStroke39"] = Instance.new("UIStroke")
store.UIStroke39.Name = "UIStroke"
store.UIStroke39.Color = Color3.fromRGB(70,70,70)
store.UIStroke39.Transparency = 0.5
store.UIStroke39.Parent = store.Frame71

store["Frame72"] = Instance.new("Frame")
store.Frame72.Name = "Frame"
store.Frame72.ZIndex = 7
store.Frame72.Position = UDim2.new(0,2,0.5,-6)
store.Frame72.Size = UDim2.new(0,12,0,12)
store.Frame72.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame72.BackgroundTransparency = 0.5
store.Frame72.BorderSizePixel = 0
store.Frame72.Parent = store.Frame71

store["UICorner62"] = Instance.new("UICorner")
store.UICorner62.Name = "UICorner"
store.UICorner62.CornerRadius = UDim.new(1,0)
store.UICorner62.Parent = store.Frame72

store["TextButton35"] = Instance.new("TextButton")
store.TextButton35.Name = "TextButton"
store.TextButton35.ZIndex = 8
store.TextButton35.Size = UDim2.new(1,0,1,0)
store.TextButton35.BackgroundTransparency = 1
store.TextButton35.Text = ""
store.TextButton35.Parent = store.Frame69

store["PressPop5"] = Instance.new("UIScale")
store.PressPop5.Name = "PressPop"
store.PressPop5.Parent = store.Frame69

store["Frame73"] = Instance.new("Frame")
store.Frame73.Name = "Frame"
store.Frame73.Visible = false
store.Frame73.ZIndex = 4
store.Frame73.LayoutOrder = 30
store.Frame73.Size = UDim2.new(1,0,0,40)
store.Frame73.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame73.BackgroundTransparency = 0.5
store.Frame73.BorderSizePixel = 0
store.Frame73.Parent = store.Page_Movement

store["UICorner63"] = Instance.new("UICorner")
store.UICorner63.Name = "UICorner"
store.UICorner63.CornerRadius = UDim.new(0,10)
store.UICorner63.Parent = store.Frame73

store["UIStroke40"] = Instance.new("UIStroke")
store.UIStroke40.Name = "UIStroke"
store.UIStroke40.Color = Color3.fromRGB(28,28,34)
store.UIStroke40.Parent = store.Frame73

store["TextLabel33"] = Instance.new("TextLabel")
store.TextLabel33.Name = "TextLabel"
store.TextLabel33.ZIndex = 5
store.TextLabel33.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel33.Size = UDim2.new(0.6,0,0,16)
store.TextLabel33.BackgroundTransparency = 1
store.TextLabel33.Text = "Mirror TP Down"
store.TextLabel33.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel33.TextSize = 11
store.TextLabel33.Font = Enum.Font.GothamBold
store.TextLabel33.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel33.Parent = store.Frame73

store["Frame74"] = Instance.new("Frame")
store.Frame74.Name = "Frame"
store.Frame74.Visible = false
store.Frame74.ZIndex = 5
store.Frame74.Position = UDim2.new(0,12,0.5,7)
store.Frame74.Size = UDim2.new(0,76,0,1)
store.Frame74.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame74.BackgroundTransparency = 0.5
store.Frame74.BorderSizePixel = 0
store.Frame74.Parent = store.Frame73

store["Frame75"] = Instance.new("Frame")
store.Frame75.Name = "Frame"
store.Frame75.ZIndex = 6
store.Frame75.Position = UDim2.new(1,-44,0.5,-8)
store.Frame75.Size = UDim2.new(0,32,0,16)
store.Frame75.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame75.BackgroundTransparency = 0.5
store.Frame75.BorderSizePixel = 0
store.Frame75.Parent = store.Frame73

store["UICorner64"] = Instance.new("UICorner")
store.UICorner64.Name = "UICorner"
store.UICorner64.CornerRadius = UDim.new(1,0)
store.UICorner64.Parent = store.Frame75

store["UIStroke41"] = Instance.new("UIStroke")
store.UIStroke41.Name = "UIStroke"
store.UIStroke41.Color = Color3.fromRGB(70,70,70)
store.UIStroke41.Transparency = 0.5
store.UIStroke41.Parent = store.Frame75

store["Frame76"] = Instance.new("Frame")
store.Frame76.Name = "Frame"
store.Frame76.ZIndex = 7
store.Frame76.Position = UDim2.new(0,2,0.5,-6)
store.Frame76.Size = UDim2.new(0,12,0,12)
store.Frame76.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame76.BackgroundTransparency = 0.5
store.Frame76.BorderSizePixel = 0
store.Frame76.Parent = store.Frame75

store["UICorner65"] = Instance.new("UICorner")
store.UICorner65.Name = "UICorner"
store.UICorner65.CornerRadius = UDim.new(1,0)
store.UICorner65.Parent = store.Frame76

store["TextButton36"] = Instance.new("TextButton")
store.TextButton36.Name = "TextButton"
store.TextButton36.ZIndex = 8
store.TextButton36.Size = UDim2.new(1,0,1,0)
store.TextButton36.BackgroundTransparency = 1
store.TextButton36.Text = ""
store.TextButton36.Parent = store.Frame73

store["PressPop6"] = Instance.new("UIScale")
store.PressPop6.Name = "PressPop"
store.PressPop6.Parent = store.Frame73

store["Frame77"] = Instance.new("Frame")
store.Frame77.Name = "Frame"
store.Frame77.ZIndex = 4
store.Frame77.LayoutOrder = 56
store.Frame77.Size = UDim2.new(1,0,0,40)
store.Frame77.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame77.BackgroundTransparency = 0.5
store.Frame77.BorderSizePixel = 0
store.Frame77.Parent = store.Page_Movement

store["UICorner66"] = Instance.new("UICorner")
store.UICorner66.Name = "UICorner"
store.UICorner66.CornerRadius = UDim.new(0,10)
store.UICorner66.Parent = store.Frame77

store["UIStroke42"] = Instance.new("UIStroke")
store.UIStroke42.Name = "UIStroke"
store.UIStroke42.Color = Color3.fromRGB(28,28,34)
store.UIStroke42.Parent = store.Frame77

store["TextLabel34"] = Instance.new("TextLabel")
store.TextLabel34.Name = "TextLabel"
store.TextLabel34.ZIndex = 5
store.TextLabel34.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel34.Size = UDim2.new(0.6,0,0,16)
store.TextLabel34.BackgroundTransparency = 1
store.TextLabel34.Text = "Medusa Counter"
store.TextLabel34.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel34.TextSize = 11
store.TextLabel34.Font = Enum.Font.GothamBold
store.TextLabel34.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel34.Parent = store.Frame77

store["Frame78"] = Instance.new("Frame")
store.Frame78.Name = "Frame"
store.Frame78.Visible = false
store.Frame78.ZIndex = 5
store.Frame78.Position = UDim2.new(0,12,0.5,7)
store.Frame78.Size = UDim2.new(0,81,0,1)
store.Frame78.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame78.BackgroundTransparency = 0.5
store.Frame78.BorderSizePixel = 0
store.Frame78.Parent = store.Frame77

store["Frame79"] = Instance.new("Frame")
store.Frame79.Name = "Frame"
store.Frame79.ZIndex = 6
store.Frame79.Position = UDim2.new(1,-44,0.5,-8)
store.Frame79.Size = UDim2.new(0,32,0,16)
store.Frame79.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame79.BackgroundTransparency = 0.5
store.Frame79.BorderSizePixel = 0
store.Frame79.Parent = store.Frame77

store["UICorner67"] = Instance.new("UICorner")
store.UICorner67.Name = "UICorner"
store.UICorner67.CornerRadius = UDim.new(1,0)
store.UICorner67.Parent = store.Frame79

store["UIStroke43"] = Instance.new("UIStroke")
store.UIStroke43.Name = "UIStroke"
store.UIStroke43.Color = Color3.fromRGB(70,70,70)
store.UIStroke43.Transparency = 0.5
store.UIStroke43.Parent = store.Frame79

store["Frame80"] = Instance.new("Frame")
store.Frame80.Name = "Frame"
store.Frame80.ZIndex = 7
store.Frame80.Position = UDim2.new(0,2,0.5,-6)
store.Frame80.Size = UDim2.new(0,12,0,12)
store.Frame80.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame80.BackgroundTransparency = 0.5
store.Frame80.BorderSizePixel = 0
store.Frame80.Parent = store.Frame79

store["UICorner68"] = Instance.new("UICorner")
store.UICorner68.Name = "UICorner"
store.UICorner68.CornerRadius = UDim.new(1,0)
store.UICorner68.Parent = store.Frame80

store["TextButton37"] = Instance.new("TextButton")
store.TextButton37.Name = "TextButton"
store.TextButton37.ZIndex = 8
store.TextButton37.Size = UDim2.new(1,0,1,0)
store.TextButton37.BackgroundTransparency = 1
store.TextButton37.Text = ""
store.TextButton37.Parent = store.Frame77

store["PressPop7"] = Instance.new("UIScale")
store.PressPop7.Name = "PressPop"
store.PressPop7.Parent = store.Frame77

store["Frame81"] = Instance.new("Frame")
store.Frame81.Name = "Frame"
store.Frame81.ZIndex = 4
store.Frame81.LayoutOrder = 57
store.Frame81.Size = UDim2.new(1,0,0,40)
store.Frame81.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame81.BackgroundTransparency = 0.5
store.Frame81.BorderSizePixel = 0
store.Frame81.Parent = store.Page_Movement

store["UICorner69"] = Instance.new("UICorner")
store.UICorner69.Name = "UICorner"
store.UICorner69.CornerRadius = UDim.new(0,10)
store.UICorner69.Parent = store.Frame81

store["UIStroke44"] = Instance.new("UIStroke")
store.UIStroke44.Name = "UIStroke"
store.UIStroke44.Color = Color3.fromRGB(28,28,34)
store.UIStroke44.Parent = store.Frame81

store["TextLabel35"] = Instance.new("TextLabel")
store.TextLabel35.Name = "TextLabel"
store.TextLabel35.ZIndex = 5
store.TextLabel35.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel35.Size = UDim2.new(0.6,0,0,16)
store.TextLabel35.BackgroundTransparency = 1
store.TextLabel35.Text = "Bat Counter"
store.TextLabel35.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel35.TextSize = 11
store.TextLabel35.Font = Enum.Font.GothamBold
store.TextLabel35.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel35.Parent = store.Frame81

store["Frame82"] = Instance.new("Frame")
store.Frame82.Name = "Frame"
store.Frame82.Visible = false
store.Frame82.ZIndex = 5
store.Frame82.Position = UDim2.new(0,12,0.5,7)
store.Frame82.Size = UDim2.new(0,59,0,1)
store.Frame82.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame82.BackgroundTransparency = 0.5
store.Frame82.BorderSizePixel = 0
store.Frame82.Parent = store.Frame81

store["Frame83"] = Instance.new("Frame")
store.Frame83.Name = "Frame"
store.Frame83.ZIndex = 6
store.Frame83.Position = UDim2.new(1,-44,0.5,-8)
store.Frame83.Size = UDim2.new(0,32,0,16)
store.Frame83.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame83.BackgroundTransparency = 0.5
store.Frame83.BorderSizePixel = 0
store.Frame83.Parent = store.Frame81

store["UICorner70"] = Instance.new("UICorner")
store.UICorner70.Name = "UICorner"
store.UICorner70.CornerRadius = UDim.new(1,0)
store.UICorner70.Parent = store.Frame83

store["UIStroke45"] = Instance.new("UIStroke")
store.UIStroke45.Name = "UIStroke"
store.UIStroke45.Color = Color3.fromRGB(70,70,70)
store.UIStroke45.Transparency = 0.5
store.UIStroke45.Parent = store.Frame83

store["Frame84"] = Instance.new("Frame")
store.Frame84.Name = "Frame"
store.Frame84.ZIndex = 7
store.Frame84.Position = UDim2.new(0,2,0.5,-6)
store.Frame84.Size = UDim2.new(0,12,0,12)
store.Frame84.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame84.BackgroundTransparency = 0.5
store.Frame84.BorderSizePixel = 0
store.Frame84.Parent = store.Frame83

store["UICorner71"] = Instance.new("UICorner")
store.UICorner71.Name = "UICorner"
store.UICorner71.CornerRadius = UDim.new(1,0)
store.UICorner71.Parent = store.Frame84

store["TextButton38"] = Instance.new("TextButton")
store.TextButton38.Name = "TextButton"
store.TextButton38.ZIndex = 8
store.TextButton38.Size = UDim2.new(1,0,1,0)
store.TextButton38.BackgroundTransparency = 1
store.TextButton38.Text = ""
store.TextButton38.Parent = store.Frame81

store["PressPop8"] = Instance.new("UIScale")
store.PressPop8.Name = "PressPop"
store.PressPop8.Parent = store.Frame81

store["Frame85"] = Instance.new("Frame")
store.Frame85.Name = "Frame"
store.Frame85.ZIndex = 4
store.Frame85.LayoutOrder = 58
store.Frame85.Size = UDim2.new(1,0,0,40)
store.Frame85.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame85.BackgroundTransparency = 0.5
store.Frame85.BorderSizePixel = 0
store.Frame85.Parent = store.Page_Movement

store["UICorner72"] = Instance.new("UICorner")
store.UICorner72.Name = "UICorner"
store.UICorner72.CornerRadius = UDim.new(0,10)
store.UICorner72.Parent = store.Frame85

store["UIStroke46"] = Instance.new("UIStroke")
store.UIStroke46.Name = "UIStroke"
store.UIStroke46.Color = Color3.fromRGB(28,28,34)
store.UIStroke46.Parent = store.Frame85

store["TextLabel36"] = Instance.new("TextLabel")
store.TextLabel36.Name = "TextLabel"
store.TextLabel36.ZIndex = 5
store.TextLabel36.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel36.Size = UDim2.new(0.6,0,0,16)
store.TextLabel36.BackgroundTransparency = 1
store.TextLabel36.Text = "Body Lock"
store.TextLabel36.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel36.TextSize = 11
store.TextLabel36.Font = Enum.Font.GothamBold
store.TextLabel36.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel36.Parent = store.Frame85

store["Frame86"] = Instance.new("Frame")
store.Frame86.Name = "Frame"
store.Frame86.Visible = false
store.Frame86.ZIndex = 5
store.Frame86.Position = UDim2.new(0,12,0.5,7)
store.Frame86.Size = UDim2.new(0,51,0,1)
store.Frame86.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame86.BackgroundTransparency = 0.5
store.Frame86.BorderSizePixel = 0
store.Frame86.Parent = store.Frame85

store["Frame87"] = Instance.new("Frame")
store.Frame87.Name = "Frame"
store.Frame87.ZIndex = 6
store.Frame87.Position = UDim2.new(1,-44,0.5,-8)
store.Frame87.Size = UDim2.new(0,32,0,16)
store.Frame87.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame87.BackgroundTransparency = 0.5
store.Frame87.BorderSizePixel = 0
store.Frame87.Parent = store.Frame85

store["UICorner73"] = Instance.new("UICorner")
store.UICorner73.Name = "UICorner"
store.UICorner73.CornerRadius = UDim.new(1,0)
store.UICorner73.Parent = store.Frame87

store["UIStroke47"] = Instance.new("UIStroke")
store.UIStroke47.Name = "UIStroke"
store.UIStroke47.Color = Color3.fromRGB(70,70,70)
store.UIStroke47.Transparency = 0.5
store.UIStroke47.Parent = store.Frame87

store["Frame88"] = Instance.new("Frame")
store.Frame88.Name = "Frame"
store.Frame88.ZIndex = 7
store.Frame88.Position = UDim2.new(0,2,0.5,-6)
store.Frame88.Size = UDim2.new(0,12,0,12)
store.Frame88.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame88.BackgroundTransparency = 0.5
store.Frame88.BorderSizePixel = 0
store.Frame88.Parent = store.Frame87

store["UICorner74"] = Instance.new("UICorner")
store.UICorner74.Name = "UICorner"
store.UICorner74.CornerRadius = UDim.new(1,0)
store.UICorner74.Parent = store.Frame88

store["TextButton39"] = Instance.new("TextButton")
store.TextButton39.Name = "TextButton"
store.TextButton39.ZIndex = 8
store.TextButton39.Size = UDim2.new(1,0,1,0)
store.TextButton39.BackgroundTransparency = 1
store.TextButton39.Text = ""
store.TextButton39.Parent = store.Frame85

store["PressPop9"] = Instance.new("UIScale")
store.PressPop9.Name = "PressPop"
store.PressPop9.Parent = store.Frame85

store["TextButton40"] = Instance.new("TextButton")
store.TextButton40.Name = "TextButton"
store.TextButton40.ZIndex = 12
store.TextButton40.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton40.Size = UDim2.new(0,32,0,22)
store.TextButton40.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton40.BackgroundTransparency = 0.5
store.TextButton40.BorderSizePixel = 0
store.TextButton40.Text = ""
store.TextButton40.AutoButtonColor = false
store.TextButton40.Parent = store.Frame85

store["UICorner75"] = Instance.new("UICorner")
store.UICorner75.Name = "UICorner"
store.UICorner75.CornerRadius = UDim.new(0,6)
store.UICorner75.Parent = store.TextButton40

store["UIStroke48"] = Instance.new("UIStroke")
store.UIStroke48.Name = "UIStroke"
store.UIStroke48.Color = Color3.fromRGB(254,254,254)
store.UIStroke48.Thickness = 1.4
store.UIStroke48.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke48.Transparency = 0.25
store.UIStroke48.Parent = store.TextButton40

store["UIGradient18"] = Instance.new("UIGradient")
store.UIGradient18.Name = "UIGradient"
store.UIGradient18.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient18.Parent = store.UIStroke48

store["TextLabel37"] = Instance.new("TextLabel")
store.TextLabel37.Name = "TextLabel"
store.TextLabel37.ZIndex = 20
store.TextLabel37.Size = UDim2.new(1,0,1,0)
store.TextLabel37.BackgroundTransparency = 1
store.TextLabel37.Text = "▼"
store.TextLabel37.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel37.TextSize = 15
store.TextLabel37.Font = Enum.Font.GothamBlack
store.TextLabel37.Parent = store.TextButton40

store["Frame89"] = Instance.new("Frame")
store.Frame89.Name = "Frame"
store.Frame89.Visible = false
store.Frame89.ZIndex = 4
store.Frame89.LayoutOrder = 59
store.Frame89.Size = UDim2.new(1,0,0,40)
store.Frame89.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame89.BackgroundTransparency = 0.5
store.Frame89.BorderSizePixel = 0
store.Frame89.Parent = store.Page_Movement

store["UICorner76"] = Instance.new("UICorner")
store.UICorner76.Name = "UICorner"
store.UICorner76.CornerRadius = UDim.new(0,10)
store.UICorner76.Parent = store.Frame89

store["UIStroke49"] = Instance.new("UIStroke")
store.UIStroke49.Name = "UIStroke"
store.UIStroke49.Color = Color3.fromRGB(28,28,34)
store.UIStroke49.Parent = store.Frame89

store["TextLabel38"] = Instance.new("TextLabel")
store.TextLabel38.Name = "TextLabel"
store.TextLabel38.ZIndex = 5
store.TextLabel38.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel38.Size = UDim2.new(0.6,0,0,16)
store.TextLabel38.BackgroundTransparency = 1
store.TextLabel38.Text = "Lock Range"
store.TextLabel38.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel38.TextSize = 11
store.TextLabel38.Font = Enum.Font.GothamBold
store.TextLabel38.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel38.Parent = store.Frame89

store["Frame90"] = Instance.new("Frame")
store.Frame90.Name = "Frame"
store.Frame90.Visible = false
store.Frame90.ZIndex = 5
store.Frame90.Position = UDim2.new(0,12,0.5,7)
store.Frame90.Size = UDim2.new(0,57,0,1)
store.Frame90.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame90.BackgroundTransparency = 0.5
store.Frame90.BorderSizePixel = 0
store.Frame90.Parent = store.Frame89

store["Frame91"] = Instance.new("Frame")
store.Frame91.Name = "Frame"
store.Frame91.ZIndex = 6
store.Frame91.Position = UDim2.new(1,-54,0.5,-11)
store.Frame91.Size = UDim2.new(0,46,0,22)
store.Frame91.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame91.BackgroundTransparency = 0.5
store.Frame91.BorderSizePixel = 0
store.Frame91.Parent = store.Frame89

store["UICorner77"] = Instance.new("UICorner")
store.UICorner77.Name = "UICorner"
store.UICorner77.Parent = store.Frame91

store["UIStroke50"] = Instance.new("UIStroke")
store.UIStroke50.Name = "UIStroke"
store.UIStroke50.Color = Color3.fromRGB(254,254,254)
store.UIStroke50.Thickness = 1.4
store.UIStroke50.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke50.Transparency = 0.25
store.UIStroke50.Parent = store.Frame91

store["UIGradient19"] = Instance.new("UIGradient")
store.UIGradient19.Name = "UIGradient"
store.UIGradient19.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient19.Parent = store.UIStroke50

store["TextBox11"] = Instance.new("TextBox")
store.TextBox11.Name = "TextBox"
store.TextBox11.ZIndex = 7
store.TextBox11.Size = UDim2.new(1,0,1,0)
store.TextBox11.BackgroundTransparency = 1
store.TextBox11.Text = "15"
store.TextBox11.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox11.TextSize = 11
store.TextBox11.Font = Enum.Font.GothamBold
store.TextBox11.ClearTextOnFocus = false
store.TextBox11.Parent = store.Frame91

store["Frame92"] = Instance.new("Frame")
store.Frame92.Name = "Frame"
store.Frame92.ZIndex = 4
store.Frame92.LayoutOrder = 66
store.Frame92.Size = UDim2.new(1,0,0,40)
store.Frame92.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame92.BackgroundTransparency = 0.5
store.Frame92.BorderSizePixel = 0
store.Frame92.Parent = store.Page_Movement

store["UICorner78"] = Instance.new("UICorner")
store.UICorner78.Name = "UICorner"
store.UICorner78.CornerRadius = UDim.new(0,10)
store.UICorner78.Parent = store.Frame92

store["UIStroke51"] = Instance.new("UIStroke")
store.UIStroke51.Name = "UIStroke"
store.UIStroke51.Color = Color3.fromRGB(28,28,34)
store.UIStroke51.Parent = store.Frame92

store["TextLabel39"] = Instance.new("TextLabel")
store.TextLabel39.Name = "TextLabel"
store.TextLabel39.ZIndex = 5
store.TextLabel39.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel39.Size = UDim2.new(0.6,0,0,16)
store.TextLabel39.BackgroundTransparency = 1
store.TextLabel39.Text = "Safe Mode"
store.TextLabel39.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel39.TextSize = 11
store.TextLabel39.Font = Enum.Font.GothamBold
store.TextLabel39.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel39.Parent = store.Frame92

store["Frame93"] = Instance.new("Frame")
store.Frame93.Name = "Frame"
store.Frame93.Visible = false
store.Frame93.ZIndex = 5
store.Frame93.Position = UDim2.new(0,12,0.5,7)
store.Frame93.Size = UDim2.new(0,52,0,1)
store.Frame93.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame93.BackgroundTransparency = 0.5
store.Frame93.BorderSizePixel = 0
store.Frame93.Parent = store.Frame92

store["Frame94"] = Instance.new("Frame")
store.Frame94.Name = "Frame"
store.Frame94.ZIndex = 6
store.Frame94.Position = UDim2.new(1,-44,0.5,-8)
store.Frame94.Size = UDim2.new(0,32,0,16)
store.Frame94.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame94.BackgroundTransparency = 0.5
store.Frame94.BorderSizePixel = 0
store.Frame94.Parent = store.Frame92

store["UICorner79"] = Instance.new("UICorner")
store.UICorner79.Name = "UICorner"
store.UICorner79.CornerRadius = UDim.new(1,0)
store.UICorner79.Parent = store.Frame94

store["UIStroke52"] = Instance.new("UIStroke")
store.UIStroke52.Name = "UIStroke"
store.UIStroke52.Color = Color3.fromRGB(70,70,70)
store.UIStroke52.Transparency = 0.5
store.UIStroke52.Parent = store.Frame94

store["Frame95"] = Instance.new("Frame")
store.Frame95.Name = "Frame"
store.Frame95.ZIndex = 7
store.Frame95.Position = UDim2.new(0,2,0.5,-6)
store.Frame95.Size = UDim2.new(0,12,0,12)
store.Frame95.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame95.BackgroundTransparency = 0.5
store.Frame95.BorderSizePixel = 0
store.Frame95.Parent = store.Frame94

store["UICorner80"] = Instance.new("UICorner")
store.UICorner80.Name = "UICorner"
store.UICorner80.CornerRadius = UDim.new(1,0)
store.UICorner80.Parent = store.Frame95

store["TextButton41"] = Instance.new("TextButton")
store.TextButton41.Name = "TextButton"
store.TextButton41.ZIndex = 8
store.TextButton41.Size = UDim2.new(1,0,1,0)
store.TextButton41.BackgroundTransparency = 1
store.TextButton41.Text = ""
store.TextButton41.Parent = store.Frame92

store["PressPop10"] = Instance.new("UIScale")
store.PressPop10.Name = "PressPop"
store.PressPop10.Parent = store.Frame92

store["Frame96"] = Instance.new("Frame")
store.Frame96.Name = "Frame"
store.Frame96.Visible = false
store.Frame96.ZIndex = 4
store.Frame96.LayoutOrder = 22
store.Frame96.Size = UDim2.new(1,0,0,34)
store.Frame96.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame96.BackgroundTransparency = 0.5
store.Frame96.BorderSizePixel = 0
store.Frame96.Parent = store.Page_Movement

store["UICorner81"] = Instance.new("UICorner")
store.UICorner81.Name = "UICorner"
store.UICorner81.CornerRadius = UDim.new(0,12)
store.UICorner81.Parent = store.Frame96

store["UIStroke53"] = Instance.new("UIStroke")
store.UIStroke53.Name = "UIStroke"
store.UIStroke53.Color = Color3.fromRGB(35,35,45)
store.UIStroke53.Transparency = 0.4
store.UIStroke53.Parent = store.Frame96

store["TextLabel40"] = Instance.new("TextLabel")
store.TextLabel40.Name = "TextLabel"
store.TextLabel40.ZIndex = 5
store.TextLabel40.Position = UDim2.new(0,12,0,0)
store.TextLabel40.Size = UDim2.new(0,110,1,0)
store.TextLabel40.BackgroundTransparency = 1
store.TextLabel40.Text = "Aimbot Mode"
store.TextLabel40.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel40.TextSize = 10
store.TextLabel40.Font = Enum.Font.GothamBold
store.TextLabel40.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel40.Parent = store.Frame96

store["UIStroke54"] = Instance.new("UIStroke")
store.UIStroke54.Name = "UIStroke"
store.UIStroke54.Transparency = 1
store.UIStroke54.Parent = store.TextLabel40

store["Frame97"] = Instance.new("Frame")
store.Frame97.Name = "Frame"
store.Frame97.Visible = false
store.Frame97.ZIndex = 5
store.Frame97.Position = UDim2.new(0,0,0.5,9)
store.Frame97.Size = UDim2.new(0,61,0,1)
store.Frame97.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame97.BackgroundTransparency = 0.5
store.Frame97.BorderSizePixel = 0
store.Frame97.Parent = store.TextLabel40

store["TextButton42"] = Instance.new("TextButton")
store.TextButton42.Name = "TextButton"
store.TextButton42.ZIndex = 5
store.TextButton42.Position = UDim2.new(1,-142,0.5,-12)
store.TextButton42.Size = UDim2.new(0,62,0,24)
store.TextButton42.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton42.BackgroundTransparency = 0.5
store.TextButton42.BorderSizePixel = 0
store.TextButton42.Text = "Normal"
store.TextButton42.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton42.TextSize = 10
store.TextButton42.Font = Enum.Font.GothamBold
store.TextButton42.AutoButtonColor = false
store.TextButton42.Parent = store.Frame96

store["UICorner82"] = Instance.new("UICorner")
store.UICorner82.Name = "UICorner"
store.UICorner82.Parent = store.TextButton42

store["TextButton43"] = Instance.new("TextButton")
store.TextButton43.Name = "TextButton"
store.TextButton43.ZIndex = 5
store.TextButton43.Position = UDim2.new(1,-74,0.5,-12)
store.TextButton43.Size = UDim2.new(0,62,0,24)
store.TextButton43.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton43.BackgroundTransparency = 0.5
store.TextButton43.BorderSizePixel = 0
store.TextButton43.Text = "Bypass"
store.TextButton43.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton43.TextSize = 10
store.TextButton43.Font = Enum.Font.GothamBold
store.TextButton43.AutoButtonColor = false
store.TextButton43.Parent = store.Frame96

store["UICorner83"] = Instance.new("UICorner")
store.UICorner83.Name = "UICorner"
store.UICorner83.Parent = store.TextButton43

store["Frame98"] = Instance.new("Frame")
store.Frame98.Name = "Frame"
store.Frame98.Visible = false
store.Frame98.ZIndex = 4
store.Frame98.LayoutOrder = 59
store.Frame98.Size = UDim2.new(1,0,0,34)
store.Frame98.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame98.BackgroundTransparency = 0.5
store.Frame98.BorderSizePixel = 0
store.Frame98.Parent = store.Page_Movement

store["UICorner84"] = Instance.new("UICorner")
store.UICorner84.Name = "UICorner"
store.UICorner84.CornerRadius = UDim.new(0,12)
store.UICorner84.Parent = store.Frame98

store["UIStroke55"] = Instance.new("UIStroke")
store.UIStroke55.Name = "UIStroke"
store.UIStroke55.Color = Color3.fromRGB(35,35,45)
store.UIStroke55.Transparency = 0.4
store.UIStroke55.Parent = store.Frame98

store["TextLabel41"] = Instance.new("TextLabel")
store.TextLabel41.Name = "TextLabel"
store.TextLabel41.ZIndex = 5
store.TextLabel41.Position = UDim2.new(0,12,0,0)
store.TextLabel41.Size = UDim2.new(0.55,0,1,0)
store.TextLabel41.BackgroundTransparency = 1
store.TextLabel41.Text = "Rotate Lock Range"
store.TextLabel41.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel41.TextSize = 11
store.TextLabel41.Font = Enum.Font.GothamBold
store.TextLabel41.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel41.Parent = store.Frame98

store["TextBox12"] = Instance.new("TextBox")
store.TextBox12.Name = "TextBox"
store.TextBox12.ZIndex = 5
store.TextBox12.Position = UDim2.new(1,-82,0.5,-12)
store.TextBox12.Size = UDim2.new(0,70,0,24)
store.TextBox12.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextBox12.BorderSizePixel = 0
store.TextBox12.Text = "50"
store.TextBox12.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox12.TextSize = 12
store.TextBox12.Font = Enum.Font.GothamBold
store.TextBox12.PlaceholderText = "50"
store.TextBox12.ClearTextOnFocus = false
store.TextBox12.Parent = store.Frame98

store["UICorner85"] = Instance.new("UICorner")
store.UICorner85.Name = "UICorner"
store.UICorner85.Parent = store.TextBox12

store["UIStroke56"] = Instance.new("UIStroke")
store.UIStroke56.Name = "UIStroke"
store.UIStroke56.Color = Color3.fromRGB(254,254,254)
store.UIStroke56.Thickness = 1.4
store.UIStroke56.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke56.Transparency = 0.25
store.UIStroke56.Parent = store.TextBox12

store["UIGradient20"] = Instance.new("UIGradient")
store.UIGradient20.Name = "UIGradient"
store.UIGradient20.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient20.Parent = store.UIStroke56

store["Frame99"] = Instance.new("Frame")
store.Frame99.Name = "Frame"
store.Frame99.LayoutOrder = 1
store.Frame99.Size = UDim2.new(1,0,0,42)
store.Frame99.BackgroundTransparency = 1
store.Frame99.BorderSizePixel = 0
store.Frame99.Parent = store.Page_Movement

store["TextLabel42"] = Instance.new("TextLabel")
store.TextLabel42.Name = "TextLabel"
store.TextLabel42.ZIndex = 4
store.TextLabel42.Position = UDim2.new(0,0,0,20)
store.TextLabel42.Size = UDim2.new(1,0,0,16)
store.TextLabel42.BackgroundTransparency = 1
store.TextLabel42.Text = "MOVEMENT CONFIGURATION"
store.TextLabel42.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel42.TextSize = 12
store.TextLabel42.Font = Enum.Font.GothamBlack
store.TextLabel42.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel42.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel42.Parent = store.Frame99

store["Frame100"] = Instance.new("Frame")
store.Frame100.Name = "Frame"
store.Frame100.ZIndex = 3
store.Frame100.Position = UDim2.new(0,0,0,38)
store.Frame100.Size = UDim2.new(1,0,0,1)
store.Frame100.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame100.BackgroundTransparency = 0.85
store.Frame100.BorderSizePixel = 0
store.Frame100.Parent = store.Frame99

store["Frame101"] = Instance.new("Frame")
store.Frame101.Name = "Frame"
store.Frame101.ZIndex = 4
store.Frame101.LayoutOrder = 10
store.Frame101.Size = UDim2.new(1,0,0,40)
store.Frame101.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame101.BackgroundTransparency = 0.5
store.Frame101.BorderSizePixel = 0
store.Frame101.Parent = store.Page_Movement

store["UICorner86"] = Instance.new("UICorner")
store.UICorner86.Name = "UICorner"
store.UICorner86.CornerRadius = UDim.new(0,10)
store.UICorner86.Parent = store.Frame101

store["UIStroke57"] = Instance.new("UIStroke")
store.UIStroke57.Name = "UIStroke"
store.UIStroke57.Color = Color3.fromRGB(28,28,34)
store.UIStroke57.Parent = store.Frame101

store["TextLabel43"] = Instance.new("TextLabel")
store.TextLabel43.Name = "TextLabel"
store.TextLabel43.ZIndex = 5
store.TextLabel43.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel43.Size = UDim2.new(0.6,0,0,16)
store.TextLabel43.BackgroundTransparency = 1
store.TextLabel43.Text = "Infinite Jump"
store.TextLabel43.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel43.TextSize = 11
store.TextLabel43.Font = Enum.Font.GothamBold
store.TextLabel43.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel43.Parent = store.Frame101

store["Frame102"] = Instance.new("Frame")
store.Frame102.Name = "Frame"
store.Frame102.Visible = false
store.Frame102.ZIndex = 5
store.Frame102.Position = UDim2.new(0,12,0.5,7)
store.Frame102.Size = UDim2.new(0,65,0,1)
store.Frame102.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame102.BackgroundTransparency = 0.5
store.Frame102.BorderSizePixel = 0
store.Frame102.Parent = store.Frame101

store["Frame103"] = Instance.new("Frame")
store.Frame103.Name = "Frame"
store.Frame103.ZIndex = 6
store.Frame103.Position = UDim2.new(1,-44,0.5,-8)
store.Frame103.Size = UDim2.new(0,32,0,16)
store.Frame103.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame103.BackgroundTransparency = 0.5
store.Frame103.BorderSizePixel = 0
store.Frame103.Parent = store.Frame101

store["UICorner87"] = Instance.new("UICorner")
store.UICorner87.Name = "UICorner"
store.UICorner87.CornerRadius = UDim.new(1,0)
store.UICorner87.Parent = store.Frame103

store["UIStroke58"] = Instance.new("UIStroke")
store.UIStroke58.Name = "UIStroke"
store.UIStroke58.Color = Color3.fromRGB(70,70,70)
store.UIStroke58.Transparency = 0.5
store.UIStroke58.Parent = store.Frame103

store["Frame104"] = Instance.new("Frame")
store.Frame104.Name = "Frame"
store.Frame104.ZIndex = 7
store.Frame104.Position = UDim2.new(0,2,0.5,-6)
store.Frame104.Size = UDim2.new(0,12,0,12)
store.Frame104.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame104.BackgroundTransparency = 0.5
store.Frame104.BorderSizePixel = 0
store.Frame104.Parent = store.Frame103

store["UICorner88"] = Instance.new("UICorner")
store.UICorner88.Name = "UICorner"
store.UICorner88.CornerRadius = UDim.new(1,0)
store.UICorner88.Parent = store.Frame104

store["TextButton44"] = Instance.new("TextButton")
store.TextButton44.Name = "TextButton"
store.TextButton44.ZIndex = 8
store.TextButton44.Size = UDim2.new(1,0,1,0)
store.TextButton44.BackgroundTransparency = 1
store.TextButton44.Text = ""
store.TextButton44.Parent = store.Frame101

store["PressPop11"] = Instance.new("UIScale")
store.PressPop11.Name = "PressPop"
store.PressPop11.Parent = store.Frame101

store["TextButton45"] = Instance.new("TextButton")
store.TextButton45.Name = "TextButton"
store.TextButton45.ZIndex = 12
store.TextButton45.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton45.Size = UDim2.new(0,32,0,22)
store.TextButton45.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton45.BackgroundTransparency = 0.5
store.TextButton45.BorderSizePixel = 0
store.TextButton45.Text = ""
store.TextButton45.AutoButtonColor = false
store.TextButton45.Parent = store.Frame101

store["UICorner89"] = Instance.new("UICorner")
store.UICorner89.Name = "UICorner"
store.UICorner89.CornerRadius = UDim.new(0,6)
store.UICorner89.Parent = store.TextButton45

store["UIStroke59"] = Instance.new("UIStroke")
store.UIStroke59.Name = "UIStroke"
store.UIStroke59.Color = Color3.fromRGB(254,254,254)
store.UIStroke59.Thickness = 1.4
store.UIStroke59.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke59.Transparency = 0.25
store.UIStroke59.Parent = store.TextButton45

store["UIGradient21"] = Instance.new("UIGradient")
store.UIGradient21.Name = "UIGradient"
store.UIGradient21.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient21.Parent = store.UIStroke59

store["TextLabel44"] = Instance.new("TextLabel")
store.TextLabel44.Name = "TextLabel"
store.TextLabel44.ZIndex = 20
store.TextLabel44.Size = UDim2.new(1,0,1,0)
store.TextLabel44.BackgroundTransparency = 1
store.TextLabel44.Text = "▼"
store.TextLabel44.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel44.TextSize = 15
store.TextLabel44.Font = Enum.Font.GothamBlack
store.TextLabel44.Parent = store.TextButton45

store["DropdownPanel3"] = Instance.new("Frame")
store.DropdownPanel3.Name = "DropdownPanel"
store.DropdownPanel3.Visible = false
store.DropdownPanel3.ZIndex = 4
store.DropdownPanel3.LayoutOrder = 11
store.DropdownPanel3.Size = UDim2.new(1,0,0,34)
store.DropdownPanel3.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.DropdownPanel3.BackgroundTransparency = 0.5
store.DropdownPanel3.BorderSizePixel = 0
store.DropdownPanel3.Parent = store.Page_Movement

store["UICorner90"] = Instance.new("UICorner")
store.UICorner90.Name = "UICorner"
store.UICorner90.CornerRadius = UDim.new(0,12)
store.UICorner90.Parent = store.DropdownPanel3

store["UIStroke60"] = Instance.new("UIStroke")
store.UIStroke60.Name = "UIStroke"
store.UIStroke60.Color = Color3.fromRGB(254,254,254)
store.UIStroke60.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke60.Transparency = 0.5
store.UIStroke60.Parent = store.DropdownPanel3

store["TextLabel45"] = Instance.new("TextLabel")
store.TextLabel45.Name = "TextLabel"
store.TextLabel45.ZIndex = 5
store.TextLabel45.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel45.Size = UDim2.new(0.5,0,0,16)
store.TextLabel45.BackgroundTransparency = 1
store.TextLabel45.Text = "Jump Mode"
store.TextLabel45.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel45.TextSize = 11
store.TextLabel45.Font = Enum.Font.GothamBold
store.TextLabel45.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel45.Parent = store.DropdownPanel3

store["Frame105"] = Instance.new("Frame")
store.Frame105.Name = "Frame"
store.Frame105.Visible = false
store.Frame105.ZIndex = 5
store.Frame105.Position = UDim2.new(0,12,0.5,7)
store.Frame105.Size = UDim2.new(0,58,0,1)
store.Frame105.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame105.BackgroundTransparency = 0.5
store.Frame105.BorderSizePixel = 0
store.Frame105.Parent = store.DropdownPanel3

store["TextButton46"] = Instance.new("TextButton")
store.TextButton46.Name = "TextButton"
store.TextButton46.ZIndex = 5
store.TextButton46.Position = UDim2.new(1,-174,0,5)
store.TextButton46.Size = UDim2.new(0,78,0,24)
store.TextButton46.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton46.BackgroundTransparency = 0.5
store.TextButton46.BorderSizePixel = 0
store.TextButton46.Text = "Single"
store.TextButton46.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton46.TextSize = 10
store.TextButton46.Font = Enum.Font.GothamBold
store.TextButton46.AutoButtonColor = false
store.TextButton46.Parent = store.DropdownPanel3

store["UICorner91"] = Instance.new("UICorner")
store.UICorner91.Name = "UICorner"
store.UICorner91.Parent = store.TextButton46

store["TextButton47"] = Instance.new("TextButton")
store.TextButton47.Name = "TextButton"
store.TextButton47.ZIndex = 5
store.TextButton47.Position = UDim2.new(1,-90,0,5)
store.TextButton47.Size = UDim2.new(0,78,0,24)
store.TextButton47.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton47.BackgroundTransparency = 0.5
store.TextButton47.BorderSizePixel = 0
store.TextButton47.Text = "Hold"
store.TextButton47.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton47.TextSize = 10
store.TextButton47.Font = Enum.Font.GothamBold
store.TextButton47.AutoButtonColor = false
store.TextButton47.Parent = store.DropdownPanel3

store["UICorner92"] = Instance.new("UICorner")
store.UICorner92.Name = "UICorner"
store.UICorner92.Parent = store.TextButton47

store["Frame106"] = Instance.new("Frame")
store.Frame106.Name = "Frame"
store.Frame106.ZIndex = 4
store.Frame106.LayoutOrder = 12
store.Frame106.Size = UDim2.new(1,0,0,40)
store.Frame106.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame106.BackgroundTransparency = 0.5
store.Frame106.BorderSizePixel = 0
store.Frame106.Parent = store.Page_Movement

store["UICorner93"] = Instance.new("UICorner")
store.UICorner93.Name = "UICorner"
store.UICorner93.CornerRadius = UDim.new(0,10)
store.UICorner93.Parent = store.Frame106

store["UIStroke61"] = Instance.new("UIStroke")
store.UIStroke61.Name = "UIStroke"
store.UIStroke61.Color = Color3.fromRGB(28,28,34)
store.UIStroke61.Parent = store.Frame106

store["TextLabel46"] = Instance.new("TextLabel")
store.TextLabel46.Name = "TextLabel"
store.TextLabel46.ZIndex = 5
store.TextLabel46.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel46.Size = UDim2.new(0.6,0,0,16)
store.TextLabel46.BackgroundTransparency = 1
store.TextLabel46.Text = "Anti Ragdoll"
store.TextLabel46.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel46.TextSize = 11
store.TextLabel46.Font = Enum.Font.GothamBold
store.TextLabel46.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel46.Parent = store.Frame106

store["Frame107"] = Instance.new("Frame")
store.Frame107.Name = "Frame"
store.Frame107.Visible = false
store.Frame107.ZIndex = 5
store.Frame107.Position = UDim2.new(0,12,0.5,7)
store.Frame107.Size = UDim2.new(0,60,0,1)
store.Frame107.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame107.BackgroundTransparency = 0.5
store.Frame107.BorderSizePixel = 0
store.Frame107.Parent = store.Frame106

store["Frame108"] = Instance.new("Frame")
store.Frame108.Name = "Frame"
store.Frame108.ZIndex = 6
store.Frame108.Position = UDim2.new(1,-44,0.5,-8)
store.Frame108.Size = UDim2.new(0,32,0,16)
store.Frame108.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame108.BackgroundTransparency = 0.5
store.Frame108.BorderSizePixel = 0
store.Frame108.Parent = store.Frame106

store["UICorner94"] = Instance.new("UICorner")
store.UICorner94.Name = "UICorner"
store.UICorner94.CornerRadius = UDim.new(1,0)
store.UICorner94.Parent = store.Frame108

store["UIStroke62"] = Instance.new("UIStroke")
store.UIStroke62.Name = "UIStroke"
store.UIStroke62.Color = Color3.fromRGB(70,70,70)
store.UIStroke62.Transparency = 0.5
store.UIStroke62.Parent = store.Frame108

store["Frame109"] = Instance.new("Frame")
store.Frame109.Name = "Frame"
store.Frame109.ZIndex = 7
store.Frame109.Position = UDim2.new(0,2,0.5,-6)
store.Frame109.Size = UDim2.new(0,12,0,12)
store.Frame109.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame109.BackgroundTransparency = 0.5
store.Frame109.BorderSizePixel = 0
store.Frame109.Parent = store.Frame108

store["UICorner95"] = Instance.new("UICorner")
store.UICorner95.Name = "UICorner"
store.UICorner95.CornerRadius = UDim.new(1,0)
store.UICorner95.Parent = store.Frame109

store["TextButton48"] = Instance.new("TextButton")
store.TextButton48.Name = "TextButton"
store.TextButton48.ZIndex = 8
store.TextButton48.Size = UDim2.new(1,0,1,0)
store.TextButton48.BackgroundTransparency = 1
store.TextButton48.Text = ""
store.TextButton48.Parent = store.Frame106

store["PressPop12"] = Instance.new("UIScale")
store.PressPop12.Name = "PressPop"
store.PressPop12.Parent = store.Frame106

store["TextButton49"] = Instance.new("TextButton")
store.TextButton49.Name = "TextButton"
store.TextButton49.ZIndex = 12
store.TextButton49.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton49.Size = UDim2.new(0,32,0,22)
store.TextButton49.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton49.BackgroundTransparency = 0.5
store.TextButton49.BorderSizePixel = 0
store.TextButton49.Text = ""
store.TextButton49.AutoButtonColor = false
store.TextButton49.Parent = store.Frame106

store["UICorner96"] = Instance.new("UICorner")
store.UICorner96.Name = "UICorner"
store.UICorner96.CornerRadius = UDim.new(0,6)
store.UICorner96.Parent = store.TextButton49

store["UIStroke63"] = Instance.new("UIStroke")
store.UIStroke63.Name = "UIStroke"
store.UIStroke63.Color = Color3.fromRGB(254,254,254)
store.UIStroke63.Thickness = 1.4
store.UIStroke63.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke63.Transparency = 0.25
store.UIStroke63.Parent = store.TextButton49

store["UIGradient22"] = Instance.new("UIGradient")
store.UIGradient22.Name = "UIGradient"
store.UIGradient22.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient22.Parent = store.UIStroke63

store["TextLabel47"] = Instance.new("TextLabel")
store.TextLabel47.Name = "TextLabel"
store.TextLabel47.ZIndex = 20
store.TextLabel47.Size = UDim2.new(1,0,1,0)
store.TextLabel47.BackgroundTransparency = 1
store.TextLabel47.Text = "▼"
store.TextLabel47.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel47.TextSize = 15
store.TextLabel47.Font = Enum.Font.GothamBlack
store.TextLabel47.Parent = store.TextButton49

store["DropdownPanel4"] = Instance.new("Frame")
store.DropdownPanel4.Name = "DropdownPanel"
store.DropdownPanel4.Visible = false
store.DropdownPanel4.ZIndex = 4
store.DropdownPanel4.LayoutOrder = 13
store.DropdownPanel4.Size = UDim2.new(1,0,0,34)
store.DropdownPanel4.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.DropdownPanel4.BackgroundTransparency = 0.5
store.DropdownPanel4.BorderSizePixel = 0
store.DropdownPanel4.Parent = store.Page_Movement

store["UICorner97"] = Instance.new("UICorner")
store.UICorner97.Name = "UICorner"
store.UICorner97.CornerRadius = UDim.new(0,12)
store.UICorner97.Parent = store.DropdownPanel4

store["UIStroke64"] = Instance.new("UIStroke")
store.UIStroke64.Name = "UIStroke"
store.UIStroke64.Color = Color3.fromRGB(254,254,254)
store.UIStroke64.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke64.Transparency = 0.5
store.UIStroke64.Parent = store.DropdownPanel4

store["TextLabel48"] = Instance.new("TextLabel")
store.TextLabel48.Name = "TextLabel"
store.TextLabel48.ZIndex = 5
store.TextLabel48.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel48.Size = UDim2.new(0.5,0,0,16)
store.TextLabel48.BackgroundTransparency = 1
store.TextLabel48.Text = "Ragdoll Mode"
store.TextLabel48.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel48.TextSize = 11
store.TextLabel48.Font = Enum.Font.GothamBold
store.TextLabel48.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel48.Parent = store.DropdownPanel4

store["Frame110"] = Instance.new("Frame")
store.Frame110.Name = "Frame"
store.Frame110.Visible = false
store.Frame110.ZIndex = 5
store.Frame110.Position = UDim2.new(0,12,0.5,7)
store.Frame110.Size = UDim2.new(0,67,0,1)
store.Frame110.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame110.BackgroundTransparency = 0.5
store.Frame110.BorderSizePixel = 0
store.Frame110.Parent = store.DropdownPanel4

store["TextButton50"] = Instance.new("TextButton")
store.TextButton50.Name = "TextButton"
store.TextButton50.ZIndex = 5
store.TextButton50.Position = UDim2.new(1,-174,0,5)
store.TextButton50.Size = UDim2.new(0,78,0,24)
store.TextButton50.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton50.BackgroundTransparency = 0.5
store.TextButton50.BorderSizePixel = 0
store.TextButton50.Text = "V1"
store.TextButton50.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton50.TextSize = 10
store.TextButton50.Font = Enum.Font.GothamBold
store.TextButton50.AutoButtonColor = false
store.TextButton50.Parent = store.DropdownPanel4

store["UICorner98"] = Instance.new("UICorner")
store.UICorner98.Name = "UICorner"
store.UICorner98.Parent = store.TextButton50

store["TextButton51"] = Instance.new("TextButton")
store.TextButton51.Name = "TextButton"
store.TextButton51.ZIndex = 5
store.TextButton51.Position = UDim2.new(1,-90,0,5)
store.TextButton51.Size = UDim2.new(0,78,0,24)
store.TextButton51.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton51.BackgroundTransparency = 0.5
store.TextButton51.BorderSizePixel = 0
store.TextButton51.Text = "V2"
store.TextButton51.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton51.TextSize = 10
store.TextButton51.Font = Enum.Font.GothamBold
store.TextButton51.AutoButtonColor = false
store.TextButton51.Parent = store.DropdownPanel4

store["UICorner99"] = Instance.new("UICorner")
store.UICorner99.Name = "UICorner"
store.UICorner99.Parent = store.TextButton51

store["Frame111"] = Instance.new("Frame")
store.Frame111.Name = "Frame"
store.Frame111.ZIndex = 4
store.Frame111.LayoutOrder = 14
store.Frame111.Size = UDim2.new(1,0,0,62)
store.Frame111.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame111.BackgroundTransparency = 0.5
store.Frame111.BorderSizePixel = 0
store.Frame111.Parent = store.Page_Movement

store["UICorner100"] = Instance.new("UICorner")
store.UICorner100.Name = "UICorner"
store.UICorner100.CornerRadius = UDim.new(0,12)
store.UICorner100.Parent = store.Frame111

store["UIStroke65"] = Instance.new("UIStroke")
store.UIStroke65.Name = "UIStroke"
store.UIStroke65.Color = Color3.fromRGB(35,35,45)
store.UIStroke65.Transparency = 0.4
store.UIStroke65.Parent = store.Frame111

store["TextLabel49"] = Instance.new("TextLabel")
store.TextLabel49.Name = "TextLabel"
store.TextLabel49.ZIndex = 5
store.TextLabel49.Position = UDim2.new(0,12,0,8)
store.TextLabel49.Size = UDim2.new(0.7,0,0,16)
store.TextLabel49.BackgroundTransparency = 1
store.TextLabel49.Text = "Anim Pack"
store.TextLabel49.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel49.TextSize = 11
store.TextLabel49.Font = Enum.Font.GothamBold
store.TextLabel49.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel49.Parent = store.Frame111

store["Frame112"] = Instance.new("Frame")
store.Frame112.Name = "Frame"
store.Frame112.Visible = false
store.Frame112.ZIndex = 5
store.Frame112.Position = UDim2.new(0,12,0,26)
store.Frame112.Size = UDim2.new(0,52,0,1)
store.Frame112.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame112.BackgroundTransparency = 0.5
store.Frame112.BorderSizePixel = 0
store.Frame112.Parent = store.Frame111

store["TextLabel50"] = Instance.new("TextLabel")
store.TextLabel50.Name = "TextLabel"
store.TextLabel50.ZIndex = 6
store.TextLabel50.Position = UDim2.new(0,54,1,-34)
store.TextLabel50.Size = UDim2.new(1,-108,0,26)
store.TextLabel50.BackgroundTransparency = 1
store.TextLabel50.Text = "OFF"
store.TextLabel50.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel50.TextSize = 11
store.TextLabel50.Font = Enum.Font.GothamBold
store.TextLabel50.Parent = store.Frame111

store["TextButton52"] = Instance.new("TextButton")
store.TextButton52.Name = "TextButton"
store.TextButton52.ZIndex = 7
store.TextButton52.Position = UDim2.new(0,12,1,-34)
store.TextButton52.Size = UDim2.new(0,34,0,26)
store.TextButton52.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton52.BackgroundTransparency = 0.5
store.TextButton52.BorderSizePixel = 0
store.TextButton52.Text = "<"
store.TextButton52.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton52.TextSize = 13
store.TextButton52.Font = Enum.Font.GothamBlack
store.TextButton52.AutoButtonColor = false
store.TextButton52.Parent = store.Frame111

store["UICorner101"] = Instance.new("UICorner")
store.UICorner101.Name = "UICorner"
store.UICorner101.Parent = store.TextButton52

store["UIStroke66"] = Instance.new("UIStroke")
store.UIStroke66.Name = "UIStroke"
store.UIStroke66.Color = Color3.fromRGB(254,254,254)
store.UIStroke66.Thickness = 1.4
store.UIStroke66.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke66.Transparency = 0.25
store.UIStroke66.Parent = store.TextButton52

store["UIGradient23"] = Instance.new("UIGradient")
store.UIGradient23.Name = "UIGradient"
store.UIGradient23.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient23.Parent = store.UIStroke66

store["TextButton53"] = Instance.new("TextButton")
store.TextButton53.Name = "TextButton"
store.TextButton53.ZIndex = 7
store.TextButton53.Position = UDim2.new(1,-46,1,-34)
store.TextButton53.Size = UDim2.new(0,34,0,26)
store.TextButton53.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton53.BackgroundTransparency = 0.5
store.TextButton53.BorderSizePixel = 0
store.TextButton53.Text = ">"
store.TextButton53.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton53.TextSize = 13
store.TextButton53.Font = Enum.Font.GothamBlack
store.TextButton53.AutoButtonColor = false
store.TextButton53.Parent = store.Frame111

store["UICorner102"] = Instance.new("UICorner")
store.UICorner102.Name = "UICorner"
store.UICorner102.Parent = store.TextButton53

store["UIStroke67"] = Instance.new("UIStroke")
store.UIStroke67.Name = "UIStroke"
store.UIStroke67.Color = Color3.fromRGB(254,254,254)
store.UIStroke67.Thickness = 1.4
store.UIStroke67.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke67.Transparency = 0.25
store.UIStroke67.Parent = store.TextButton53

store["UIGradient24"] = Instance.new("UIGradient")
store.UIGradient24.Name = "UIGradient"
store.UIGradient24.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient24.Parent = store.UIStroke67

store["Frame113"] = Instance.new("Frame")
store.Frame113.Name = "Frame"
store.Frame113.LayoutOrder = 40
store.Frame113.Size = UDim2.new(1,0,0,42)
store.Frame113.BackgroundTransparency = 1
store.Frame113.BorderSizePixel = 0
store.Frame113.Parent = store.Page_Movement

store["TextLabel51"] = Instance.new("TextLabel")
store.TextLabel51.Name = "TextLabel"
store.TextLabel51.ZIndex = 4
store.TextLabel51.Position = UDim2.new(0,0,0,20)
store.TextLabel51.Size = UDim2.new(1,0,0,16)
store.TextLabel51.BackgroundTransparency = 1
store.TextLabel51.Text = "UTILITIES CONFIGURATION"
store.TextLabel51.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel51.TextSize = 12
store.TextLabel51.Font = Enum.Font.GothamBlack
store.TextLabel51.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel51.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel51.Parent = store.Frame113

store["Frame114"] = Instance.new("Frame")
store.Frame114.Name = "Frame"
store.Frame114.ZIndex = 3
store.Frame114.Position = UDim2.new(0,0,0,38)
store.Frame114.Size = UDim2.new(1,0,0,1)
store.Frame114.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame114.BackgroundTransparency = 0.85
store.Frame114.BorderSizePixel = 0
store.Frame114.Parent = store.Frame113

store["Frame115"] = Instance.new("Frame")
store.Frame115.Name = "Frame"
store.Frame115.ZIndex = 4
store.Frame115.LayoutOrder = 42
store.Frame115.Size = UDim2.new(1,0,0,40)
store.Frame115.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame115.BackgroundTransparency = 0.5
store.Frame115.BorderSizePixel = 0
store.Frame115.Parent = store.Page_Movement

store["UICorner103"] = Instance.new("UICorner")
store.UICorner103.Name = "UICorner"
store.UICorner103.CornerRadius = UDim.new(0,10)
store.UICorner103.Parent = store.Frame115

store["UIStroke68"] = Instance.new("UIStroke")
store.UIStroke68.Name = "UIStroke"
store.UIStroke68.Color = Color3.fromRGB(28,28,34)
store.UIStroke68.Parent = store.Frame115

store["TextLabel52"] = Instance.new("TextLabel")
store.TextLabel52.Name = "TextLabel"
store.TextLabel52.ZIndex = 5
store.TextLabel52.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel52.Size = UDim2.new(0.6,0,0,16)
store.TextLabel52.BackgroundTransparency = 1
store.TextLabel52.Text = "Drop Brainrot"
store.TextLabel52.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel52.TextSize = 11
store.TextLabel52.Font = Enum.Font.GothamBold
store.TextLabel52.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel52.Parent = store.Frame115

store["Frame116"] = Instance.new("Frame")
store.Frame116.Name = "Frame"
store.Frame116.Visible = false
store.Frame116.ZIndex = 5
store.Frame116.Position = UDim2.new(0,12,0.5,7)
store.Frame116.Size = UDim2.new(0,66,0,1)
store.Frame116.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame116.BackgroundTransparency = 0.5
store.Frame116.BorderSizePixel = 0
store.Frame116.Parent = store.Frame115

store["Frame117"] = Instance.new("Frame")
store.Frame117.Name = "Frame"
store.Frame117.ZIndex = 9
store.Frame117.ClipsDescendants = true
store.Frame117.Position = UDim2.new(1,-44,0.5,-11)
store.Frame117.Size = UDim2.new(0,32,0,22)
store.Frame117.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame117.BackgroundTransparency = 0.6
store.Frame117.BorderSizePixel = 0
store.Frame117.Parent = store.Frame115

store["UICorner104"] = Instance.new("UICorner")
store.UICorner104.Name = "UICorner"
store.UICorner104.Parent = store.Frame117

store["TextLabel53"] = Instance.new("TextLabel")
store.TextLabel53.Name = "TextLabel"
store.TextLabel53.ZIndex = 10
store.TextLabel53.Size = UDim2.new(1,0,1,0)
store.TextLabel53.BackgroundTransparency = 1
store.TextLabel53.Text = "None"
store.TextLabel53.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel53.TextSize = 10
store.TextLabel53.TextScaled = true
store.TextLabel53.Font = Enum.Font.GothamBold
store.TextLabel53.TextWrapped = true
store.TextLabel53.Parent = store.Frame117

store["UITextSizeConstraint6"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint6.Name = "UITextSizeConstraint"
store.UITextSizeConstraint6.MinTextSize = 6
store.UITextSizeConstraint6.MaxTextSize = 10
store.UITextSizeConstraint6.Parent = store.TextLabel53

store["TextButton54"] = Instance.new("TextButton")
store.TextButton54.Name = "TextButton"
store.TextButton54.ZIndex = 11
store.TextButton54.Size = UDim2.new(1,0,1,0)
store.TextButton54.BackgroundTransparency = 1
store.TextButton54.Text = ""
store.TextButton54.AutoButtonColor = false
store.TextButton54.Parent = store.Frame117

store["TextButton55"] = Instance.new("TextButton")
store.TextButton55.Name = "TextButton"
store.TextButton55.ZIndex = 12
store.TextButton55.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton55.Size = UDim2.new(0,32,0,22)
store.TextButton55.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton55.BackgroundTransparency = 0.5
store.TextButton55.BorderSizePixel = 0
store.TextButton55.Text = ""
store.TextButton55.AutoButtonColor = false
store.TextButton55.Parent = store.Frame115

store["UICorner105"] = Instance.new("UICorner")
store.UICorner105.Name = "UICorner"
store.UICorner105.CornerRadius = UDim.new(0,6)
store.UICorner105.Parent = store.TextButton55

store["UIStroke69"] = Instance.new("UIStroke")
store.UIStroke69.Name = "UIStroke"
store.UIStroke69.Color = Color3.fromRGB(254,254,254)
store.UIStroke69.Thickness = 1.4
store.UIStroke69.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke69.Transparency = 0.25
store.UIStroke69.Parent = store.TextButton55

store["UIGradient25"] = Instance.new("UIGradient")
store.UIGradient25.Name = "UIGradient"
store.UIGradient25.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient25.Parent = store.UIStroke69

store["TextLabel54"] = Instance.new("TextLabel")
store.TextLabel54.Name = "TextLabel"
store.TextLabel54.ZIndex = 20
store.TextLabel54.Size = UDim2.new(1,0,1,0)
store.TextLabel54.BackgroundTransparency = 1
store.TextLabel54.Text = "▼"
store.TextLabel54.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel54.TextSize = 15
store.TextLabel54.Font = Enum.Font.GothamBlack
store.TextLabel54.Parent = store.TextButton55

store["DropdownPanel5"] = Instance.new("Frame")
store.DropdownPanel5.Name = "DropdownPanel"
store.DropdownPanel5.Visible = false
store.DropdownPanel5.ZIndex = 4
store.DropdownPanel5.LayoutOrder = 43
store.DropdownPanel5.Size = UDim2.new(1,0,0,34)
store.DropdownPanel5.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.DropdownPanel5.BackgroundTransparency = 0.5
store.DropdownPanel5.BorderSizePixel = 0
store.DropdownPanel5.Parent = store.Page_Movement

store["UICorner106"] = Instance.new("UICorner")
store.UICorner106.Name = "UICorner"
store.UICorner106.CornerRadius = UDim.new(0,12)
store.UICorner106.Parent = store.DropdownPanel5

store["UIStroke70"] = Instance.new("UIStroke")
store.UIStroke70.Name = "UIStroke"
store.UIStroke70.Color = Color3.fromRGB(254,254,254)
store.UIStroke70.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke70.Transparency = 0.5
store.UIStroke70.Parent = store.DropdownPanel5

store["TextLabel55"] = Instance.new("TextLabel")
store.TextLabel55.Name = "TextLabel"
store.TextLabel55.ZIndex = 5
store.TextLabel55.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel55.Size = UDim2.new(0.5,0,0,16)
store.TextLabel55.BackgroundTransparency = 1
store.TextLabel55.Text = "Drop Type"
store.TextLabel55.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel55.TextSize = 11
store.TextLabel55.Font = Enum.Font.GothamBold
store.TextLabel55.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel55.Parent = store.DropdownPanel5

store["Frame118"] = Instance.new("Frame")
store.Frame118.Name = "Frame"
store.Frame118.Visible = false
store.Frame118.ZIndex = 5
store.Frame118.Position = UDim2.new(0,12,0.5,7)
store.Frame118.Size = UDim2.new(0,50,0,1)
store.Frame118.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame118.BackgroundTransparency = 0.5
store.Frame118.BorderSizePixel = 0
store.Frame118.Parent = store.DropdownPanel5

store["TextButton56"] = Instance.new("TextButton")
store.TextButton56.Name = "TextButton"
store.TextButton56.ZIndex = 5
store.TextButton56.Position = UDim2.new(1,-174,0,5)
store.TextButton56.Size = UDim2.new(0,78,0,24)
store.TextButton56.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton56.BackgroundTransparency = 0.5
store.TextButton56.BorderSizePixel = 0
store.TextButton56.Text = "Stand Drop"
store.TextButton56.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton56.TextSize = 10
store.TextButton56.Font = Enum.Font.GothamBold
store.TextButton56.AutoButtonColor = false
store.TextButton56.Parent = store.DropdownPanel5

store["UICorner107"] = Instance.new("UICorner")
store.UICorner107.Name = "UICorner"
store.UICorner107.Parent = store.TextButton56

store["TextButton57"] = Instance.new("TextButton")
store.TextButton57.Name = "TextButton"
store.TextButton57.ZIndex = 5
store.TextButton57.Position = UDim2.new(1,-90,0,5)
store.TextButton57.Size = UDim2.new(0,78,0,24)
store.TextButton57.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton57.BackgroundTransparency = 0.5
store.TextButton57.BorderSizePixel = 0
store.TextButton57.Text = "Jump Drop"
store.TextButton57.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton57.TextSize = 10
store.TextButton57.Font = Enum.Font.GothamBold
store.TextButton57.AutoButtonColor = false
store.TextButton57.Parent = store.DropdownPanel5

store["UICorner108"] = Instance.new("UICorner")
store.UICorner108.Name = "UICorner"
store.UICorner108.Parent = store.TextButton57

store["Frame119"] = Instance.new("Frame")
store.Frame119.Name = "Frame"
store.Frame119.ZIndex = 4
store.Frame119.LayoutOrder = 44
store.Frame119.Size = UDim2.new(1,0,0,40)
store.Frame119.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame119.BackgroundTransparency = 0.5
store.Frame119.BorderSizePixel = 0
store.Frame119.Parent = store.Page_Movement

store["UICorner109"] = Instance.new("UICorner")
store.UICorner109.Name = "UICorner"
store.UICorner109.CornerRadius = UDim.new(0,10)
store.UICorner109.Parent = store.Frame119

store["UIStroke71"] = Instance.new("UIStroke")
store.UIStroke71.Name = "UIStroke"
store.UIStroke71.Color = Color3.fromRGB(28,28,34)
store.UIStroke71.Parent = store.Frame119

store["TextLabel56"] = Instance.new("TextLabel")
store.TextLabel56.Name = "TextLabel"
store.TextLabel56.ZIndex = 5
store.TextLabel56.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel56.Size = UDim2.new(0.6,0,0,16)
store.TextLabel56.BackgroundTransparency = 1
store.TextLabel56.Text = "TP Down"
store.TextLabel56.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel56.TextSize = 11
store.TextLabel56.Font = Enum.Font.GothamBold
store.TextLabel56.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel56.Parent = store.Frame119

store["Frame120"] = Instance.new("Frame")
store.Frame120.Name = "Frame"
store.Frame120.Visible = false
store.Frame120.ZIndex = 5
store.Frame120.Position = UDim2.new(0,12,0.5,7)
store.Frame120.Size = UDim2.new(0,44,0,1)
store.Frame120.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame120.BackgroundTransparency = 0.5
store.Frame120.BorderSizePixel = 0
store.Frame120.Parent = store.Frame119

store["Frame121"] = Instance.new("Frame")
store.Frame121.Name = "Frame"
store.Frame121.ZIndex = 9
store.Frame121.ClipsDescendants = true
store.Frame121.Position = UDim2.new(1,-82,0.5,-11)
store.Frame121.Size = UDim2.new(0,70,0,22)
store.Frame121.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame121.BackgroundTransparency = 0.6
store.Frame121.BorderSizePixel = 0
store.Frame121.Parent = store.Frame119

store["UICorner110"] = Instance.new("UICorner")
store.UICorner110.Name = "UICorner"
store.UICorner110.Parent = store.Frame121

store["TextLabel57"] = Instance.new("TextLabel")
store.TextLabel57.Name = "TextLabel"
store.TextLabel57.ZIndex = 10
store.TextLabel57.Size = UDim2.new(1,0,1,0)
store.TextLabel57.BackgroundTransparency = 1
store.TextLabel57.Text = "None"
store.TextLabel57.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel57.TextSize = 10
store.TextLabel57.TextScaled = true
store.TextLabel57.Font = Enum.Font.GothamBold
store.TextLabel57.TextWrapped = true
store.TextLabel57.Parent = store.Frame121

store["UITextSizeConstraint7"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint7.Name = "UITextSizeConstraint"
store.UITextSizeConstraint7.MinTextSize = 6
store.UITextSizeConstraint7.MaxTextSize = 10
store.UITextSizeConstraint7.Parent = store.TextLabel57

store["TextButton58"] = Instance.new("TextButton")
store.TextButton58.Name = "TextButton"
store.TextButton58.ZIndex = 11
store.TextButton58.Size = UDim2.new(1,0,1,0)
store.TextButton58.BackgroundTransparency = 1
store.TextButton58.Text = ""
store.TextButton58.AutoButtonColor = false
store.TextButton58.Parent = store.Frame121

store["Frame122"] = Instance.new("Frame")
store.Frame122.Name = "Frame"
store.Frame122.ZIndex = 4
store.Frame122.LayoutOrder = 45
store.Frame122.Size = UDim2.new(1,0,0,40)
store.Frame122.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame122.BackgroundTransparency = 0.5
store.Frame122.BorderSizePixel = 0
store.Frame122.Parent = store.Page_Movement

store["UICorner111"] = Instance.new("UICorner")
store.UICorner111.Name = "UICorner"
store.UICorner111.CornerRadius = UDim.new(0,10)
store.UICorner111.Parent = store.Frame122

store["UIStroke72"] = Instance.new("UIStroke")
store.UIStroke72.Name = "UIStroke"
store.UIStroke72.Color = Color3.fromRGB(28,28,34)
store.UIStroke72.Parent = store.Frame122

store["TextLabel58"] = Instance.new("TextLabel")
store.TextLabel58.Name = "TextLabel"
store.TextLabel58.ZIndex = 5
store.TextLabel58.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel58.Size = UDim2.new(0.6,0,0,16)
store.TextLabel58.BackgroundTransparency = 1
store.TextLabel58.Text = "Insta Reset"
store.TextLabel58.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel58.TextSize = 11
store.TextLabel58.Font = Enum.Font.GothamBold
store.TextLabel58.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel58.Parent = store.Frame122

store["Frame123"] = Instance.new("Frame")
store.Frame123.Name = "Frame"
store.Frame123.Visible = false
store.Frame123.ZIndex = 5
store.Frame123.Position = UDim2.new(0,12,0.5,7)
store.Frame123.Size = UDim2.new(0,55,0,1)
store.Frame123.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame123.BackgroundTransparency = 0.5
store.Frame123.BorderSizePixel = 0
store.Frame123.Parent = store.Frame122

store["Frame124"] = Instance.new("Frame")
store.Frame124.Name = "Frame"
store.Frame124.ZIndex = 9
store.Frame124.ClipsDescendants = true
store.Frame124.Position = UDim2.new(1,-44,0.5,-11)
store.Frame124.Size = UDim2.new(0,32,0,22)
store.Frame124.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame124.BackgroundTransparency = 0.6
store.Frame124.BorderSizePixel = 0
store.Frame124.Parent = store.Frame122

store["UICorner112"] = Instance.new("UICorner")
store.UICorner112.Name = "UICorner"
store.UICorner112.Parent = store.Frame124

store["TextLabel59"] = Instance.new("TextLabel")
store.TextLabel59.Name = "TextLabel"
store.TextLabel59.ZIndex = 10
store.TextLabel59.Size = UDim2.new(1,0,1,0)
store.TextLabel59.BackgroundTransparency = 1
store.TextLabel59.Text = "None"
store.TextLabel59.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel59.TextSize = 10
store.TextLabel59.TextScaled = true
store.TextLabel59.Font = Enum.Font.GothamBold
store.TextLabel59.TextWrapped = true
store.TextLabel59.Parent = store.Frame124

store["UITextSizeConstraint8"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint8.Name = "UITextSizeConstraint"
store.UITextSizeConstraint8.MinTextSize = 6
store.UITextSizeConstraint8.MaxTextSize = 10
store.UITextSizeConstraint8.Parent = store.TextLabel59

store["TextButton59"] = Instance.new("TextButton")
store.TextButton59.Name = "TextButton"
store.TextButton59.ZIndex = 11
store.TextButton59.Size = UDim2.new(1,0,1,0)
store.TextButton59.BackgroundTransparency = 1
store.TextButton59.Text = ""
store.TextButton59.AutoButtonColor = false
store.TextButton59.Parent = store.Frame124

store["Frame125"] = Instance.new("Frame")
store.Frame125.Name = "Frame"
store.Frame125.ZIndex = 4
store.Frame125.LayoutOrder = 46
store.Frame125.Size = UDim2.new(1,0,0,40)
store.Frame125.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame125.BackgroundTransparency = 0.5
store.Frame125.BorderSizePixel = 0
store.Frame125.Parent = store.Page_Movement

store["UICorner113"] = Instance.new("UICorner")
store.UICorner113.Name = "UICorner"
store.UICorner113.CornerRadius = UDim.new(0,10)
store.UICorner113.Parent = store.Frame125

store["UIStroke73"] = Instance.new("UIStroke")
store.UIStroke73.Name = "UIStroke"
store.UIStroke73.Color = Color3.fromRGB(28,28,34)
store.UIStroke73.Parent = store.Frame125

store["TextLabel60"] = Instance.new("TextLabel")
store.TextLabel60.Name = "TextLabel"
store.TextLabel60.ZIndex = 5
store.TextLabel60.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel60.Size = UDim2.new(0.6,0,0,16)
store.TextLabel60.BackgroundTransparency = 1
store.TextLabel60.Text = "Auto TP Down"
store.TextLabel60.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel60.TextSize = 11
store.TextLabel60.Font = Enum.Font.GothamBold
store.TextLabel60.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel60.Parent = store.Frame125

store["Frame126"] = Instance.new("Frame")
store.Frame126.Name = "Frame"
store.Frame126.Visible = false
store.Frame126.ZIndex = 5
store.Frame126.Position = UDim2.new(0,12,0.5,7)
store.Frame126.Size = UDim2.new(0,70,0,1)
store.Frame126.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame126.BackgroundTransparency = 0.5
store.Frame126.BorderSizePixel = 0
store.Frame126.Parent = store.Frame125

store["Frame127"] = Instance.new("Frame")
store.Frame127.Name = "Frame"
store.Frame127.ZIndex = 6
store.Frame127.Position = UDim2.new(1,-44,0.5,-8)
store.Frame127.Size = UDim2.new(0,32,0,16)
store.Frame127.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame127.BackgroundTransparency = 0.5
store.Frame127.BorderSizePixel = 0
store.Frame127.Parent = store.Frame125

store["UICorner114"] = Instance.new("UICorner")
store.UICorner114.Name = "UICorner"
store.UICorner114.CornerRadius = UDim.new(1,0)
store.UICorner114.Parent = store.Frame127

store["UIStroke74"] = Instance.new("UIStroke")
store.UIStroke74.Name = "UIStroke"
store.UIStroke74.Color = Color3.fromRGB(70,70,70)
store.UIStroke74.Transparency = 0.5
store.UIStroke74.Parent = store.Frame127

store["Frame128"] = Instance.new("Frame")
store.Frame128.Name = "Frame"
store.Frame128.ZIndex = 7
store.Frame128.Position = UDim2.new(0,2,0.5,-6)
store.Frame128.Size = UDim2.new(0,12,0,12)
store.Frame128.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame128.BackgroundTransparency = 0.5
store.Frame128.BorderSizePixel = 0
store.Frame128.Parent = store.Frame127

store["UICorner115"] = Instance.new("UICorner")
store.UICorner115.Name = "UICorner"
store.UICorner115.CornerRadius = UDim.new(1,0)
store.UICorner115.Parent = store.Frame128

store["TextButton60"] = Instance.new("TextButton")
store.TextButton60.Name = "TextButton"
store.TextButton60.ZIndex = 8
store.TextButton60.Size = UDim2.new(1,0,1,0)
store.TextButton60.BackgroundTransparency = 1
store.TextButton60.Text = ""
store.TextButton60.Parent = store.Frame125

store["PressPop13"] = Instance.new("UIScale")
store.PressPop13.Name = "PressPop"
store.PressPop13.Parent = store.Frame125

store["TextButton61"] = Instance.new("TextButton")
store.TextButton61.Name = "TextButton"
store.TextButton61.ZIndex = 12
store.TextButton61.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton61.Size = UDim2.new(0,32,0,22)
store.TextButton61.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton61.BackgroundTransparency = 0.5
store.TextButton61.BorderSizePixel = 0
store.TextButton61.Text = ""
store.TextButton61.AutoButtonColor = false
store.TextButton61.Parent = store.Frame125

store["UICorner116"] = Instance.new("UICorner")
store.UICorner116.Name = "UICorner"
store.UICorner116.CornerRadius = UDim.new(0,6)
store.UICorner116.Parent = store.TextButton61

store["UIStroke75"] = Instance.new("UIStroke")
store.UIStroke75.Name = "UIStroke"
store.UIStroke75.Color = Color3.fromRGB(254,254,254)
store.UIStroke75.Thickness = 1.4
store.UIStroke75.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke75.Transparency = 0.25
store.UIStroke75.Parent = store.TextButton61

store["UIGradient26"] = Instance.new("UIGradient")
store.UIGradient26.Name = "UIGradient"
store.UIGradient26.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient26.Parent = store.UIStroke75

store["TextLabel61"] = Instance.new("TextLabel")
store.TextLabel61.Name = "TextLabel"
store.TextLabel61.ZIndex = 20
store.TextLabel61.Size = UDim2.new(1,0,1,0)
store.TextLabel61.BackgroundTransparency = 1
store.TextLabel61.Text = "▼"
store.TextLabel61.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel61.TextSize = 15
store.TextLabel61.Font = Enum.Font.GothamBlack
store.TextLabel61.Parent = store.TextButton61

store["Frame129"] = Instance.new("Frame")
store.Frame129.Name = "Frame"
store.Frame129.Visible = false
store.Frame129.ZIndex = 4
store.Frame129.LayoutOrder = 47
store.Frame129.Size = UDim2.new(1,0,0,40)
store.Frame129.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame129.BackgroundTransparency = 0.5
store.Frame129.BorderSizePixel = 0
store.Frame129.Parent = store.Page_Movement

store["UICorner117"] = Instance.new("UICorner")
store.UICorner117.Name = "UICorner"
store.UICorner117.CornerRadius = UDim.new(0,10)
store.UICorner117.Parent = store.Frame129

store["UIStroke76"] = Instance.new("UIStroke")
store.UIStroke76.Name = "UIStroke"
store.UIStroke76.Color = Color3.fromRGB(28,28,34)
store.UIStroke76.Parent = store.Frame129

store["TextLabel62"] = Instance.new("TextLabel")
store.TextLabel62.Name = "TextLabel"
store.TextLabel62.ZIndex = 5
store.TextLabel62.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel62.Size = UDim2.new(0.6,0,0,16)
store.TextLabel62.BackgroundTransparency = 1
store.TextLabel62.Text = "Trigger Height"
store.TextLabel62.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel62.TextSize = 11
store.TextLabel62.Font = Enum.Font.GothamBold
store.TextLabel62.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel62.Parent = store.Frame129

store["Frame130"] = Instance.new("Frame")
store.Frame130.Name = "Frame"
store.Frame130.Visible = false
store.Frame130.ZIndex = 5
store.Frame130.Position = UDim2.new(0,12,0.5,7)
store.Frame130.Size = UDim2.new(0,72,0,1)
store.Frame130.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame130.BackgroundTransparency = 0.5
store.Frame130.BorderSizePixel = 0
store.Frame130.Parent = store.Frame129

store["Frame131"] = Instance.new("Frame")
store.Frame131.Name = "Frame"
store.Frame131.ZIndex = 6
store.Frame131.Position = UDim2.new(1,-54,0.5,-11)
store.Frame131.Size = UDim2.new(0,46,0,22)
store.Frame131.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame131.BackgroundTransparency = 0.5
store.Frame131.BorderSizePixel = 0
store.Frame131.Parent = store.Frame129

store["UICorner118"] = Instance.new("UICorner")
store.UICorner118.Name = "UICorner"
store.UICorner118.Parent = store.Frame131

store["UIStroke77"] = Instance.new("UIStroke")
store.UIStroke77.Name = "UIStroke"
store.UIStroke77.Color = Color3.fromRGB(254,254,254)
store.UIStroke77.Thickness = 1.4
store.UIStroke77.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke77.Transparency = 0.25
store.UIStroke77.Parent = store.Frame131

store["UIGradient27"] = Instance.new("UIGradient")
store.UIGradient27.Name = "UIGradient"
store.UIGradient27.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient27.Parent = store.UIStroke77

store["TextBox13"] = Instance.new("TextBox")
store.TextBox13.Name = "TextBox"
store.TextBox13.ZIndex = 7
store.TextBox13.Size = UDim2.new(1,0,1,0)
store.TextBox13.BackgroundTransparency = 1
store.TextBox13.Text = "20"
store.TextBox13.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox13.TextSize = 11
store.TextBox13.Font = Enum.Font.GothamBold
store.TextBox13.ClearTextOnFocus = false
store.TextBox13.Parent = store.Frame131

store["Frame132"] = Instance.new("Frame")
store.Frame132.Name = "Frame"
store.Frame132.ZIndex = 4
store.Frame132.LayoutOrder = 62
store.Frame132.Size = UDim2.new(1,0,0,40)
store.Frame132.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame132.BackgroundTransparency = 0.5
store.Frame132.BorderSizePixel = 0
store.Frame132.Parent = store.Page_Movement

store["UICorner119"] = Instance.new("UICorner")
store.UICorner119.Name = "UICorner"
store.UICorner119.CornerRadius = UDim.new(0,10)
store.UICorner119.Parent = store.Frame132

store["UIStroke78"] = Instance.new("UIStroke")
store.UIStroke78.Name = "UIStroke"
store.UIStroke78.Color = Color3.fromRGB(28,28,34)
store.UIStroke78.Parent = store.Frame132

store["TextLabel63"] = Instance.new("TextLabel")
store.TextLabel63.Name = "TextLabel"
store.TextLabel63.ZIndex = 5
store.TextLabel63.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel63.Size = UDim2.new(0.6,0,0,16)
store.TextLabel63.BackgroundTransparency = 1
store.TextLabel63.Text = "Anti Die"
store.TextLabel63.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel63.TextSize = 11
store.TextLabel63.Font = Enum.Font.GothamBold
store.TextLabel63.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel63.Parent = store.Frame132

store["Frame133"] = Instance.new("Frame")
store.Frame133.Name = "Frame"
store.Frame133.Visible = false
store.Frame133.ZIndex = 5
store.Frame133.Position = UDim2.new(0,12,0.5,7)
store.Frame133.Size = UDim2.new(0,39,0,1)
store.Frame133.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame133.BackgroundTransparency = 0.5
store.Frame133.BorderSizePixel = 0
store.Frame133.Parent = store.Frame132

store["Frame134"] = Instance.new("Frame")
store.Frame134.Name = "Frame"
store.Frame134.ZIndex = 6
store.Frame134.Position = UDim2.new(1,-44,0.5,-8)
store.Frame134.Size = UDim2.new(0,32,0,16)
store.Frame134.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame134.BackgroundTransparency = 0.5
store.Frame134.BorderSizePixel = 0
store.Frame134.Parent = store.Frame132

store["UICorner120"] = Instance.new("UICorner")
store.UICorner120.Name = "UICorner"
store.UICorner120.CornerRadius = UDim.new(1,0)
store.UICorner120.Parent = store.Frame134

store["UIStroke79"] = Instance.new("UIStroke")
store.UIStroke79.Name = "UIStroke"
store.UIStroke79.Color = Color3.fromRGB(70,70,70)
store.UIStroke79.Transparency = 0.5
store.UIStroke79.Parent = store.Frame134

store["Frame135"] = Instance.new("Frame")
store.Frame135.Name = "Frame"
store.Frame135.ZIndex = 7
store.Frame135.Position = UDim2.new(0,2,0.5,-6)
store.Frame135.Size = UDim2.new(0,12,0,12)
store.Frame135.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame135.BackgroundTransparency = 0.5
store.Frame135.BorderSizePixel = 0
store.Frame135.Parent = store.Frame134

store["UICorner121"] = Instance.new("UICorner")
store.UICorner121.Name = "UICorner"
store.UICorner121.CornerRadius = UDim.new(1,0)
store.UICorner121.Parent = store.Frame135

store["Frame136"] = Instance.new("Frame")
store.Frame136.Name = "Frame"
store.Frame136.ZIndex = 9
store.Frame136.ClipsDescendants = true
store.Frame136.Position = UDim2.new(1,-90,0.5,-8)
store.Frame136.Size = UDim2.new(0,38,0,16)
store.Frame136.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame136.BackgroundTransparency = 0.6
store.Frame136.BorderSizePixel = 0
store.Frame136.Parent = store.Frame132

store["UICorner122"] = Instance.new("UICorner")
store.UICorner122.Name = "UICorner"
store.UICorner122.CornerRadius = UDim.new(0,6)
store.UICorner122.Parent = store.Frame136

store["TextLabel64"] = Instance.new("TextLabel")
store.TextLabel64.Name = "TextLabel"
store.TextLabel64.ZIndex = 10
store.TextLabel64.Size = UDim2.new(1,0,1,0)
store.TextLabel64.BackgroundTransparency = 1
store.TextLabel64.Text = "None"
store.TextLabel64.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel64.TextSize = 10
store.TextLabel64.TextScaled = true
store.TextLabel64.Font = Enum.Font.GothamBold
store.TextLabel64.TextWrapped = true
store.TextLabel64.Parent = store.Frame136

store["UITextSizeConstraint9"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint9.Name = "UITextSizeConstraint"
store.UITextSizeConstraint9.MinTextSize = 6
store.UITextSizeConstraint9.MaxTextSize = 10
store.UITextSizeConstraint9.Parent = store.TextLabel64

store["TextButton62"] = Instance.new("TextButton")
store.TextButton62.Name = "TextButton"
store.TextButton62.ZIndex = 11
store.TextButton62.Size = UDim2.new(1,0,1,0)
store.TextButton62.BackgroundTransparency = 1
store.TextButton62.Text = ""
store.TextButton62.Parent = store.Frame136

store["TextButton63"] = Instance.new("TextButton")
store.TextButton63.Name = "TextButton"
store.TextButton63.ZIndex = 8
store.TextButton63.Size = UDim2.new(1,0,1,0)
store.TextButton63.BackgroundTransparency = 1
store.TextButton63.Text = ""
store.TextButton63.Parent = store.Frame132

store["PressPop14"] = Instance.new("UIScale")
store.PressPop14.Name = "PressPop"
store.PressPop14.Parent = store.Frame132

store["Frame137"] = Instance.new("Frame")
store.Frame137.Name = "Frame"
store.Frame137.ZIndex = 4
store.Frame137.LayoutOrder = 64
store.Frame137.Size = UDim2.new(1,0,0,40)
store.Frame137.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame137.BackgroundTransparency = 0.5
store.Frame137.BorderSizePixel = 0
store.Frame137.Parent = store.Page_Movement

store["UICorner123"] = Instance.new("UICorner")
store.UICorner123.Name = "UICorner"
store.UICorner123.CornerRadius = UDim.new(0,10)
store.UICorner123.Parent = store.Frame137

store["UIStroke80"] = Instance.new("UIStroke")
store.UIStroke80.Name = "UIStroke"
store.UIStroke80.Color = Color3.fromRGB(28,28,34)
store.UIStroke80.Parent = store.Frame137

store["TextLabel65"] = Instance.new("TextLabel")
store.TextLabel65.Name = "TextLabel"
store.TextLabel65.ZIndex = 5
store.TextLabel65.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel65.Size = UDim2.new(0.6,0,0,16)
store.TextLabel65.BackgroundTransparency = 1
store.TextLabel65.Text = "Anti Fling"
store.TextLabel65.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel65.TextSize = 11
store.TextLabel65.Font = Enum.Font.GothamBold
store.TextLabel65.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel65.Parent = store.Frame137

store["Frame138"] = Instance.new("Frame")
store.Frame138.Name = "Frame"
store.Frame138.Visible = false
store.Frame138.ZIndex = 5
store.Frame138.Position = UDim2.new(0,12,0.5,7)
store.Frame138.Size = UDim2.new(0,47,0,1)
store.Frame138.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame138.BackgroundTransparency = 0.5
store.Frame138.BorderSizePixel = 0
store.Frame138.Parent = store.Frame137

store["Frame139"] = Instance.new("Frame")
store.Frame139.Name = "Frame"
store.Frame139.ZIndex = 6
store.Frame139.Position = UDim2.new(1,-44,0.5,-8)
store.Frame139.Size = UDim2.new(0,32,0,16)
store.Frame139.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame139.BackgroundTransparency = 0.5
store.Frame139.BorderSizePixel = 0
store.Frame139.Parent = store.Frame137

store["UICorner124"] = Instance.new("UICorner")
store.UICorner124.Name = "UICorner"
store.UICorner124.CornerRadius = UDim.new(1,0)
store.UICorner124.Parent = store.Frame139

store["UIStroke81"] = Instance.new("UIStroke")
store.UIStroke81.Name = "UIStroke"
store.UIStroke81.Color = Color3.fromRGB(70,70,70)
store.UIStroke81.Transparency = 0.5
store.UIStroke81.Parent = store.Frame139

store["Frame140"] = Instance.new("Frame")
store.Frame140.Name = "Frame"
store.Frame140.ZIndex = 7
store.Frame140.Position = UDim2.new(0,2,0.5,-6)
store.Frame140.Size = UDim2.new(0,12,0,12)
store.Frame140.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame140.BackgroundTransparency = 0.5
store.Frame140.BorderSizePixel = 0
store.Frame140.Parent = store.Frame139

store["UICorner125"] = Instance.new("UICorner")
store.UICorner125.Name = "UICorner"
store.UICorner125.CornerRadius = UDim.new(1,0)
store.UICorner125.Parent = store.Frame140

store["TextButton64"] = Instance.new("TextButton")
store.TextButton64.Name = "TextButton"
store.TextButton64.ZIndex = 8
store.TextButton64.Size = UDim2.new(1,0,1,0)
store.TextButton64.BackgroundTransparency = 1
store.TextButton64.Text = ""
store.TextButton64.Parent = store.Frame137

store["PressPop15"] = Instance.new("UIScale")
store.PressPop15.Name = "PressPop"
store.PressPop15.Parent = store.Frame137

-- Auto Page
store["Page_Auto"] = Instance.new("Frame")
store.Page_Auto.Name = "Page_Auto"
store.Page_Auto.ZIndex = 3
store.Page_Auto.LayoutOrder = 4001
store.Page_Auto.Size = UDim2.new(1,0,0,0)
store.Page_Auto.BackgroundTransparency = 1
store.Page_Auto.BorderSizePixel = 0
store.Page_Auto.Parent = store.ScrollingFrame

store["UIListLayout6"] = Instance.new("UIListLayout")
store.UIListLayout6.Name = "UIListLayout"
store.UIListLayout6.Padding = UDim.new(0,10)
store.UIListLayout6.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout6.Parent = store.Page_Auto

store["UIPadding6"] = Instance.new("UIPadding")
store.UIPadding6.Name = "UIPadding"
store.UIPadding6.PaddingTop = UDim.new(0,10)
store.UIPadding6.PaddingLeft = UDim.new(0,12)
store.UIPadding6.PaddingRight = UDim.new(0,12)
store.UIPadding6.Parent = store.Page_Auto

store["Frame141"] = Instance.new("Frame")
store.Frame141.Name = "Frame"
store.Frame141.LayoutOrder = 10
store.Frame141.Size = UDim2.new(1,0,0,42)
store.Frame141.BackgroundTransparency = 1
store.Frame141.BorderSizePixel = 0
store.Frame141.Parent = store.Page_Auto

store["TextLabel66"] = Instance.new("TextLabel")
store.TextLabel66.Name = "TextLabel"
store.TextLabel66.ZIndex = 4
store.TextLabel66.Position = UDim2.new(0,0,0,20)
store.TextLabel66.Size = UDim2.new(1,0,0,16)
store.TextLabel66.BackgroundTransparency = 1
store.TextLabel66.Text = "AUTO PATH CONFIGURATION"
store.TextLabel66.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel66.TextSize = 12
store.TextLabel66.Font = Enum.Font.GothamBlack
store.TextLabel66.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel66.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel66.Parent = store.Frame141

store["Frame142"] = Instance.new("Frame")
store.Frame142.Name = "Frame"
store.Frame142.ZIndex = 3
store.Frame142.Position = UDim2.new(0,0,0,38)
store.Frame142.Size = UDim2.new(1,0,0,1)
store.Frame142.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame142.BackgroundTransparency = 0.85
store.Frame142.BorderSizePixel = 0
store.Frame142.Parent = store.Frame141

store["Frame143"] = Instance.new("Frame")
store.Frame143.Name = "Frame"
store.Frame143.ZIndex = 4
store.Frame143.LayoutOrder = 11
store.Frame143.Size = UDim2.new(1,0,0,40)
store.Frame143.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame143.BackgroundTransparency = 0.5
store.Frame143.BorderSizePixel = 0
store.Frame143.Parent = store.Page_Auto

store["UICorner126"] = Instance.new("UICorner")
store.UICorner126.Name = "UICorner"
store.UICorner126.CornerRadius = UDim.new(0,10)
store.UICorner126.Parent = store.Frame143

store["UIStroke82"] = Instance.new("UIStroke")
store.UIStroke82.Name = "UIStroke"
store.UIStroke82.Color = Color3.fromRGB(28,28,34)
store.UIStroke82.Parent = store.Frame143

store["TextLabel67"] = Instance.new("TextLabel")
store.TextLabel67.Name = "TextLabel"
store.TextLabel67.ZIndex = 5
store.TextLabel67.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel67.Size = UDim2.new(0.6,0,0,16)
store.TextLabel67.BackgroundTransparency = 1
store.TextLabel67.Text = "Auto Left"
store.TextLabel67.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel67.TextSize = 11
store.TextLabel67.Font = Enum.Font.GothamBold
store.TextLabel67.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel67.Parent = store.Frame143

store["Frame144"] = Instance.new("Frame")
store.Frame144.Name = "Frame"
store.Frame144.Visible = false
store.Frame144.ZIndex = 5
store.Frame144.Position = UDim2.new(0,12,0.5,7)
store.Frame144.Size = UDim2.new(0,46,0,1)
store.Frame144.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame144.BackgroundTransparency = 0.5
store.Frame144.BorderSizePixel = 0
store.Frame144.Parent = store.Frame143

store["Frame145"] = Instance.new("Frame")
store.Frame145.Name = "Frame"
store.Frame145.ZIndex = 9
store.Frame145.ClipsDescendants = true
store.Frame145.Position = UDim2.new(1,-44,0.5,-11)
store.Frame145.Size = UDim2.new(0,32,0,22)
store.Frame145.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame145.BackgroundTransparency = 0.6
store.Frame145.BorderSizePixel = 0
store.Frame145.Parent = store.Frame143

store["UICorner127"] = Instance.new("UICorner")
store.UICorner127.Name = "UICorner"
store.UICorner127.Parent = store.Frame145

store["TextLabel68"] = Instance.new("TextLabel")
store.TextLabel68.Name = "TextLabel"
store.TextLabel68.ZIndex = 10
store.TextLabel68.Size = UDim2.new(1,0,1,0)
store.TextLabel68.BackgroundTransparency = 1
store.TextLabel68.Text = "None"
store.TextLabel68.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel68.TextSize = 10
store.TextLabel68.TextScaled = true
store.TextLabel68.Font = Enum.Font.GothamBold
store.TextLabel68.TextWrapped = true
store.TextLabel68.Parent = store.Frame145

store["UITextSizeConstraint10"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint10.Name = "UITextSizeConstraint"
store.UITextSizeConstraint10.MinTextSize = 6
store.UITextSizeConstraint10.MaxTextSize = 10
store.UITextSizeConstraint10.Parent = store.TextLabel68

store["TextButton65"] = Instance.new("TextButton")
store.TextButton65.Name = "TextButton"
store.TextButton65.ZIndex = 11
store.TextButton65.Size = UDim2.new(1,0,1,0)
store.TextButton65.BackgroundTransparency = 1
store.TextButton65.Text = ""
store.TextButton65.AutoButtonColor = false
store.TextButton65.Parent = store.Frame145

store["Frame146"] = Instance.new("Frame")
store.Frame146.Name = "Frame"
store.Frame146.ZIndex = 4
store.Frame146.LayoutOrder = 12
store.Frame146.Size = UDim2.new(1,0,0,40)
store.Frame146.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame146.BackgroundTransparency = 0.5
store.Frame146.BorderSizePixel = 0
store.Frame146.Parent = store.Page_Auto

store["UICorner128"] = Instance.new("UICorner")
store.UICorner128.Name = "UICorner"
store.UICorner128.CornerRadius = UDim.new(0,10)
store.UICorner128.Parent = store.Frame146

store["UIStroke83"] = Instance.new("UIStroke")
store.UIStroke83.Name = "UIStroke"
store.UIStroke83.Color = Color3.fromRGB(28,28,34)
store.UIStroke83.Parent = store.Frame146

store["TextLabel69"] = Instance.new("TextLabel")
store.TextLabel69.Name = "TextLabel"
store.TextLabel69.ZIndex = 5
store.TextLabel69.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel69.Size = UDim2.new(0.6,0,0,16)
store.TextLabel69.BackgroundTransparency = 1
store.TextLabel69.Text = "Auto Right"
store.TextLabel69.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel69.TextSize = 11
store.TextLabel69.Font = Enum.Font.GothamBold
store.TextLabel69.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel69.Parent = store.Frame146

store["Frame147"] = Instance.new("Frame")
store.Frame147.Name = "Frame"
store.Frame147.Visible = false
store.Frame147.ZIndex = 5
store.Frame147.Position = UDim2.new(0,12,0.5,7)
store.Frame147.Size = UDim2.new(0,53,0,1)
store.Frame147.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame147.BackgroundTransparency = 0.5
store.Frame147.BorderSizePixel = 0
store.Frame147.Parent = store.Frame146

store["Frame148"] = Instance.new("Frame")
store.Frame148.Name = "Frame"
store.Frame148.ZIndex = 9
store.Frame148.ClipsDescendants = true
store.Frame148.Position = UDim2.new(1,-44,0.5,-11)
store.Frame148.Size = UDim2.new(0,32,0,22)
store.Frame148.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame148.BackgroundTransparency = 0.6
store.Frame148.BorderSizePixel = 0
store.Frame148.Parent = store.Frame146

store["UICorner129"] = Instance.new("UICorner")
store.UICorner129.Name = "UICorner"
store.UICorner129.Parent = store.Frame148

store["TextLabel70"] = Instance.new("TextLabel")
store.TextLabel70.Name = "TextLabel"
store.TextLabel70.ZIndex = 10
store.TextLabel70.Size = UDim2.new(1,0,1,0)
store.TextLabel70.BackgroundTransparency = 1
store.TextLabel70.Text = "None"
store.TextLabel70.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel70.TextSize = 10
store.TextLabel70.TextScaled = true
store.TextLabel70.Font = Enum.Font.GothamBold
store.TextLabel70.TextWrapped = true
store.TextLabel70.Parent = store.Frame148

store["UITextSizeConstraint11"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint11.Name = "UITextSizeConstraint"
store.UITextSizeConstraint11.MinTextSize = 6
store.UITextSizeConstraint11.MaxTextSize = 10
store.UITextSizeConstraint11.Parent = store.TextLabel70

store["TextButton66"] = Instance.new("TextButton")
store.TextButton66.Name = "TextButton"
store.TextButton66.ZIndex = 11
store.TextButton66.Size = UDim2.new(1,0,1,0)
store.TextButton66.BackgroundTransparency = 1
store.TextButton66.Text = ""
store.TextButton66.AutoButtonColor = false
store.TextButton66.Parent = store.Frame148

store["Frame149"] = Instance.new("Frame")
store.Frame149.Name = "Frame"
store.Frame149.LayoutOrder = 13
store.Frame149.Size = UDim2.new(1,0,0,0)
store.Frame149.BackgroundTransparency = 1
store.Frame149.BorderSizePixel = 0
store.Frame149.Parent = store.Page_Auto

store["Frame150"] = Instance.new("Frame")
store.Frame150.Name = "Frame"
store.Frame150.LayoutOrder = 1
store.Frame150.Size = UDim2.new(1,0,0,0)
store.Frame150.BackgroundTransparency = 1
store.Frame150.BorderSizePixel = 0
store.Frame150.Parent = store.Frame149

store["UIListLayout7"] = Instance.new("UIListLayout")
store.UIListLayout7.Name = "UIListLayout"
store.UIListLayout7.Padding = UDim.new(0,4)
store.UIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout7.Parent = store.Frame150

store["UIPadding7"] = Instance.new("UIPadding")
store.UIPadding7.Name = "UIPadding"
store.UIPadding7.PaddingTop = UDim.new(0,4)
store.UIPadding7.PaddingLeft = UDim.new(0,2)
store.UIPadding7.PaddingRight = UDim.new(0,2)
store.UIPadding7.Parent = store.Frame150

store["Frame151"] = Instance.new("Frame")
store.Frame151.Name = "Frame"
store.Frame151.ZIndex = 3
store.Frame151.LayoutOrder = 1
store.Frame151.Size = UDim2.new(1,0,0,42)
store.Frame151.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame151.BackgroundTransparency = 0.5
store.Frame151.BorderSizePixel = 0
store.Frame151.Parent = store.Frame150

store["UICorner130"] = Instance.new("UICorner")
store.UICorner130.Name = "UICorner"
store.UICorner130.CornerRadius = UDim.new(0,10)
store.UICorner130.Parent = store.Frame151

store["UIStroke84"] = Instance.new("UIStroke")
store.UIStroke84.Name = "UIStroke"
store.UIStroke84.Color = Color3.fromRGB(254,254,254)
store.UIStroke84.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke84.Transparency = 0.8
store.UIStroke84.Parent = store.Frame151

store["TextLabel71"] = Instance.new("TextLabel")
store.TextLabel71.Name = "TextLabel"
store.TextLabel71.ZIndex = 4
store.TextLabel71.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel71.Size = UDim2.new(0.5,0,0,18)
store.TextLabel71.BackgroundTransparency = 1
store.TextLabel71.Text = "Auto Play Mode"
store.TextLabel71.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel71.TextSize = 13
store.TextLabel71.Font = Enum.Font.GothamBold
store.TextLabel71.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel71.Parent = store.Frame151

store["TextButton67"] = Instance.new("TextButton")
store.TextButton67.Name = "TextButton"
store.TextButton67.ZIndex = 5
store.TextButton67.Position = UDim2.new(1,-150,0.5,-12)
store.TextButton67.Size = UDim2.new(0,66,0,24)
store.TextButton67.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton67.BackgroundTransparency = 0.5
store.TextButton67.BorderSizePixel = 0
store.TextButton67.Text = "Normal"
store.TextButton67.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton67.TextSize = 11
store.TextButton67.Font = Enum.Font.GothamBold
store.TextButton67.AutoButtonColor = false
store.TextButton67.Parent = store.Frame151

store["UICorner131"] = Instance.new("UICorner")
store.UICorner131.Name = "UICorner"
store.UICorner131.Parent = store.TextButton67

store["TextButton68"] = Instance.new("TextButton")
store.TextButton68.Name = "TextButton"
store.TextButton68.ZIndex = 5
store.TextButton68.Position = UDim2.new(1,-78,0.5,-12)
store.TextButton68.Size = UDim2.new(0,66,0,24)
store.TextButton68.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton68.BackgroundTransparency = 0.5
store.TextButton68.BorderSizePixel = 0
store.TextButton68.Text = "Auto Play"
store.TextButton68.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton68.TextSize = 11
store.TextButton68.Font = Enum.Font.GothamBold
store.TextButton68.AutoButtonColor = false
store.TextButton68.Parent = store.Frame151

store["UICorner132"] = Instance.new("UICorner")
store.UICorner132.Name = "UICorner"
store.UICorner132.Parent = store.TextButton68

-- Visual Page
store["Page_Visual"] = Instance.new("Frame")
store.Page_Visual.Name = "Page_Visual"
store.Page_Visual.ZIndex = 3
store.Page_Visual.LayoutOrder = 5001
store.Page_Visual.Size = UDim2.new(1,0,0,0)
store.Page_Visual.BackgroundTransparency = 1
store.Page_Visual.BorderSizePixel = 0
store.Page_Visual.Parent = store.ScrollingFrame

store["UIListLayout8"] = Instance.new("UIListLayout")
store.UIListLayout8.Name = "UIListLayout"
store.UIListLayout8.Padding = UDim.new(0,10)
store.UIListLayout8.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout8.Parent = store.Page_Visual

store["UIPadding8"] = Instance.new("UIPadding")
store.UIPadding8.Name = "UIPadding"
store.UIPadding8.PaddingTop = UDim.new(0,10)
store.UIPadding8.PaddingLeft = UDim.new(0,12)
store.UIPadding8.PaddingRight = UDim.new(0,12)
store.UIPadding8.Parent = store.Page_Visual

store["Frame152"] = Instance.new("Frame")
store.Frame152.Name = "Frame"
store.Frame152.LayoutOrder = 1
store.Frame152.Size = UDim2.new(1,0,0,42)
store.Frame152.BackgroundTransparency = 1
store.Frame152.BorderSizePixel = 0
store.Frame152.Parent = store.Page_Visual

store["TextLabel72"] = Instance.new("TextLabel")
store.TextLabel72.Name = "TextLabel"
store.TextLabel72.ZIndex = 4
store.TextLabel72.Position = UDim2.new(0,0,0,20)
store.TextLabel72.Size = UDim2.new(1,0,0,16)
store.TextLabel72.BackgroundTransparency = 1
store.TextLabel72.Text = "SKY THEME"
store.TextLabel72.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel72.TextSize = 12
store.TextLabel72.Font = Enum.Font.GothamBlack
store.TextLabel72.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel72.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel72.Parent = store.Frame152

store["Frame153"] = Instance.new("Frame")
store.Frame153.Name = "Frame"
store.Frame153.ZIndex = 3
store.Frame153.Position = UDim2.new(0,0,0,38)
store.Frame153.Size = UDim2.new(1,0,0,1)
store.Frame153.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame153.BackgroundTransparency = 0.85
store.Frame153.BorderSizePixel = 0
store.Frame153.Parent = store.Frame152

store["Frame154"] = Instance.new("Frame")
store.Frame154.Name = "Frame"
store.Frame154.LayoutOrder = 20
store.Frame154.Size = UDim2.new(1,0,0,42)
store.Frame154.BackgroundTransparency = 1
store.Frame154.BorderSizePixel = 0
store.Frame154.Parent = store.Page_Visual

store["TextLabel73"] = Instance.new("TextLabel")
store.TextLabel73.Name = "TextLabel"
store.TextLabel73.ZIndex = 4
store.TextLabel73.Position = UDim2.new(0,0,0,20)
store.TextLabel73.Size = UDim2.new(1,0,0,16)
store.TextLabel73.BackgroundTransparency = 1
store.TextLabel73.Text = "VISUAL"
store.TextLabel73.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel73.TextSize = 12
store.TextLabel73.Font = Enum.Font.GothamBlack
store.TextLabel73.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel73.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel73.Parent = store.Frame154

store["Frame155"] = Instance.new("Frame")
store.Frame155.Name = "Frame"
store.Frame155.ZIndex = 3
store.Frame155.Position = UDim2.new(0,0,0,38)
store.Frame155.Size = UDim2.new(1,0,0,1)
store.Frame155.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame155.BackgroundTransparency = 0.85
store.Frame155.BorderSizePixel = 0
store.Frame155.Parent = store.Frame154

store["Frame156"] = Instance.new("Frame")
store.Frame156.Name = "Frame"
store.Frame156.LayoutOrder = 40
store.Frame156.Size = UDim2.new(1,0,0,42)
store.Frame156.BackgroundTransparency = 1
store.Frame156.BorderSizePixel = 0
store.Frame156.Parent = store.Page_Visual

store["TextLabel74"] = Instance.new("TextLabel")
store.TextLabel74.Name = "TextLabel"
store.TextLabel74.ZIndex = 4
store.TextLabel74.Position = UDim2.new(0,0,0,20)
store.TextLabel74.Size = UDim2.new(1,0,0,16)
store.TextLabel74.BackgroundTransparency = 1
store.TextLabel74.Text = "PERFORMANCE CONFIGURATION"
store.TextLabel74.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel74.TextSize = 12
store.TextLabel74.Font = Enum.Font.GothamBlack
store.TextLabel74.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel74.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel74.Parent = store.Frame156

store["Frame157"] = Instance.new("Frame")
store.Frame157.Name = "Frame"
store.Frame157.ZIndex = 3
store.Frame157.Position = UDim2.new(0,0,0,38)
store.Frame157.Size = UDim2.new(1,0,0,1)
store.Frame157.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame157.BackgroundTransparency = 0.85
store.Frame157.BorderSizePixel = 0
store.Frame157.Parent = store.Frame156

store["Frame158"] = Instance.new("Frame")
store.Frame158.Name = "Frame"
store.Frame158.ZIndex = 4
store.Frame158.LayoutOrder = 2
store.Frame158.Size = UDim2.new(1,0,0,62)
store.Frame158.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame158.BackgroundTransparency = 0.5
store.Frame158.BorderSizePixel = 0
store.Frame158.Parent = store.Page_Visual

store["UICorner133"] = Instance.new("UICorner")
store.UICorner133.Name = "UICorner"
store.UICorner133.CornerRadius = UDim.new(0,12)
store.UICorner133.Parent = store.Frame158

store["UIStroke85"] = Instance.new("UIStroke")
store.UIStroke85.Name = "UIStroke"
store.UIStroke85.Color = Color3.fromRGB(35,35,45)
store.UIStroke85.Transparency = 0.4
store.UIStroke85.Parent = store.Frame158

store["TextLabel75"] = Instance.new("TextLabel")
store.TextLabel75.Name = "TextLabel"
store.TextLabel75.ZIndex = 5
store.TextLabel75.Position = UDim2.new(0,12,0,8)
store.TextLabel75.Size = UDim2.new(0.7,0,0,16)
store.TextLabel75.BackgroundTransparency = 1
store.TextLabel75.Text = "Custom Sky"
store.TextLabel75.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel75.TextSize = 11
store.TextLabel75.Font = Enum.Font.GothamBold
store.TextLabel75.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel75.Parent = store.Frame158

store["Frame159"] = Instance.new("Frame")
store.Frame159.Name = "Frame"
store.Frame159.Visible = false
store.Frame159.ZIndex = 5
store.Frame159.Position = UDim2.new(0,12,0,26)
store.Frame159.Size = UDim2.new(0,58,0,1)
store.Frame159.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame159.BackgroundTransparency = 0.5
store.Frame159.BorderSizePixel = 0
store.Frame159.Parent = store.Frame158

store["TextLabel76"] = Instance.new("TextLabel")
store.TextLabel76.Name = "TextLabel"
store.TextLabel76.ZIndex = 6
store.TextLabel76.Position = UDim2.new(0,54,1,-34)
store.TextLabel76.Size = UDim2.new(1,-108,0,26)
store.TextLabel76.BackgroundTransparency = 1
store.TextLabel76.Text = "OFF"
store.TextLabel76.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel76.TextSize = 11
store.TextLabel76.Font = Enum.Font.GothamBold
store.TextLabel76.Parent = store.Frame158

store["TextButton69"] = Instance.new("TextButton")
store.TextButton69.Name = "TextButton"
store.TextButton69.ZIndex = 7
store.TextButton69.Position = UDim2.new(0,12,1,-34)
store.TextButton69.Size = UDim2.new(0,34,0,26)
store.TextButton69.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton69.BackgroundTransparency = 0.5
store.TextButton69.BorderSizePixel = 0
store.TextButton69.Text = "<"
store.TextButton69.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton69.TextSize = 13
store.TextButton69.Font = Enum.Font.GothamBlack
store.TextButton69.AutoButtonColor = false
store.TextButton69.Parent = store.Frame158

store["UICorner134"] = Instance.new("UICorner")
store.UICorner134.Name = "UICorner"
store.UICorner134.Parent = store.TextButton69

store["UIStroke86"] = Instance.new("UIStroke")
store.UIStroke86.Name = "UIStroke"
store.UIStroke86.Color = Color3.fromRGB(254,254,254)
store.UIStroke86.Thickness = 1.4
store.UIStroke86.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke86.Transparency = 0.25
store.UIStroke86.Parent = store.TextButton69

store["UIGradient28"] = Instance.new("UIGradient")
store.UIGradient28.Name = "UIGradient"
store.UIGradient28.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient28.Parent = store.UIStroke86

store["TextButton70"] = Instance.new("TextButton")
store.TextButton70.Name = "TextButton"
store.TextButton70.ZIndex = 7
store.TextButton70.Position = UDim2.new(1,-46,1,-34)
store.TextButton70.Size = UDim2.new(0,34,0,26)
store.TextButton70.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton70.BackgroundTransparency = 0.5
store.TextButton70.BorderSizePixel = 0
store.TextButton70.Text = ">"
store.TextButton70.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton70.TextSize = 13
store.TextButton70.Font = Enum.Font.GothamBlack
store.TextButton70.AutoButtonColor = false
store.TextButton70.Parent = store.Frame158

store["UICorner135"] = Instance.new("UICorner")
store.UICorner135.Name = "UICorner"
store.UICorner135.Parent = store.TextButton70

store["UIStroke87"] = Instance.new("UIStroke")
store.UIStroke87.Name = "UIStroke"
store.UIStroke87.Color = Color3.fromRGB(254,254,254)
store.UIStroke87.Thickness = 1.4
store.UIStroke87.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke87.Transparency = 0.25
store.UIStroke87.Parent = store.TextButton70

store["UIGradient29"] = Instance.new("UIGradient")
store.UIGradient29.Name = "UIGradient"
store.UIGradient29.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient29.Parent = store.UIStroke87

store["Frame160"] = Instance.new("Frame")
store.Frame160.Name = "Frame"
store.Frame160.ZIndex = 4
store.Frame160.LayoutOrder = 22
store.Frame160.Size = UDim2.new(1,0,0,38)
store.Frame160.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame160.BackgroundTransparency = 0.5
store.Frame160.BorderSizePixel = 0
store.Frame160.Parent = store.Page_Visual

store["UICorner136"] = Instance.new("UICorner")
store.UICorner136.Name = "UICorner"
store.UICorner136.CornerRadius = UDim.new(0,12)
store.UICorner136.Parent = store.Frame160

store["UIStroke88"] = Instance.new("UIStroke")
store.UIStroke88.Name = "UIStroke"
store.UIStroke88.Color = Color3.fromRGB(35,35,45)
store.UIStroke88.Transparency = 0.4
store.UIStroke88.Parent = store.Frame160

store["TextLabel77"] = Instance.new("TextLabel")
store.TextLabel77.Name = "TextLabel"
store.TextLabel77.ZIndex = 5
store.TextLabel77.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel77.Size = UDim2.new(0,70,0,16)
store.TextLabel77.BackgroundTransparency = 1
store.TextLabel77.Text = "Display"
store.TextLabel77.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel77.TextSize = 11
store.TextLabel77.Font = Enum.Font.GothamBold
store.TextLabel77.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel77.Parent = store.Frame160

store["Frame161"] = Instance.new("Frame")
store.Frame161.Name = "Frame"
store.Frame161.Visible = false
store.Frame161.ZIndex = 5
store.Frame161.Position = UDim2.new(0,12,0.5,7)
store.Frame161.Size = UDim2.new(0,36,0,1)
store.Frame161.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame161.BackgroundTransparency = 0.5
store.Frame161.BorderSizePixel = 0
store.Frame161.Parent = store.Frame160

store["TextButton71"] = Instance.new("TextButton")
store.TextButton71.Name = "TextButton"
store.TextButton71.ZIndex = 5
store.TextButton71.Position = UDim2.new(1,-186,0.5,-12)
store.TextButton71.Size = UDim2.new(0,56,0,24)
store.TextButton71.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton71.BackgroundTransparency = 0.5
store.TextButton71.BorderSizePixel = 0
store.TextButton71.Text = "Default"
store.TextButton71.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton71.TextSize = 10
store.TextButton71.Font = Enum.Font.GothamBold
store.TextButton71.AutoButtonColor = false
store.TextButton71.Parent = store.Frame160

store["UICorner137"] = Instance.new("UICorner")
store.UICorner137.Name = "UICorner"
store.UICorner137.Parent = store.TextButton71

store["TextButton72"] = Instance.new("TextButton")
store.TextButton72.Name = "TextButton"
store.TextButton72.ZIndex = 5
store.TextButton72.Position = UDim2.new(1,-126,0.5,-12)
store.TextButton72.Size = UDim2.new(0,56,0,24)
store.TextButton72.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton72.BackgroundTransparency = 0.5
store.TextButton72.BorderSizePixel = 0
store.TextButton72.Text = "FOV"
store.TextButton72.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton72.TextSize = 10
store.TextButton72.Font = Enum.Font.GothamBold
store.TextButton72.AutoButtonColor = false
store.TextButton72.Parent = store.Frame160

store["UICorner138"] = Instance.new("UICorner")
store.UICorner138.Name = "UICorner"
store.UICorner138.Parent = store.TextButton72

store["TextButton73"] = Instance.new("TextButton")
store.TextButton73.Name = "TextButton"
store.TextButton73.ZIndex = 5
store.TextButton73.Position = UDim2.new(1,-66,0.5,-12)
store.TextButton73.Size = UDim2.new(0,56,0,24)
store.TextButton73.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton73.BackgroundTransparency = 0.5
store.TextButton73.BorderSizePixel = 0
store.TextButton73.Text = "Stretch"
store.TextButton73.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton73.TextSize = 10
store.TextButton73.Font = Enum.Font.GothamBold
store.TextButton73.AutoButtonColor = false
store.TextButton73.Parent = store.Frame160

store["UICorner139"] = Instance.new("UICorner")
store.UICorner139.Name = "UICorner"
store.UICorner139.Parent = store.TextButton73

store["Frame162"] = Instance.new("Frame")
store.Frame162.Name = "Frame"
store.Frame162.Visible = false
store.Frame162.ZIndex = 4
store.Frame162.LayoutOrder = 23
store.Frame162.Size = UDim2.new(1,0,0,34)
store.Frame162.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame162.BackgroundTransparency = 0.5
store.Frame162.BorderSizePixel = 0
store.Frame162.Parent = store.Page_Visual

store["UICorner140"] = Instance.new("UICorner")
store.UICorner140.Name = "UICorner"
store.UICorner140.CornerRadius = UDim.new(0,12)
store.UICorner140.Parent = store.Frame162

store["UIStroke89"] = Instance.new("UIStroke")
store.UIStroke89.Name = "UIStroke"
store.UIStroke89.Color = Color3.fromRGB(35,35,45)
store.UIStroke89.Transparency = 0.4
store.UIStroke89.Parent = store.Frame162

store["TextLabel78"] = Instance.new("TextLabel")
store.TextLabel78.Name = "TextLabel"
store.TextLabel78.ZIndex = 5
store.TextLabel78.Position = UDim2.new(0,12,0,0)
store.TextLabel78.Size = UDim2.new(0.5,0,1,0)
store.TextLabel78.BackgroundTransparency = 1
store.TextLabel78.Text = "Normal FOV"
store.TextLabel78.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel78.TextSize = 11
store.TextLabel78.Font = Enum.Font.GothamBold
store.TextLabel78.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel78.Parent = store.Frame162

store["Frame163"] = Instance.new("Frame")
store.Frame163.Name = "Frame"
store.Frame163.ZIndex = 5
store.Frame163.Position = UDim2.new(1,-130,0.5,-14)
store.Frame163.Size = UDim2.new(0,118,0,28)
store.Frame163.BackgroundTransparency = 1
store.Frame163.Parent = store.Frame162

store["Frame164"] = Instance.new("Frame")
store.Frame164.Name = "Frame"
store.Frame164.ZIndex = 6
store.Frame164.Position = UDim2.new(0,34,0,0)
store.Frame164.Size = UDim2.new(0,50,0,28)
store.Frame164.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame164.BackgroundTransparency = 0.5
store.Frame164.BorderSizePixel = 0
store.Frame164.Parent = store.Frame163

store["UICorner141"] = Instance.new("UICorner")
store.UICorner141.Name = "UICorner"
store.UICorner141.Parent = store.Frame164

store["UIStroke90"] = Instance.new("UIStroke")
store.UIStroke90.Name = "UIStroke"
store.UIStroke90.Color = Color3.fromRGB(254,254,254)
store.UIStroke90.Thickness = 1.4
store.UIStroke90.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke90.Transparency = 0.25
store.UIStroke90.Parent = store.Frame164

store["UIGradient30"] = Instance.new("UIGradient")
store.UIGradient30.Name = "UIGradient"
store.UIGradient30.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient30.Parent = store.UIStroke90

store["TextLabel79"] = Instance.new("TextLabel")
store.TextLabel79.Name = "TextLabel"
store.TextLabel79.ZIndex = 7
store.TextLabel79.Size = UDim2.new(1,0,1,0)
store.TextLabel79.BackgroundTransparency = 1
store.TextLabel79.Text = "120"
store.TextLabel79.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel79.TextSize = 11
store.TextLabel79.Font = Enum.Font.GothamBlack
store.TextLabel79.Parent = store.Frame164

store["TextButton74"] = Instance.new("TextButton")
store.TextButton74.Name = "TextButton"
store.TextButton74.ZIndex = 6
store.TextButton74.Size = UDim2.new(0,28,0,28)
store.TextButton74.BackgroundColor3 = Color3.fromRGB(32,32,32)
store.TextButton74.BackgroundTransparency = 0.5
store.TextButton74.BorderSizePixel = 0
store.TextButton74.Text = "-"
store.TextButton74.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton74.TextSize = 14
store.TextButton74.Font = Enum.Font.GothamBlack
store.TextButton74.AutoButtonColor = false
store.TextButton74.Parent = store.Frame163

store["UICorner142"] = Instance.new("UICorner")
store.UICorner142.Name = "UICorner"
store.UICorner142.Parent = store.TextButton74

store["UIStroke91"] = Instance.new("UIStroke")
store.UIStroke91.Name = "UIStroke"
store.UIStroke91.Color = Color3.fromRGB(254,254,254)
store.UIStroke91.Thickness = 1.4
store.UIStroke91.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke91.Transparency = 0.25
store.UIStroke91.Parent = store.TextButton74

store["UIGradient31"] = Instance.new("UIGradient")
store.UIGradient31.Name = "UIGradient"
store.UIGradient31.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient31.Parent = store.UIStroke91

store["TextButton75"] = Instance.new("TextButton")
store.TextButton75.Name = "TextButton"
store.TextButton75.ZIndex = 6
store.TextButton75.Position = UDim2.new(0,90,0,0)
store.TextButton75.Size = UDim2.new(0,28,0,28)
store.TextButton75.BackgroundColor3 = Color3.fromRGB(32,32,32)
store.TextButton75.BackgroundTransparency = 0.5
store.TextButton75.BorderSizePixel = 0
store.TextButton75.Text = "+"
store.TextButton75.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton75.TextSize = 14
store.TextButton75.Font = Enum.Font.GothamBlack
store.TextButton75.AutoButtonColor = false
store.TextButton75.Parent = store.Frame163

store["UICorner143"] = Instance.new("UICorner")
store.UICorner143.Name = "UICorner"
store.UICorner143.Parent = store.TextButton75

store["UIStroke92"] = Instance.new("UIStroke")
store.UIStroke92.Name = "UIStroke"
store.UIStroke92.Color = Color3.fromRGB(254,254,254)
store.UIStroke92.Thickness = 1.4
store.UIStroke92.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke92.Transparency = 0.25
store.UIStroke92.Parent = store.TextButton75

store["UIGradient32"] = Instance.new("UIGradient")
store.UIGradient32.Name = "UIGradient"
store.UIGradient32.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient32.Parent = store.UIStroke92

store["Frame165"] = Instance.new("Frame")
store.Frame165.Name = "Frame"
store.Frame165.Visible = false
store.Frame165.ZIndex = 4
store.Frame165.LayoutOrder = 24
store.Frame165.Size = UDim2.new(1,0,0,58)
store.Frame165.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame165.BackgroundTransparency = 0.5
store.Frame165.BorderSizePixel = 0
store.Frame165.Parent = store.Page_Visual

store["UICorner144"] = Instance.new("UICorner")
store.UICorner144.Name = "UICorner"
store.UICorner144.CornerRadius = UDim.new(0,12)
store.UICorner144.Parent = store.Frame165

store["UIStroke93"] = Instance.new("UIStroke")
store.UIStroke93.Name = "UIStroke"
store.UIStroke93.Color = Color3.fromRGB(35,35,45)
store.UIStroke93.Transparency = 0.4
store.UIStroke93.Parent = store.Frame165

store["TextLabel80"] = Instance.new("TextLabel")
store.TextLabel80.Name = "TextLabel"
store.TextLabel80.ZIndex = 5
store.TextLabel80.Position = UDim2.new(0,12,0,11)
store.TextLabel80.Size = UDim2.new(0.6,0,0,16)
store.TextLabel80.BackgroundTransparency = 1
store.TextLabel80.Text = "Stretch Rez"
store.TextLabel80.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel80.TextSize = 11
store.TextLabel80.Font = Enum.Font.GothamBold
store.TextLabel80.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel80.Parent = store.Frame165

store["Frame166"] = Instance.new("Frame")
store.Frame166.Name = "Frame"
store.Frame166.Visible = false
store.Frame166.ZIndex = 5
store.Frame166.Position = UDim2.new(0,12,0,27)
store.Frame166.Size = UDim2.new(0,56,0,1)
store.Frame166.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame166.BackgroundTransparency = 0.5
store.Frame166.BorderSizePixel = 0
store.Frame166.Parent = store.Frame165

store["Frame167"] = Instance.new("Frame")
store.Frame167.Name = "Frame"
store.Frame167.ZIndex = 5
store.Frame167.Position = UDim2.new(1,-64,0,9)
store.Frame167.Size = UDim2.new(0,52,0,24)
store.Frame167.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame167.BackgroundTransparency = 0.5
store.Frame167.BorderSizePixel = 0
store.Frame167.Parent = store.Frame165

store["UICorner145"] = Instance.new("UICorner")
store.UICorner145.Name = "UICorner"
store.UICorner145.Parent = store.Frame167

store["UIStroke94"] = Instance.new("UIStroke")
store.UIStroke94.Name = "UIStroke"
store.UIStroke94.Color = Color3.fromRGB(254,254,254)
store.UIStroke94.Thickness = 1.4
store.UIStroke94.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke94.Transparency = 0.25
store.UIStroke94.Parent = store.Frame167

store["UIGradient33"] = Instance.new("UIGradient")
store.UIGradient33.Name = "UIGradient"
store.UIGradient33.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient33.Parent = store.UIStroke94

store["TextLabel81"] = Instance.new("TextLabel")
store.TextLabel81.Name = "TextLabel"
store.TextLabel81.ZIndex = 6
store.TextLabel81.Size = UDim2.new(1,0,1,0)
store.TextLabel81.BackgroundTransparency = 1
store.TextLabel81.Text = "0.7"
store.TextLabel81.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel81.TextSize = 11
store.TextLabel81.Font = Enum.Font.GothamBold
store.TextLabel81.Parent = store.Frame167

store["Frame168"] = Instance.new("Frame")
store.Frame168.Name = "Frame"
store.Frame168.ZIndex = 5
store.Frame168.Position = UDim2.new(0,12,1,-18)
store.Frame168.Size = UDim2.new(1,-24,0,6)
store.Frame168.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame168.BackgroundTransparency = 0.5
store.Frame168.BorderSizePixel = 0
store.Frame168.Parent = store.Frame165

store["UICorner146"] = Instance.new("UICorner")
store.UICorner146.Name = "UICorner"
store.UICorner146.CornerRadius = UDim.new(1,0)
store.UICorner146.Parent = store.Frame168

store["UIStroke95"] = Instance.new("UIStroke")
store.UIStroke95.Name = "UIStroke"
store.UIStroke95.Color = Color3.fromRGB(254,254,254)
store.UIStroke95.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke95.Transparency = 0.75
store.UIStroke95.Parent = store.Frame168

store["Frame169"] = Instance.new("Frame")
store.Frame169.Name = "Frame"
store.Frame169.ZIndex = 6
store.Frame169.Size = UDim2.new(0.571429,0,1,0)
store.Frame169.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame169.BackgroundTransparency = 0.5
store.Frame169.BorderSizePixel = 0
store.Frame169.Parent = store.Frame168

store["UICorner147"] = Instance.new("UICorner")
store.UICorner147.Name = "UICorner"
store.UICorner147.CornerRadius = UDim.new(1,0)
store.UICorner147.Parent = store.Frame169

store["SliderKnob"] = Instance.new("Frame")
store.SliderKnob.Name = "SliderKnob"
store.SliderKnob.ZIndex = 8
store.SliderKnob.AnchorPoint = Vector2.new(0.5,0.5)
store.SliderKnob.Position = UDim2.new(0.571429,0,0.5,0)
store.SliderKnob.Size = UDim2.new(0,16,0,16)
store.SliderKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.SliderKnob.BorderSizePixel = 0
store.SliderKnob.Parent = store.Frame168

store["UICorner148"] = Instance.new("UICorner")
store.UICorner148.Name = "UICorner"
store.UICorner148.CornerRadius = UDim.new(1,0)
store.UICorner148.Parent = store.SliderKnob

store["UIStroke96"] = Instance.new("UIStroke")
store.UIStroke96.Name = "UIStroke"
store.UIStroke96.Color = Color3.fromRGB(254,254,254)
store.UIStroke96.Thickness = 1.5
store.UIStroke96.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke96.Transparency = 0.2
store.UIStroke96.Parent = store.SliderKnob

store["TextButton76"] = Instance.new("TextButton")
store.TextButton76.Name = "TextButton"
store.TextButton76.ZIndex = 9
store.TextButton76.Position = UDim2.new(0,12,1,-28)
store.TextButton76.Size = UDim2.new(1,-24,0,26)
store.TextButton76.BackgroundTransparency = 1
store.TextButton76.Text = ""
store.TextButton76.AutoButtonColor = false
store.TextButton76.Parent = store.Frame165

store["Frame170"] = Instance.new("Frame")
store.Frame170.Name = "Frame"
store.Frame170.ZIndex = 4
store.Frame170.LayoutOrder = 26
store.Frame170.Size = UDim2.new(1,0,0,40)
store.Frame170.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame170.BackgroundTransparency = 0.5
store.Frame170.BorderSizePixel = 0
store.Frame170.Parent = store.Page_Visual

store["UICorner149"] = Instance.new("UICorner")
store.UICorner149.Name = "UICorner"
store.UICorner149.CornerRadius = UDim.new(0,10)
store.UICorner149.Parent = store.Frame170

store["UIStroke97"] = Instance.new("UIStroke")
store.UIStroke97.Name = "UIStroke"
store.UIStroke97.Color = Color3.fromRGB(28,28,34)
store.UIStroke97.Parent = store.Frame170

store["TextLabel82"] = Instance.new("TextLabel")
store.TextLabel82.Name = "TextLabel"
store.TextLabel82.ZIndex = 5
store.TextLabel82.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel82.Size = UDim2.new(0.6,0,0,16)
store.TextLabel82.BackgroundTransparency = 1
store.TextLabel82.Text = "No Cam Collision"
store.TextLabel82.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel82.TextSize = 11
store.TextLabel82.Font = Enum.Font.GothamBold
store.TextLabel82.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel82.Parent = store.Frame170

store["Frame171"] = Instance.new("Frame")
store.Frame171.Name = "Frame"
store.Frame171.Visible = false
store.Frame171.ZIndex = 5
store.Frame171.Position = UDim2.new(0,12,0.5,7)
store.Frame171.Size = UDim2.new(0,82,0,1)
store.Frame171.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame171.BackgroundTransparency = 0.5
store.Frame171.BorderSizePixel = 0
store.Frame171.Parent = store.Frame170

store["Frame172"] = Instance.new("Frame")
store.Frame172.Name = "Frame"
store.Frame172.ZIndex = 6
store.Frame172.Position = UDim2.new(1,-44,0.5,-8)
store.Frame172.Size = UDim2.new(0,32,0,16)
store.Frame172.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame172.BackgroundTransparency = 0.5
store.Frame172.BorderSizePixel = 0
store.Frame172.Parent = store.Frame170

store["UICorner150"] = Instance.new("UICorner")
store.UICorner150.Name = "UICorner"
store.UICorner150.CornerRadius = UDim.new(1,0)
store.UICorner150.Parent = store.Frame172

store["UIStroke98"] = Instance.new("UIStroke")
store.UIStroke98.Name = "UIStroke"
store.UIStroke98.Color = Color3.fromRGB(70,70,70)
store.UIStroke98.Transparency = 0.5
store.UIStroke98.Parent = store.Frame172

store["Frame173"] = Instance.new("Frame")
store.Frame173.Name = "Frame"
store.Frame173.ZIndex = 7
store.Frame173.Position = UDim2.new(0,2,0.5,-6)
store.Frame173.Size = UDim2.new(0,12,0,12)
store.Frame173.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame173.BackgroundTransparency = 0.5
store.Frame173.BorderSizePixel = 0
store.Frame173.Parent = store.Frame172

store["UICorner151"] = Instance.new("UICorner")
store.UICorner151.Name = "UICorner"
store.UICorner151.CornerRadius = UDim.new(1,0)
store.UICorner151.Parent = store.Frame173

store["TextButton77"] = Instance.new("TextButton")
store.TextButton77.Name = "TextButton"
store.TextButton77.ZIndex = 8
store.TextButton77.Size = UDim2.new(1,0,1,0)
store.TextButton77.BackgroundTransparency = 1
store.TextButton77.Text = ""
store.TextButton77.Parent = store.Frame170

store["PressPop16"] = Instance.new("UIScale")
store.PressPop16.Name = "PressPop"
store.PressPop16.Parent = store.Frame170

store["Frame174"] = Instance.new("Frame")
store.Frame174.Name = "Frame"
store.Frame174.LayoutOrder = 27
store.Frame174.Size = UDim2.new(1,0,0,42)
store.Frame174.BackgroundTransparency = 1
store.Frame174.BorderSizePixel = 0
store.Frame174.Parent = store.Page_Visual

store["TextLabel83"] = Instance.new("TextLabel")
store.TextLabel83.Name = "TextLabel"
store.TextLabel83.ZIndex = 4
store.TextLabel83.Position = UDim2.new(0,0,0,20)
store.TextLabel83.Size = UDim2.new(1,0,0,16)
store.TextLabel83.BackgroundTransparency = 1
store.TextLabel83.Text = "ESP CONFIGURATION"
store.TextLabel83.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel83.TextSize = 12
store.TextLabel83.Font = Enum.Font.GothamBlack
store.TextLabel83.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel83.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel83.Parent = store.Frame174

store["Frame175"] = Instance.new("Frame")
store.Frame175.Name = "Frame"
store.Frame175.ZIndex = 3
store.Frame175.Position = UDim2.new(0,0,0,38)
store.Frame175.Size = UDim2.new(1,0,0,1)
store.Frame175.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame175.BackgroundTransparency = 0.85
store.Frame175.BorderSizePixel = 0
store.Frame175.Parent = store.Frame174

store["Frame176"] = Instance.new("Frame")
store.Frame176.Name = "Frame"
store.Frame176.ZIndex = 4
store.Frame176.LayoutOrder = 28
store.Frame176.Size = UDim2.new(1,0,0,40)
store.Frame176.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame176.BackgroundTransparency = 0.5
store.Frame176.BorderSizePixel = 0
store.Frame176.Parent = store.Page_Visual

store["UICorner152"] = Instance.new("UICorner")
store.UICorner152.Name = "UICorner"
store.UICorner152.CornerRadius = UDim.new(0,10)
store.UICorner152.Parent = store.Frame176

store["UIStroke99"] = Instance.new("UIStroke")
store.UIStroke99.Name = "UIStroke"
store.UIStroke99.Color = Color3.fromRGB(28,28,34)
store.UIStroke99.Parent = store.Frame176

store["TextLabel84"] = Instance.new("TextLabel")
store.TextLabel84.Name = "TextLabel"
store.TextLabel84.ZIndex = 5
store.TextLabel84.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel84.Size = UDim2.new(0.6,0,0,16)
store.TextLabel84.BackgroundTransparency = 1
store.TextLabel84.Text = "ESP"
store.TextLabel84.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel84.TextSize = 11
store.TextLabel84.Font = Enum.Font.GothamBold
store.TextLabel84.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel84.Parent = store.Frame176

store["Frame177"] = Instance.new("Frame")
store.Frame177.Name = "Frame"
store.Frame177.Visible = false
store.Frame177.ZIndex = 5
store.Frame177.Position = UDim2.new(0,12,0.5,7)
store.Frame177.Size = UDim2.new(0,19,0,1)
store.Frame177.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame177.BackgroundTransparency = 0.5
store.Frame177.BorderSizePixel = 0
store.Frame177.Parent = store.Frame176

store["Frame178"] = Instance.new("Frame")
store.Frame178.Name = "Frame"
store.Frame178.ZIndex = 6
store.Frame178.Position = UDim2.new(1,-44,0.5,-8)
store.Frame178.Size = UDim2.new(0,32,0,16)
store.Frame178.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame178.BackgroundTransparency = 0.5
store.Frame178.BorderSizePixel = 0
store.Frame178.Parent = store.Frame176

store["UICorner153"] = Instance.new("UICorner")
store.UICorner153.Name = "UICorner"
store.UICorner153.CornerRadius = UDim.new(1,0)
store.UICorner153.Parent = store.Frame178

store["UIStroke100"] = Instance.new("UIStroke")
store.UIStroke100.Name = "UIStroke"
store.UIStroke100.Color = Color3.fromRGB(70,70,70)
store.UIStroke100.Transparency = 0.5
store.UIStroke100.Parent = store.Frame178

store["Frame179"] = Instance.new("Frame")
store.Frame179.Name = "Frame"
store.Frame179.ZIndex = 7
store.Frame179.Position = UDim2.new(0,2,0.5,-6)
store.Frame179.Size = UDim2.new(0,12,0,12)
store.Frame179.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame179.BackgroundTransparency = 0.5
store.Frame179.BorderSizePixel = 0
store.Frame179.Parent = store.Frame178

store["UICorner154"] = Instance.new("UICorner")
store.UICorner154.Name = "UICorner"
store.UICorner154.CornerRadius = UDim.new(1,0)
store.UICorner154.Parent = store.Frame179

store["TextButton78"] = Instance.new("TextButton")
store.TextButton78.Name = "TextButton"
store.TextButton78.ZIndex = 8
store.TextButton78.Size = UDim2.new(1,0,1,0)
store.TextButton78.BackgroundTransparency = 1
store.TextButton78.Text = ""
store.TextButton78.Parent = store.Frame176

store["PressPop17"] = Instance.new("UIScale")
store.PressPop17.Name = "PressPop"
store.PressPop17.Parent = store.Frame176

store["TextButton79"] = Instance.new("TextButton")
store.TextButton79.Name = "TextButton"
store.TextButton79.ZIndex = 12
store.TextButton79.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton79.Size = UDim2.new(0,32,0,22)
store.TextButton79.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton79.BackgroundTransparency = 0.5
store.TextButton79.BorderSizePixel = 0
store.TextButton79.Text = ""
store.TextButton79.AutoButtonColor = false
store.TextButton79.Parent = store.Frame176

store["UICorner155"] = Instance.new("UICorner")
store.UICorner155.Name = "UICorner"
store.UICorner155.CornerRadius = UDim.new(0,6)
store.UICorner155.Parent = store.TextButton79

store["UIStroke101"] = Instance.new("UIStroke")
store.UIStroke101.Name = "UIStroke"
store.UIStroke101.Color = Color3.fromRGB(254,254,254)
store.UIStroke101.Thickness = 1.4
store.UIStroke101.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke101.Transparency = 0.25
store.UIStroke101.Parent = store.TextButton79

store["UIGradient34"] = Instance.new("UIGradient")
store.UIGradient34.Name = "UIGradient"
store.UIGradient34.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient34.Parent = store.UIStroke101

store["TextLabel85"] = Instance.new("TextLabel")
store.TextLabel85.Name = "TextLabel"
store.TextLabel85.ZIndex = 20
store.TextLabel85.Size = UDim2.new(1,0,1,0)
store.TextLabel85.BackgroundTransparency = 1
store.TextLabel85.Text = "▼"
store.TextLabel85.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel85.TextSize = 15
store.TextLabel85.Font = Enum.Font.GothamBlack
store.TextLabel85.Parent = store.TextButton79

store["DropdownPanel6"] = Instance.new("Frame")
store.DropdownPanel6.Name = "DropdownPanel"
store.DropdownPanel6.Visible = false
store.DropdownPanel6.ZIndex = 4
store.DropdownPanel6.LayoutOrder = 29
store.DropdownPanel6.Size = UDim2.new(1,0,0,64)
store.DropdownPanel6.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.DropdownPanel6.BackgroundTransparency = 0.5
store.DropdownPanel6.BorderSizePixel = 0
store.DropdownPanel6.Parent = store.Page_Visual

store["UICorner156"] = Instance.new("UICorner")
store.UICorner156.Name = "UICorner"
store.UICorner156.CornerRadius = UDim.new(0,12)
store.UICorner156.Parent = store.DropdownPanel6

store["UIStroke102"] = Instance.new("UIStroke")
store.UIStroke102.Name = "UIStroke"
store.UIStroke102.Color = Color3.fromRGB(254,254,254)
store.UIStroke102.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke102.Transparency = 0.5
store.UIStroke102.Parent = store.DropdownPanel6

store["TextLabel86"] = Instance.new("TextLabel")
store.TextLabel86.Name = "TextLabel"
store.TextLabel86.ZIndex = 5
store.TextLabel86.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel86.Size = UDim2.new(0.5,0,0,16)
store.TextLabel86.BackgroundTransparency = 1
store.TextLabel86.Text = "ESP Type"
store.TextLabel86.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel86.TextSize = 11
store.TextLabel86.Font = Enum.Font.GothamBold
store.TextLabel86.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel86.Parent = store.DropdownPanel6

store["Frame180"] = Instance.new("Frame")
store.Frame180.Name = "Frame"
store.Frame180.Visible = false
store.Frame180.ZIndex = 5
store.Frame180.Position = UDim2.new(0,12,0.5,7)
store.Frame180.Size = UDim2.new(0,45,0,1)
store.Frame180.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame180.BackgroundTransparency = 0.5
store.Frame180.BorderSizePixel = 0
store.Frame180.Parent = store.DropdownPanel6

store["TextButton80"] = Instance.new("TextButton")
store.TextButton80.Name = "TextButton"
store.TextButton80.ZIndex = 5
store.TextButton80.Position = UDim2.new(1,-180,0,5)
store.TextButton80.Size = UDim2.new(0,52,0,24)
store.TextButton80.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton80.BackgroundTransparency = 0.5
store.TextButton80.BorderSizePixel = 0
store.TextButton80.Text = "Aura"
store.TextButton80.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton80.TextSize = 10
store.TextButton80.Font = Enum.Font.GothamBold
store.TextButton80.AutoButtonColor = false
store.TextButton80.Parent = store.DropdownPanel6

store["UICorner157"] = Instance.new("UICorner")
store.UICorner157.Name = "UICorner"
store.UICorner157.Parent = store.TextButton80

store["TextButton81"] = Instance.new("TextButton")
store.TextButton81.Name = "TextButton"
store.TextButton81.ZIndex = 5
store.TextButton81.Position = UDim2.new(1,-122,0,5)
store.TextButton81.Size = UDim2.new(0,52,0,24)
store.TextButton81.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton81.BackgroundTransparency = 0.5
store.TextButton81.BorderSizePixel = 0
store.TextButton81.Text = "Box"
store.TextButton81.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton81.TextSize = 10
store.TextButton81.Font = Enum.Font.GothamBold
store.TextButton81.AutoButtonColor = false
store.TextButton81.Parent = store.DropdownPanel6

store["UICorner158"] = Instance.new("UICorner")
store.UICorner158.Name = "UICorner"
store.UICorner158.Parent = store.TextButton81

store["TextButton82"] = Instance.new("TextButton")
store.TextButton82.Name = "TextButton"
store.TextButton82.ZIndex = 5
store.TextButton82.Position = UDim2.new(1,-64,0,5)
store.TextButton82.Size = UDim2.new(0,52,0,24)
store.TextButton82.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton82.BackgroundTransparency = 0.5
store.TextButton82.BorderSizePixel = 0
store.TextButton82.Text = "Tracer"
store.TextButton82.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton82.TextSize = 10
store.TextButton82.Font = Enum.Font.GothamBold
store.TextButton82.AutoButtonColor = false
store.TextButton82.Parent = store.DropdownPanel6

store["UICorner159"] = Instance.new("UICorner")
store.UICorner159.Name = "UICorner"
store.UICorner159.Parent = store.TextButton82

store["TextButton83"] = Instance.new("TextButton")
store.TextButton83.Name = "TextButton"
store.TextButton83.ZIndex = 5
store.TextButton83.Position = UDim2.new(1,-122,0,35)
store.TextButton83.Size = UDim2.new(0,52,0,24)
store.TextButton83.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton83.BackgroundTransparency = 0.5
store.TextButton83.BorderSizePixel = 0
store.TextButton83.Text = "Avatar"
store.TextButton83.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton83.TextSize = 10
store.TextButton83.Font = Enum.Font.GothamBold
store.TextButton83.AutoButtonColor = false
store.TextButton83.Parent = store.DropdownPanel6

store["UICorner160"] = Instance.new("UICorner")
store.UICorner160.Name = "UICorner"
store.UICorner160.Parent = store.TextButton83

store["TextButton84"] = Instance.new("TextButton")
store.TextButton84.Name = "TextButton"
store.TextButton84.ZIndex = 5
store.TextButton84.Position = UDim2.new(1,-64,0,35)
store.TextButton84.Size = UDim2.new(0,52,0,24)
store.TextButton84.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton84.BackgroundTransparency = 0.5
store.TextButton84.BorderSizePixel = 0
store.TextButton84.Text = "Timer"
store.TextButton84.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton84.TextSize = 10
store.TextButton84.Font = Enum.Font.GothamBold
store.TextButton84.AutoButtonColor = false
store.TextButton84.Parent = store.DropdownPanel6

store["UICorner161"] = Instance.new("UICorner")
store.UICorner161.Name = "UICorner"
store.UICorner161.Parent = store.TextButton84

store["Frame181"] = Instance.new("Frame")
store.Frame181.Name = "Frame"
store.Frame181.ZIndex = 4
store.Frame181.LayoutOrder = 39
store.Frame181.Size = UDim2.new(1,0,0,62)
store.Frame181.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame181.BackgroundTransparency = 0.5
store.Frame181.BorderSizePixel = 0
store.Frame181.Parent = store.Page_Visual

store["UICorner162"] = Instance.new("UICorner")
store.UICorner162.Name = "UICorner"
store.UICorner162.CornerRadius = UDim.new(0,12)
store.UICorner162.Parent = store.Frame181

store["UIStroke103"] = Instance.new("UIStroke")
store.UIStroke103.Name = "UIStroke"
store.UIStroke103.Color = Color3.fromRGB(35,35,45)
store.UIStroke103.Transparency = 0.4
store.UIStroke103.Parent = store.Frame181

store["TextLabel87"] = Instance.new("TextLabel")
store.TextLabel87.Name = "TextLabel"
store.TextLabel87.ZIndex = 5
store.TextLabel87.Position = UDim2.new(0,12,0,8)
store.TextLabel87.Size = UDim2.new(0.7,0,0,16)
store.TextLabel87.BackgroundTransparency = 1
store.TextLabel87.Text = "Korblox"
store.TextLabel87.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel87.TextSize = 11
store.TextLabel87.Font = Enum.Font.GothamBold
store.TextLabel87.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel87.Parent = store.Frame181

store["Frame182"] = Instance.new("Frame")
store.Frame182.Name = "Frame"
store.Frame182.Visible = false
store.Frame182.ZIndex = 5
store.Frame182.Position = UDim2.new(0,12,0,26)
store.Frame182.Size = UDim2.new(0,38,0,1)
store.Frame182.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame182.BackgroundTransparency = 0.5
store.Frame182.BorderSizePixel = 0
store.Frame182.Parent = store.Frame181

store["TextLabel88"] = Instance.new("TextLabel")
store.TextLabel88.Name = "TextLabel"
store.TextLabel88.ZIndex = 6
store.TextLabel88.Position = UDim2.new(0,54,1,-34)
store.TextLabel88.Size = UDim2.new(1,-108,0,26)
store.TextLabel88.BackgroundTransparency = 1
store.TextLabel88.Text = "OFF"
store.TextLabel88.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel88.TextSize = 11
store.TextLabel88.Font = Enum.Font.GothamBold
store.TextLabel88.Parent = store.Frame181

store["TextButton85"] = Instance.new("TextButton")
store.TextButton85.Name = "TextButton"
store.TextButton85.ZIndex = 7
store.TextButton85.Position = UDim2.new(0,12,1,-34)
store.TextButton85.Size = UDim2.new(0,34,0,26)
store.TextButton85.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton85.BackgroundTransparency = 0.5
store.TextButton85.BorderSizePixel = 0
store.TextButton85.Text = "<"
store.TextButton85.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton85.TextSize = 13
store.TextButton85.Font = Enum.Font.GothamBlack
store.TextButton85.AutoButtonColor = false
store.TextButton85.Parent = store.Frame181

store["UICorner163"] = Instance.new("UICorner")
store.UICorner163.Name = "UICorner"
store.UICorner163.Parent = store.TextButton85

store["UIStroke104"] = Instance.new("UIStroke")
store.UIStroke104.Name = "UIStroke"
store.UIStroke104.Color = Color3.fromRGB(254,254,254)
store.UIStroke104.Thickness = 1.4
store.UIStroke104.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke104.Transparency = 0.25
store.UIStroke104.Parent = store.TextButton85

store["UIGradient35"] = Instance.new("UIGradient")
store.UIGradient35.Name = "UIGradient"
store.UIGradient35.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient35.Parent = store.UIStroke104

store["TextButton86"] = Instance.new("TextButton")
store.TextButton86.Name = "TextButton"
store.TextButton86.ZIndex = 7
store.TextButton86.Position = UDim2.new(1,-46,1,-34)
store.TextButton86.Size = UDim2.new(0,34,0,26)
store.TextButton86.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton86.BackgroundTransparency = 0.5
store.TextButton86.BorderSizePixel = 0
store.TextButton86.Text = ">"
store.TextButton86.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton86.TextSize = 13
store.TextButton86.Font = Enum.Font.GothamBlack
store.TextButton86.AutoButtonColor = false
store.TextButton86.Parent = store.Frame181

store["UICorner164"] = Instance.new("UICorner")
store.UICorner164.Name = "UICorner"
store.UICorner164.Parent = store.TextButton86

store["UIStroke105"] = Instance.new("UIStroke")
store.UIStroke105.Name = "UIStroke"
store.UIStroke105.Color = Color3.fromRGB(254,254,254)
store.UIStroke105.Thickness = 1.4
store.UIStroke105.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke105.Transparency = 0.25
store.UIStroke105.Parent = store.TextButton86

store["UIGradient36"] = Instance.new("UIGradient")
store.UIGradient36.Name = "UIGradient"
store.UIGradient36.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient36.Parent = store.UIStroke105

store["Frame183"] = Instance.new("Frame")
store.Frame183.Name = "Frame"
store.Frame183.ZIndex = 4
store.Frame183.LayoutOrder = 38
store.Frame183.Size = UDim2.new(1,0,0,40)
store.Frame183.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame183.BackgroundTransparency = 0.5
store.Frame183.BorderSizePixel = 0
store.Frame183.Parent = store.Page_Visual

store["UICorner165"] = Instance.new("UICorner")
store.UICorner165.Name = "UICorner"
store.UICorner165.CornerRadius = UDim.new(0,10)
store.UICorner165.Parent = store.Frame183

store["UIStroke106"] = Instance.new("UIStroke")
store.UIStroke106.Name = "UIStroke"
store.UIStroke106.Color = Color3.fromRGB(28,28,34)
store.UIStroke106.Parent = store.Frame183

store["TextLabel89"] = Instance.new("TextLabel")
store.TextLabel89.Name = "TextLabel"
store.TextLabel89.ZIndex = 5
store.TextLabel89.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel89.Size = UDim2.new(0.6,0,0,16)
store.TextLabel89.BackgroundTransparency = 1
store.TextLabel89.Text = "Headless"
store.TextLabel89.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel89.TextSize = 11
store.TextLabel89.Font = Enum.Font.GothamBold
store.TextLabel89.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel89.Parent = store.Frame183

store["Frame184"] = Instance.new("Frame")
store.Frame184.Name = "Frame"
store.Frame184.Visible = false
store.Frame184.ZIndex = 5
store.Frame184.Position = UDim2.new(0,12,0.5,7)
store.Frame184.Size = UDim2.new(0,44,0,1)
store.Frame184.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame184.BackgroundTransparency = 0.5
store.Frame184.BorderSizePixel = 0
store.Frame184.Parent = store.Frame183

store["Frame185"] = Instance.new("Frame")
store.Frame185.Name = "Frame"
store.Frame185.ZIndex = 6
store.Frame185.Position = UDim2.new(1,-44,0.5,-8)
store.Frame185.Size = UDim2.new(0,32,0,16)
store.Frame185.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame185.BackgroundTransparency = 0.5
store.Frame185.BorderSizePixel = 0
store.Frame185.Parent = store.Frame183

store["UICorner166"] = Instance.new("UICorner")
store.UICorner166.Name = "UICorner"
store.UICorner166.CornerRadius = UDim.new(1,0)
store.UICorner166.Parent = store.Frame185

store["UIStroke107"] = Instance.new("UIStroke")
store.UIStroke107.Name = "UIStroke"
store.UIStroke107.Color = Color3.fromRGB(70,70,70)
store.UIStroke107.Transparency = 0.5
store.UIStroke107.Parent = store.Frame185

store["Frame186"] = Instance.new("Frame")
store.Frame186.Name = "Frame"
store.Frame186.ZIndex = 7
store.Frame186.Position = UDim2.new(0,2,0.5,-6)
store.Frame186.Size = UDim2.new(0,12,0,12)
store.Frame186.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame186.BackgroundTransparency = 0.5
store.Frame186.BorderSizePixel = 0
store.Frame186.Parent = store.Frame185

store["UICorner167"] = Instance.new("UICorner")
store.UICorner167.Name = "UICorner"
store.UICorner167.CornerRadius = UDim.new(1,0)
store.UICorner167.Parent = store.Frame186

store["TextButton87"] = Instance.new("TextButton")
store.TextButton87.Name = "TextButton"
store.TextButton87.ZIndex = 8
store.TextButton87.Size = UDim2.new(1,0,1,0)
store.TextButton87.BackgroundTransparency = 1
store.TextButton87.Text = ""
store.TextButton87.Parent = store.Frame183

store["PressPop18"] = Instance.new("UIScale")
store.PressPop18.Name = "PressPop"
store.PressPop18.Parent = store.Frame183

store["Frame187"] = Instance.new("Frame")
store.Frame187.Name = "Frame"
store.Frame187.ZIndex = 4
store.Frame187.LayoutOrder = 42
store.Frame187.Size = UDim2.new(1,0,0,40)
store.Frame187.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame187.BackgroundTransparency = 0.5
store.Frame187.BorderSizePixel = 0
store.Frame187.Parent = store.Page_Visual

store["UICorner168"] = Instance.new("UICorner")
store.UICorner168.Name = "UICorner"
store.UICorner168.CornerRadius = UDim.new(0,10)
store.UICorner168.Parent = store.Frame187

store["UIStroke108"] = Instance.new("UIStroke")
store.UIStroke108.Name = "UIStroke"
store.UIStroke108.Color = Color3.fromRGB(28,28,34)
store.UIStroke108.Parent = store.Frame187

store["TextLabel90"] = Instance.new("TextLabel")
store.TextLabel90.Name = "TextLabel"
store.TextLabel90.ZIndex = 5
store.TextLabel90.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel90.Size = UDim2.new(0.6,0,0,16)
store.TextLabel90.BackgroundTransparency = 1
store.TextLabel90.Text = "Anti Lag"
store.TextLabel90.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel90.TextSize = 11
store.TextLabel90.Font = Enum.Font.GothamBold
store.TextLabel90.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel90.Parent = store.Frame187

store["Frame188"] = Instance.new("Frame")
store.Frame188.Name = "Frame"
store.Frame188.Visible = false
store.Frame188.ZIndex = 5
store.Frame188.Position = UDim2.new(0,12,0.5,7)
store.Frame188.Size = UDim2.new(0,41,0,1)
store.Frame188.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame188.BackgroundTransparency = 0.5
store.Frame188.BorderSizePixel = 0
store.Frame188.Parent = store.Frame187

store["Frame189"] = Instance.new("Frame")
store.Frame189.Name = "Frame"
store.Frame189.ZIndex = 6
store.Frame189.Position = UDim2.new(1,-44,0.5,-8)
store.Frame189.Size = UDim2.new(0,32,0,16)
store.Frame189.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame189.BackgroundTransparency = 0.5
store.Frame189.BorderSizePixel = 0
store.Frame189.Parent = store.Frame187

store["UICorner169"] = Instance.new("UICorner")
store.UICorner169.Name = "UICorner"
store.UICorner169.CornerRadius = UDim.new(1,0)
store.UICorner169.Parent = store.Frame189

store["UIStroke109"] = Instance.new("UIStroke")
store.UIStroke109.Name = "UIStroke"
store.UIStroke109.Color = Color3.fromRGB(70,70,70)
store.UIStroke109.Transparency = 0.5
store.UIStroke109.Parent = store.Frame189

store["Frame190"] = Instance.new("Frame")
store.Frame190.Name = "Frame"
store.Frame190.ZIndex = 7
store.Frame190.Position = UDim2.new(0,2,0.5,-6)
store.Frame190.Size = UDim2.new(0,12,0,12)
store.Frame190.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame190.BackgroundTransparency = 0.5
store.Frame190.BorderSizePixel = 0
store.Frame190.Parent = store.Frame189

store["UICorner170"] = Instance.new("UICorner")
store.UICorner170.Name = "UICorner"
store.UICorner170.CornerRadius = UDim.new(1,0)
store.UICorner170.Parent = store.Frame190

store["TextButton88"] = Instance.new("TextButton")
store.TextButton88.Name = "TextButton"
store.TextButton88.ZIndex = 8
store.TextButton88.Size = UDim2.new(1,0,1,0)
store.TextButton88.BackgroundTransparency = 1
store.TextButton88.Text = ""
store.TextButton88.Parent = store.Frame187

store["PressPop19"] = Instance.new("UIScale")
store.PressPop19.Name = "PressPop"
store.PressPop19.Parent = store.Frame187

store["Frame191"] = Instance.new("Frame")
store.Frame191.Name = "Frame"
store.Frame191.ZIndex = 4
store.Frame191.LayoutOrder = 44
store.Frame191.Size = UDim2.new(1,0,0,40)
store.Frame191.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame191.BackgroundTransparency = 0.5
store.Frame191.BorderSizePixel = 0
store.Frame191.Parent = store.Page_Visual

store["UICorner171"] = Instance.new("UICorner")
store.UICorner171.Name = "UICorner"
store.UICorner171.CornerRadius = UDim.new(0,10)
store.UICorner171.Parent = store.Frame191

store["UIStroke110"] = Instance.new("UIStroke")
store.UIStroke110.Name = "UIStroke"
store.UIStroke110.Color = Color3.fromRGB(28,28,34)
store.UIStroke110.Parent = store.Frame191

store["TextLabel91"] = Instance.new("TextLabel")
store.TextLabel91.Name = "TextLabel"
store.TextLabel91.ZIndex = 5
store.TextLabel91.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel91.Size = UDim2.new(0.6,0,0,16)
store.TextLabel91.BackgroundTransparency = 1
store.TextLabel91.Text = "Potato Graphics"
store.TextLabel91.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel91.TextSize = 11
store.TextLabel91.Font = Enum.Font.GothamBold
store.TextLabel91.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel91.Parent = store.Frame191

store["Frame192"] = Instance.new("Frame")
store.Frame192.Name = "Frame"
store.Frame192.Visible = false
store.Frame192.ZIndex = 5
store.Frame192.Position = UDim2.new(0,12,0.5,7)
store.Frame192.Size = UDim2.new(0,78,0,1)
store.Frame192.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame192.BackgroundTransparency = 0.5
store.Frame192.BorderSizePixel = 0
store.Frame192.Parent = store.Frame191

store["Frame193"] = Instance.new("Frame")
store.Frame193.Name = "Frame"
store.Frame193.ZIndex = 6
store.Frame193.Position = UDim2.new(1,-44,0.5,-8)
store.Frame193.Size = UDim2.new(0,32,0,16)
store.Frame193.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame193.BackgroundTransparency = 0.5
store.Frame193.BorderSizePixel = 0
store.Frame193.Parent = store.Frame191

store["UICorner172"] = Instance.new("UICorner")
store.UICorner172.Name = "UICorner"
store.UICorner172.CornerRadius = UDim.new(1,0)
store.UICorner172.Parent = store.Frame193

store["UIStroke111"] = Instance.new("UIStroke")
store.UIStroke111.Name = "UIStroke"
store.UIStroke111.Color = Color3.fromRGB(70,70,70)
store.UIStroke111.Transparency = 0.5
store.UIStroke111.Parent = store.Frame193

store["Frame194"] = Instance.new("Frame")
store.Frame194.Name = "Frame"
store.Frame194.ZIndex = 7
store.Frame194.Position = UDim2.new(0,2,0.5,-6)
store.Frame194.Size = UDim2.new(0,12,0,12)
store.Frame194.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame194.BackgroundTransparency = 0.5
store.Frame194.BorderSizePixel = 0
store.Frame194.Parent = store.Frame193

store["UICorner173"] = Instance.new("UICorner")
store.UICorner173.Name = "UICorner"
store.UICorner173.CornerRadius = UDim.new(1,0)
store.UICorner173.Parent = store.Frame194

store["TextButton89"] = Instance.new("TextButton")
store.TextButton89.Name = "TextButton"
store.TextButton89.ZIndex = 8
store.TextButton89.Size = UDim2.new(1,0,1,0)
store.TextButton89.BackgroundTransparency = 1
store.TextButton89.Text = ""
store.TextButton89.Parent = store.Frame191

store["PressPop20"] = Instance.new("UIScale")
store.PressPop20.Name = "PressPop"
store.PressPop20.Parent = store.Frame191

store["Frame195"] = Instance.new("Frame")
store.Frame195.Name = "Frame"
store.Frame195.ZIndex = 4
store.Frame195.LayoutOrder = 46
store.Frame195.Size = UDim2.new(1,0,0,40)
store.Frame195.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame195.BackgroundTransparency = 0.5
store.Frame195.BorderSizePixel = 0
store.Frame195.Parent = store.Page_Visual

store["UICorner174"] = Instance.new("UICorner")
store.UICorner174.Name = "UICorner"
store.UICorner174.CornerRadius = UDim.new(0,10)
store.UICorner174.Parent = store.Frame195

store["UIStroke112"] = Instance.new("UIStroke")
store.UIStroke112.Name = "UIStroke"
store.UIStroke112.Color = Color3.fromRGB(28,28,34)
store.UIStroke112.Parent = store.Frame195

store["TextLabel92"] = Instance.new("TextLabel")
store.TextLabel92.Name = "TextLabel"
store.TextLabel92.ZIndex = 5
store.TextLabel92.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel92.Size = UDim2.new(0.6,0,0,16)
store.TextLabel92.BackgroundTransparency = 1
store.TextLabel92.Text = "Shiny Mode"
store.TextLabel92.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel92.TextSize = 11
store.TextLabel92.Font = Enum.Font.GothamBold
store.TextLabel92.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel92.Parent = store.Frame195

store["Frame196"] = Instance.new("Frame")
store.Frame196.Name = "Frame"
store.Frame196.Visible = false
store.Frame196.ZIndex = 5
store.Frame196.Position = UDim2.new(0,12,0.5,7)
store.Frame196.Size = UDim2.new(0,57,0,1)
store.Frame196.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame196.BackgroundTransparency = 0.5
store.Frame196.BorderSizePixel = 0
store.Frame196.Parent = store.Frame195

store["Frame197"] = Instance.new("Frame")
store.Frame197.Name = "Frame"
store.Frame197.ZIndex = 6
store.Frame197.Position = UDim2.new(1,-44,0.5,-8)
store.Frame197.Size = UDim2.new(0,32,0,16)
store.Frame197.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame197.BackgroundTransparency = 0.5
store.Frame197.BorderSizePixel = 0
store.Frame197.Parent = store.Frame195

store["UICorner175"] = Instance.new("UICorner")
store.UICorner175.Name = "UICorner"
store.UICorner175.CornerRadius = UDim.new(1,0)
store.UICorner175.Parent = store.Frame197

store["UIStroke113"] = Instance.new("UIStroke")
store.UIStroke113.Name = "UIStroke"
store.UIStroke113.Color = Color3.fromRGB(70,70,70)
store.UIStroke113.Transparency = 0.5
store.UIStroke113.Parent = store.Frame197

store["Frame198"] = Instance.new("Frame")
store.Frame198.Name = "Frame"
store.Frame198.ZIndex = 7
store.Frame198.Position = UDim2.new(0,2,0.5,-6)
store.Frame198.Size = UDim2.new(0,12,0,12)
store.Frame198.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame198.BackgroundTransparency = 0.5
store.Frame198.BorderSizePixel = 0
store.Frame198.Parent = store.Frame197

store["UICorner176"] = Instance.new("UICorner")
store.UICorner176.Name = "UICorner"
store.UICorner176.CornerRadius = UDim.new(1,0)
store.UICorner176.Parent = store.Frame198

store["TextButton90"] = Instance.new("TextButton")
store.TextButton90.Name = "TextButton"
store.TextButton90.ZIndex = 8
store.TextButton90.Size = UDim2.new(1,0,1,0)
store.TextButton90.BackgroundTransparency = 1
store.TextButton90.Text = ""
store.TextButton90.Parent = store.Frame195

store["PressPop21"] = Instance.new("UIScale")
store.PressPop21.Name = "PressPop"
store.PressPop21.Parent = store.Frame195

store["Frame199"] = Instance.new("Frame")
store.Frame199.Name = "Frame"
store.Frame199.ZIndex = 4
store.Frame199.LayoutOrder = 48
store.Frame199.Size = UDim2.new(1,0,0,40)
store.Frame199.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame199.BackgroundTransparency = 0.5
store.Frame199.BorderSizePixel = 0
store.Frame199.Parent = store.Page_Visual

store["UICorner177"] = Instance.new("UICorner")
store.UICorner177.Name = "UICorner"
store.UICorner177.CornerRadius = UDim.new(0,10)
store.UICorner177.Parent = store.Frame199

store["UIStroke114"] = Instance.new("UIStroke")
store.UIStroke114.Name = "UIStroke"
store.UIStroke114.Color = Color3.fromRGB(28,28,34)
store.UIStroke114.Parent = store.Frame199

store["TextLabel93"] = Instance.new("TextLabel")
store.TextLabel93.Name = "TextLabel"
store.TextLabel93.ZIndex = 5
store.TextLabel93.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel93.Size = UDim2.new(0.6,0,0,16)
store.TextLabel93.BackgroundTransparency = 1
store.TextLabel93.Text = "Dark Mode"
store.TextLabel93.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel93.TextSize = 11
store.TextLabel93.Font = Enum.Font.GothamBold
store.TextLabel93.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel93.Parent = store.Frame199

store["Frame200"] = Instance.new("Frame")
store.Frame200.Name = "Frame"
store.Frame200.Visible = false
store.Frame200.ZIndex = 5
store.Frame200.Position = UDim2.new(0,12,0.5,7)
store.Frame200.Size = UDim2.new(0,54,0,1)
store.Frame200.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame200.BackgroundTransparency = 0.5
store.Frame200.BorderSizePixel = 0
store.Frame200.Parent = store.Frame199

store["Frame201"] = Instance.new("Frame")
store.Frame201.Name = "Frame"
store.Frame201.ZIndex = 6
store.Frame201.Position = UDim2.new(1,-44,0.5,-8)
store.Frame201.Size = UDim2.new(0,32,0,16)
store.Frame201.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame201.BackgroundTransparency = 0.5
store.Frame201.BorderSizePixel = 0
store.Frame201.Parent = store.Frame199

store["UICorner178"] = Instance.new("UICorner")
store.UICorner178.Name = "UICorner"
store.UICorner178.CornerRadius = UDim.new(1,0)
store.UICorner178.Parent = store.Frame201

store["UIStroke115"] = Instance.new("UIStroke")
store.UIStroke115.Name = "UIStroke"
store.UIStroke115.Color = Color3.fromRGB(70,70,70)
store.UIStroke115.Transparency = 0.5
store.UIStroke115.Parent = store.Frame201

store["Frame202"] = Instance.new("Frame")
store.Frame202.Name = "Frame"
store.Frame202.ZIndex = 7
store.Frame202.Position = UDim2.new(0,2,0.5,-6)
store.Frame202.Size = UDim2.new(0,12,0,12)
store.Frame202.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame202.BackgroundTransparency = 0.5
store.Frame202.BorderSizePixel = 0
store.Frame202.Parent = store.Frame201

store["UICorner179"] = Instance.new("UICorner")
store.UICorner179.Name = "UICorner"
store.UICorner179.CornerRadius = UDim.new(1,0)
store.UICorner179.Parent = store.Frame202

store["TextButton91"] = Instance.new("TextButton")
store.TextButton91.Name = "TextButton"
store.TextButton91.ZIndex = 8
store.TextButton91.Size = UDim2.new(1,0,1,0)
store.TextButton91.BackgroundTransparency = 1
store.TextButton91.Text = ""
store.TextButton91.Parent = store.Frame199

store["PressPop22"] = Instance.new("UIScale")
store.PressPop22.Name = "PressPop"
store.PressPop22.Parent = store.Frame199

store["TextButton92"] = Instance.new("TextButton")
store.TextButton92.Name = "TextButton"
store.TextButton92.ZIndex = 12
store.TextButton92.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton92.Size = UDim2.new(0,32,0,22)
store.TextButton92.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton92.BackgroundTransparency = 0.5
store.TextButton92.BorderSizePixel = 0
store.TextButton92.Text = ""
store.TextButton92.AutoButtonColor = false
store.TextButton92.Parent = store.Frame199

store["UICorner180"] = Instance.new("UICorner")
store.UICorner180.Name = "UICorner"
store.UICorner180.CornerRadius = UDim.new(0,6)
store.UICorner180.Parent = store.TextButton92

store["UIStroke116"] = Instance.new("UIStroke")
store.UIStroke116.Name = "UIStroke"
store.UIStroke116.Color = Color3.fromRGB(254,254,254)
store.UIStroke116.Thickness = 1.4
store.UIStroke116.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke116.Transparency = 0.25
store.UIStroke116.Parent = store.TextButton92

store["UIGradient37"] = Instance.new("UIGradient")
store.UIGradient37.Name = "UIGradient"
store.UIGradient37.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient37.Parent = store.UIStroke116

store["TextLabel94"] = Instance.new("TextLabel")
store.TextLabel94.Name = "TextLabel"
store.TextLabel94.ZIndex = 20
store.TextLabel94.Size = UDim2.new(1,0,1,0)
store.TextLabel94.BackgroundTransparency = 1
store.TextLabel94.Text = "▼"
store.TextLabel94.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel94.TextSize = 15
store.TextLabel94.Font = Enum.Font.GothamBlack
store.TextLabel94.Parent = store.TextButton92

store["Frame203"] = Instance.new("Frame")
store.Frame203.Name = "Frame"
store.Frame203.Visible = false
store.Frame203.ZIndex = 4
store.Frame203.LayoutOrder = 49
store.Frame203.Size = UDim2.new(1,0,0,58)
store.Frame203.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame203.BackgroundTransparency = 0.5
store.Frame203.BorderSizePixel = 0
store.Frame203.Parent = store.Page_Visual

store["UICorner181"] = Instance.new("UICorner")
store.UICorner181.Name = "UICorner"
store.UICorner181.CornerRadius = UDim.new(0,12)
store.UICorner181.Parent = store.Frame203

store["UIStroke117"] = Instance.new("UIStroke")
store.UIStroke117.Name = "UIStroke"
store.UIStroke117.Color = Color3.fromRGB(35,35,45)
store.UIStroke117.Transparency = 0.4
store.UIStroke117.Parent = store.Frame203

store["TextLabel95"] = Instance.new("TextLabel")
store.TextLabel95.Name = "TextLabel"
store.TextLabel95.ZIndex = 5
store.TextLabel95.Position = UDim2.new(0,12,0,11)
store.TextLabel95.Size = UDim2.new(0.6,0,0,16)
store.TextLabel95.BackgroundTransparency = 1
store.TextLabel95.Text = "Darkness"
store.TextLabel95.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel95.TextSize = 11
store.TextLabel95.Font = Enum.Font.GothamBold
store.TextLabel95.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel95.Parent = store.Frame203

store["Frame204"] = Instance.new("Frame")
store.Frame204.Name = "Frame"
store.Frame204.Visible = false
store.Frame204.ZIndex = 5
store.Frame204.Position = UDim2.new(0,12,0,27)
store.Frame204.Size = UDim2.new(0,46,0,1)
store.Frame204.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame204.BackgroundTransparency = 0.5
store.Frame204.BorderSizePixel = 0
store.Frame204.Parent = store.Frame203

store["Frame205"] = Instance.new("Frame")
store.Frame205.Name = "Frame"
store.Frame205.ZIndex = 5
store.Frame205.Position = UDim2.new(1,-64,0,9)
store.Frame205.Size = UDim2.new(0,52,0,24)
store.Frame205.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame205.BackgroundTransparency = 0.5
store.Frame205.BorderSizePixel = 0
store.Frame205.Parent = store.Frame203

store["UICorner182"] = Instance.new("UICorner")
store.UICorner182.Name = "UICorner"
store.UICorner182.Parent = store.Frame205

store["UIStroke118"] = Instance.new("UIStroke")
store.UIStroke118.Name = "UIStroke"
store.UIStroke118.Color = Color3.fromRGB(254,254,254)
store.UIStroke118.Thickness = 1.4
store.UIStroke118.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke118.Transparency = 0.25
store.UIStroke118.Parent = store.Frame205

store["UIGradient38"] = Instance.new("UIGradient")
store.UIGradient38.Name = "UIGradient"
store.UIGradient38.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient38.Parent = store.UIStroke118

store["TextLabel96"] = Instance.new("TextLabel")
store.TextLabel96.Name = "TextLabel"
store.TextLabel96.ZIndex = 6
store.TextLabel96.Size = UDim2.new(1,0,1,0)
store.TextLabel96.BackgroundTransparency = 1
store.TextLabel96.Text = "2.0"
store.TextLabel96.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel96.TextSize = 11
store.TextLabel96.Font = Enum.Font.GothamBold
store.TextLabel96.Parent = store.Frame205

store["Frame206"] = Instance.new("Frame")
store.Frame206.Name = "Frame"
store.Frame206.ZIndex = 5
store.Frame206.Position = UDim2.new(0,12,1,-18)
store.Frame206.Size = UDim2.new(1,-24,0,6)
store.Frame206.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame206.BackgroundTransparency = 0.5
store.Frame206.BorderSizePixel = 0
store.Frame206.Parent = store.Frame203

store["UICorner183"] = Instance.new("UICorner")
store.UICorner183.Name = "UICorner"
store.UICorner183.CornerRadius = UDim.new(1,0)
store.UICorner183.Parent = store.Frame206

store["UIStroke119"] = Instance.new("UIStroke")
store.UIStroke119.Name = "UIStroke"
store.UIStroke119.Color = Color3.fromRGB(254,254,254)
store.UIStroke119.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke119.Transparency = 0.75
store.UIStroke119.Parent = store.Frame206

store["Frame207"] = Instance.new("Frame")
store.Frame207.Name = "Frame"
store.Frame207.ZIndex = 6
store.Frame207.Size = UDim2.new(0.2,0,1,0)
store.Frame207.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame207.BackgroundTransparency = 0.5
store.Frame207.BorderSizePixel = 0
store.Frame207.Parent = store.Frame206

store["UICorner184"] = Instance.new("UICorner")
store.UICorner184.Name = "UICorner"
store.UICorner184.CornerRadius = UDim.new(1,0)
store.UICorner184.Parent = store.Frame207

store["SliderKnob2"] = Instance.new("Frame")
store.SliderKnob2.Name = "SliderKnob"
store.SliderKnob2.ZIndex = 8
store.SliderKnob2.AnchorPoint = Vector2.new(0.5,0.5)
store.SliderKnob2.Position = UDim2.new(0.2,0,0.5,0)
store.SliderKnob2.Size = UDim2.new(0,16,0,16)
store.SliderKnob2.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.SliderKnob2.BorderSizePixel = 0
store.SliderKnob2.Parent = store.Frame206

store["UICorner185"] = Instance.new("UICorner")
store.UICorner185.Name = "UICorner"
store.UICorner185.CornerRadius = UDim.new(1,0)
store.UICorner185.Parent = store.SliderKnob2

store["UIStroke120"] = Instance.new("UIStroke")
store.UIStroke120.Name = "UIStroke"
store.UIStroke120.Color = Color3.fromRGB(254,254,254)
store.UIStroke120.Thickness = 1.5
store.UIStroke120.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke120.Transparency = 0.2
store.UIStroke120.Parent = store.SliderKnob2

store["TextButton93"] = Instance.new("TextButton")
store.TextButton93.Name = "TextButton"
store.TextButton93.ZIndex = 9
store.TextButton93.Position = UDim2.new(0,12,1,-28)
store.TextButton93.Size = UDim2.new(1,-24,0,26)
store.TextButton93.BackgroundTransparency = 1
store.TextButton93.Text = ""
store.TextButton93.AutoButtonColor = false
store.TextButton93.Parent = store.Frame203

-- Settings Page
store["Page_Settings"] = Instance.new("Frame")
store.Page_Settings.Name = "Page_Settings"
store.Page_Settings.ZIndex = 3
store.Page_Settings.LayoutOrder = 6001
store.Page_Settings.Size = UDim2.new(1,0,0,0)
store.Page_Settings.BackgroundTransparency = 1
store.Page_Settings.BorderSizePixel = 0
store.Page_Settings.Parent = store.ScrollingFrame

store["UIListLayout9"] = Instance.new("UIListLayout")
store.UIListLayout9.Name = "UIListLayout"
store.UIListLayout9.Padding = UDim.new(0,10)
store.UIListLayout9.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout9.Parent = store.Page_Settings

store["UIPadding9"] = Instance.new("UIPadding")
store.UIPadding9.Name = "UIPadding"
store.UIPadding9.PaddingTop = UDim.new(0,10)
store.UIPadding9.PaddingLeft = UDim.new(0,12)
store.UIPadding9.PaddingRight = UDim.new(0,12)
store.UIPadding9.Parent = store.Page_Settings

store["Frame208"] = Instance.new("Frame")
store.Frame208.Name = "Frame"
store.Frame208.ZIndex = 4
store.Frame208.LayoutOrder = 4
store.Frame208.Size = UDim2.new(1,0,0,104)
store.Frame208.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame208.BackgroundTransparency = 0.5
store.Frame208.BorderSizePixel = 0
store.Frame208.Parent = store.Page_Settings

store["UICorner186"] = Instance.new("UICorner")
store.UICorner186.Name = "UICorner"
store.UICorner186.CornerRadius = UDim.new(0,12)
store.UICorner186.Parent = store.Frame208

store["UIStroke121"] = Instance.new("UIStroke")
store.UIStroke121.Name = "UIStroke"
store.UIStroke121.Color = Color3.fromRGB(40,44,56)
store.UIStroke121.Transparency = 0.5
store.UIStroke121.Parent = store.Frame208

store["TextLabel97"] = Instance.new("TextLabel")
store.TextLabel97.Name = "TextLabel"
store.TextLabel97.ZIndex = 5
store.TextLabel97.Position = UDim2.new(0,12,0,6)
store.TextLabel97.Size = UDim2.new(1,-24,0,20)
store.TextLabel97.BackgroundTransparency = 1
store.TextLabel97.Text = "Background Image"
store.TextLabel97.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel97.TextSize = 12
store.TextLabel97.Font = Enum.Font.GothamBold
store.TextLabel97.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel97.Parent = store.Frame208

store["Frame209"] = Instance.new("Frame")
store.Frame209.Name = "Frame"
store.Frame209.Visible = false
store.Frame209.ZIndex = 5
store.Frame209.Position = UDim2.new(0,12,0,26)
store.Frame209.Size = UDim2.new(0,102,0,1)
store.Frame209.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame209.BackgroundTransparency = 0.5
store.Frame209.BorderSizePixel = 0
store.Frame209.Parent = store.Frame208

store["ScrollingFrame2"] = Instance.new("ScrollingFrame")
store.ScrollingFrame2.Name = "ScrollingFrame"
store.ScrollingFrame2.ZIndex = 5
store.ScrollingFrame2.Position = UDim2.new(0,42,0,34)
store.ScrollingFrame2.Size = UDim2.new(1,-84,0,64)
store.ScrollingFrame2.BackgroundTransparency = 1
store.ScrollingFrame2.BorderSizePixel = 0
store.ScrollingFrame2.ScrollBarThickness = 0
store.ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.X
store.ScrollingFrame2.CanvasSize = UDim2.new(0,0,0,0)
store.ScrollingFrame2.Parent = store.Frame208

store["UIListLayout10"] = Instance.new("UIListLayout")
store.UIListLayout10.Name = "UIListLayout"
store.UIListLayout10.Padding = UDim.new(0,8)
store.UIListLayout10.FillDirection = Enum.FillDirection.Horizontal
store.UIListLayout10.VerticalAlignment = Enum.VerticalAlignment.Center
store.UIListLayout10.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout10.Parent = store.ScrollingFrame2

store["UIPadding10"] = Instance.new("UIPadding")
store.UIPadding10.Name = "UIPadding"
store.UIPadding10.PaddingLeft = UDim.new(0,4)
store.UIPadding10.PaddingRight = UDim.new(0,4)
store.UIPadding10.Parent = store.ScrollingFrame2

store["ImageButton"] = Instance.new("ImageButton")
store.ImageButton.Name = "ImageButton"
store.ImageButton.ZIndex = 6
store.ImageButton.LayoutOrder = 1
store.ImageButton.Size = UDim2.new(0,56,0,56)
store.ImageButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.ImageButton.BackgroundTransparency = 0.5
store.ImageButton.BorderSizePixel = 0
store.ImageButton.ScaleType = Enum.ScaleType.Crop
store.ImageButton.AutoButtonColor = false
store.ImageButton.Parent = store.ScrollingFrame2

store["UICorner187"] = Instance.new("UICorner")
store.UICorner187.Name = "UICorner"
store.UICorner187.Parent = store.ImageButton

store["UIStroke122"] = Instance.new("UIStroke")
store.UIStroke122.Name = "UIStroke"
store.UIStroke122.Color = Color3.fromRGB(254,254,254)
store.UIStroke122.Thickness = 2
store.UIStroke122.Parent = store.ImageButton

store["TextLabel98"] = Instance.new("TextLabel")
store.TextLabel98.Name = "TextLabel"
store.TextLabel98.ZIndex = 7
store.TextLabel98.Size = UDim2.new(1,0,1,0)
store.TextLabel98.BackgroundTransparency = 1
store.TextLabel98.Text = "None"
store.TextLabel98.TextColor3 = Color3.fromRGB(150,150,155)
store.TextLabel98.TextSize = 9
store.TextLabel98.Font = Enum.Font.GothamBold
store.TextLabel98.Parent = store.ImageButton

store["Tick"] = Instance.new("TextLabel")
store.Tick.Name = "Tick"
store.Tick.ZIndex = 8
store.Tick.Position = UDim2.new(1,-18,0,2)
store.Tick.Size = UDim2.new(0,16,0,16)
store.Tick.BackgroundTransparency = 1
store.Tick.Text = "✓"
store.Tick.TextColor3 = Color3.fromRGB(254,254,254)
store.Tick.TextSize = 13
store.Tick.Font = Enum.Font.GothamBlack
store.Tick.Parent = store.ImageButton

store["ImageButton2"] = Instance.new("ImageButton")
store.ImageButton2.Name = "ImageButton"
store.ImageButton2.ZIndex = 6
store.ImageButton2.LayoutOrder = 2
store.ImageButton2.Size = UDim2.new(0,56,0,56)
store.ImageButton2.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.ImageButton2.BackgroundTransparency = 0.5
store.ImageButton2.BorderSizePixel = 0
store.ImageButton2.Image = "rbxassetid://104655087931499"
store.ImageButton2.ImageTransparency = 0.35
store.ImageButton2.ScaleType = Enum.ScaleType.Crop
store.ImageButton2.AutoButtonColor = false
store.ImageButton2.Parent = store.ScrollingFrame2

store["UICorner188"] = Instance.new("UICorner")
store.UICorner188.Name = "UICorner"
store.UICorner188.Parent = store.ImageButton2

store["UIStroke123"] = Instance.new("UIStroke")
store.UIStroke123.Name = "UIStroke"
store.UIStroke123.Color = Color3.fromRGB(50,52,60)
store.UIStroke123.Transparency = 0.4
store.UIStroke123.Parent = store.ImageButton2

store["Tick2"] = Instance.new("TextLabel")
store.Tick2.Name = "Tick"
store.Tick2.Visible = false
store.Tick2.ZIndex = 8
store.Tick2.Position = UDim2.new(1,-18,0,2)
store.Tick2.Size = UDim2.new(0,16,0,16)
store.Tick2.BackgroundTransparency = 1
store.Tick2.Text = "✓"
store.Tick2.TextColor3 = Color3.fromRGB(254,254,254)
store.Tick2.TextSize = 13
store.Tick2.Font = Enum.Font.GothamBlack
store.Tick2.Parent = store.ImageButton2

store["ImageButton3"] = Instance.new("ImageButton")
store.ImageButton3.Name = "ImageButton"
store.ImageButton3.ZIndex = 6
store.ImageButton3.LayoutOrder = 3
store.ImageButton3.Size = UDim2.new(0,56,0,56)
store.ImageButton3.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.ImageButton3.BackgroundTransparency = 0.5
store.ImageButton3.BorderSizePixel = 0
store.ImageButton3.Image = "rbxassetid://84045934794798"
store.ImageButton3.ImageTransparency = 0.35
store.ImageButton3.ScaleType = Enum.ScaleType.Crop
store.ImageButton3.AutoButtonColor = false
store.ImageButton3.Parent = store.ScrollingFrame2

store["UICorner189"] = Instance.new("UICorner")
store.UICorner189.Name = "UICorner"
store.UICorner189.Parent = store.ImageButton3

store["UIStroke124"] = Instance.new("UIStroke")
store.UIStroke124.Name = "UIStroke"
store.UIStroke124.Color = Color3.fromRGB(50,52,60)
store.UIStroke124.Transparency = 0.4
store.UIStroke124.Parent = store.ImageButton3

store["Tick3"] = Instance.new("TextLabel")
store.Tick3.Name = "Tick"
store.Tick3.Visible = false
store.Tick3.ZIndex = 8
store.Tick3.Position = UDim2.new(1,-18,0,2)
store.Tick3.Size = UDim2.new(0,16,0,16)
store.Tick3.BackgroundTransparency = 1
store.Tick3.Text = "✓"
store.Tick3.TextColor3 = Color3.fromRGB(254,254,254)
store.Tick3.TextSize = 13
store.Tick3.Font = Enum.Font.GothamBlack
store.Tick3.Parent = store.ImageButton3

store["ImageButton4"] = Instance.new("ImageButton")
store.ImageButton4.Name = "ImageButton"
store.ImageButton4.ZIndex = 6
store.ImageButton4.LayoutOrder = 4
store.ImageButton4.Size = UDim2.new(0,56,0,56)
store.ImageButton4.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.ImageButton4.BackgroundTransparency = 0.5
store.ImageButton4.BorderSizePixel = 0
store.ImageButton4.Image = "rbxassetid://102548023412554"
store.ImageButton4.ImageTransparency = 0.35
store.ImageButton4.ScaleType = Enum.ScaleType.Crop
store.ImageButton4.AutoButtonColor = false
store.ImageButton4.Parent = store.ScrollingFrame2

store["UICorner190"] = Instance.new("UICorner")
store.UICorner190.Name = "UICorner"
store.UICorner190.Parent = store.ImageButton4

store["UIStroke125"] = Instance.new("UIStroke")
store.UIStroke125.Name = "UIStroke"
store.UIStroke125.Color = Color3.fromRGB(50,52,60)
store.UIStroke125.Transparency = 0.4
store.UIStroke125.Parent = store.ImageButton4

store["Tick4"] = Instance.new("TextLabel")
store.Tick4.Name = "Tick"
store.Tick4.Visible = false
store.Tick4.ZIndex = 8
store.Tick4.Position = UDim2.new(1,-18,0,2)
store.Tick4.Size = UDim2.new(0,16,0,16)
store.Tick4.BackgroundTransparency = 1
store.Tick4.Text = "✓"
store.Tick4.TextColor3 = Color3.fromRGB(254,254,254)
store.Tick4.TextSize = 13
store.Tick4.Font = Enum.Font.GothamBlack
store.Tick4.Parent = store.ImageButton4

store["ImageButton5"] = Instance.new("ImageButton")
store.ImageButton5.Name = "ImageButton"
store.ImageButton5.ZIndex = 6
store.ImageButton5.LayoutOrder = 5
store.ImageButton5.Size = UDim2.new(0,56,0,56)
store.ImageButton5.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.ImageButton5.BackgroundTransparency = 0.5
store.ImageButton5.BorderSizePixel = 0
store.ImageButton5.Image = "rbxassetid://140209043610417"
store.ImageButton5.ImageTransparency = 0.35
store.ImageButton5.ScaleType = Enum.ScaleType.Crop
store.ImageButton5.AutoButtonColor = false
store.ImageButton5.Parent = store.ScrollingFrame2

store["UICorner191"] = Instance.new("UICorner")
store.UICorner191.Name = "UICorner"
store.UICorner191.Parent = store.ImageButton5

store["UIStroke126"] = Instance.new("UIStroke")
store.UIStroke126.Name = "UIStroke"
store.UIStroke126.Color = Color3.fromRGB(50,52,60)
store.UIStroke126.Transparency = 0.4
store.UIStroke126.Parent = store.ImageButton5

store["Tick5"] = Instance.new("TextLabel")
store.Tick5.Name = "Tick"
store.Tick5.Visible = false
store.Tick5.ZIndex = 8
store.Tick5.Position = UDim2.new(1,-18,0,2)
store.Tick5.Size = UDim2.new(0,16,0,16)
store.Tick5.BackgroundTransparency = 1
store.Tick5.Text = "✓"
store.Tick5.TextColor3 = Color3.fromRGB(254,254,254)
store.Tick5.TextSize = 13
store.Tick5.Font = Enum.Font.GothamBlack
store.Tick5.Parent = store.ImageButton5

store["ImageButton6"] = Instance.new("ImageButton")
store.ImageButton6.Name = "ImageButton"
store.ImageButton6.ZIndex = 6
store.ImageButton6.LayoutOrder = 6
store.ImageButton6.Size = UDim2.new(0,56,0,56)
store.ImageButton6.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.ImageButton6.BackgroundTransparency = 0.5
store.ImageButton6.BorderSizePixel = 0
store.ImageButton6.Image = "rbxassetid://122654220875697"
store.ImageButton6.ImageTransparency = 0.35
store.ImageButton6.ScaleType = Enum.ScaleType.Crop
store.ImageButton6.AutoButtonColor = false
store.ImageButton6.Parent = store.ScrollingFrame2

store["UICorner192"] = Instance.new("UICorner")
store.UICorner192.Name = "UICorner"
store.UICorner192.Parent = store.ImageButton6

store["UIStroke127"] = Instance.new("UIStroke")
store.UIStroke127.Name = "UIStroke"
store.UIStroke127.Color = Color3.fromRGB(50,52,60)
store.UIStroke127.Transparency = 0.4
store.UIStroke127.Parent = store.ImageButton6

store["Tick6"] = Instance.new("TextLabel")
store.Tick6.Name = "Tick"
store.Tick6.Visible = false
store.Tick6.ZIndex = 8
store.Tick6.Position = UDim2.new(1,-18,0,2)
store.Tick6.Size = UDim2.new(0,16,0,16)
store.Tick6.BackgroundTransparency = 1
store.Tick6.Text = "✓"
store.Tick6.TextColor3 = Color3.fromRGB(254,254,254)
store.Tick6.TextSize = 13
store.Tick6.Font = Enum.Font.GothamBlack
store.Tick6.Parent = store.ImageButton6

store["ImageButton7"] = Instance.new("ImageButton")
store.ImageButton7.Name = "ImageButton"
store.ImageButton7.ZIndex = 6
store.ImageButton7.LayoutOrder = 7
store.ImageButton7.Size = UDim2.new(0,56,0,56)
store.ImageButton7.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.ImageButton7.BackgroundTransparency = 0.5
store.ImageButton7.BorderSizePixel = 0
store.ImageButton7.Image = "rbxassetid://97009588976542"
store.ImageButton7.ImageTransparency = 0.35
store.ImageButton7.ScaleType = Enum.ScaleType.Crop
store.ImageButton7.AutoButtonColor = false
store.ImageButton7.Parent = store.ScrollingFrame2

store["UICorner193"] = Instance.new("UICorner")
store.UICorner193.Name = "UICorner"
store.UICorner193.Parent = store.ImageButton7

store["UIStroke128"] = Instance.new("UIStroke")
store.UIStroke128.Name = "UIStroke"
store.UIStroke128.Color = Color3.fromRGB(50,52,60)
store.UIStroke128.Transparency = 0.4
store.UIStroke128.Parent = store.ImageButton7

store["Tick7"] = Instance.new("TextLabel")
store.Tick7.Name = "Tick"
store.Tick7.Visible = false
store.Tick7.ZIndex = 8
store.Tick7.Position = UDim2.new(1,-18,0,2)
store.Tick7.Size = UDim2.new(0,16,0,16)
store.Tick7.BackgroundTransparency = 1
store.Tick7.Text = "✓"
store.Tick7.TextColor3 = Color3.fromRGB(254,254,254)
store.Tick7.TextSize = 13
store.Tick7.Font = Enum.Font.GothamBlack
store.Tick7.Parent = store.ImageButton7

store["ImageButton8"] = Instance.new("ImageButton")
store.ImageButton8.Name = "ImageButton"
store.ImageButton8.ZIndex = 6
store.ImageButton8.LayoutOrder = 8
store.ImageButton8.Size = UDim2.new(0,56,0,56)
store.ImageButton8.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.ImageButton8.BackgroundTransparency = 0.5
store.ImageButton8.BorderSizePixel = 0
store.ImageButton8.Image = "rbxassetid://94548581722612"
store.ImageButton8.ImageTransparency = 0.35
store.ImageButton8.ScaleType = Enum.ScaleType.Crop
store.ImageButton8.AutoButtonColor = false
store.ImageButton8.Parent = store.ScrollingFrame2

store["UICorner194"] = Instance.new("UICorner")
store.UICorner194.Name = "UICorner"
store.UICorner194.Parent = store.ImageButton8

store["UIStroke129"] = Instance.new("UIStroke")
store.UIStroke129.Name = "UIStroke"
store.UIStroke129.Color = Color3.fromRGB(50,52,60)
store.UIStroke129.Transparency = 0.4
store.UIStroke129.Parent = store.ImageButton8

store["Tick8"] = Instance.new("TextLabel")
store.Tick8.Name = "Tick"
store.Tick8.Visible = false
store.Tick8.ZIndex = 8
store.Tick8.Position = UDim2.new(1,-18,0,2)
store.Tick8.Size = UDim2.new(0,16,0,16)
store.Tick8.BackgroundTransparency = 1
store.Tick8.Text = "✓"
store.Tick8.TextColor3 = Color3.fromRGB(254,254,254)
store.Tick8.TextSize = 13
store.Tick8.Font = Enum.Font.GothamBlack
store.Tick8.Parent = store.ImageButton8

store["ImageButton9"] = Instance.new("ImageButton")
store.ImageButton9.Name = "ImageButton"
store.ImageButton9.ZIndex = 6
store.ImageButton9.LayoutOrder = 9
store.ImageButton9.Size = UDim2.new(0,56,0,56)
store.ImageButton9.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.ImageButton9.BackgroundTransparency = 0.5
store.ImageButton9.BorderSizePixel = 0
store.ImageButton9.Image = "rbxassetid://71705427133616"
store.ImageButton9.ImageTransparency = 0.35
store.ImageButton9.ScaleType = Enum.ScaleType.Crop
store.ImageButton9.AutoButtonColor = false
store.ImageButton9.Parent = store.ScrollingFrame2

store["UICorner195"] = Instance.new("UICorner")
store.UICorner195.Name = "UICorner"
store.UICorner195.Parent = store.ImageButton9

store["UIStroke130"] = Instance.new("UIStroke")
store.UIStroke130.Name = "UIStroke"
store.UIStroke130.Color = Color3.fromRGB(50,52,60)
store.UIStroke130.Transparency = 0.4
store.UIStroke130.Parent = store.ImageButton9

store["Tick9"] = Instance.new("TextLabel")
store.Tick9.Name = "Tick"
store.Tick9.Visible = false
store.Tick9.ZIndex = 8
store.Tick9.Position = UDim2.new(1,-18,0,2)
store.Tick9.Size = UDim2.new(0,16,0,16)
store.Tick9.BackgroundTransparency = 1
store.Tick9.Text = "✓"
store.Tick9.TextColor3 = Color3.fromRGB(254,254,254)
store.Tick9.TextSize = 13
store.Tick9.Font = Enum.Font.GothamBlack
store.Tick9.Parent = store.ImageButton9

store["ImageButton10"] = Instance.new("ImageButton")
store.ImageButton10.Name = "ImageButton"
store.ImageButton10.ZIndex = 6
store.ImageButton10.LayoutOrder = 10
store.ImageButton10.Size = UDim2.new(0,56,0,56)
store.ImageButton10.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.ImageButton10.BackgroundTransparency = 0.5
store.ImageButton10.BorderSizePixel = 0
store.ImageButton10.Image = "rbxassetid://97563242966497"
store.ImageButton10.ImageTransparency = 0.35
store.ImageButton10.ScaleType = Enum.ScaleType.Crop
store.ImageButton10.AutoButtonColor = false
store.ImageButton10.Parent = store.ScrollingFrame2

store["UICorner196"] = Instance.new("UICorner")
store.UICorner196.Name = "UICorner"
store.UICorner196.Parent = store.ImageButton10

store["UIStroke131"] = Instance.new("UIStroke")
store.UIStroke131.Name = "UIStroke"
store.UIStroke131.Color = Color3.fromRGB(50,52,60)
store.UIStroke131.Transparency = 0.4
store.UIStroke131.Parent = store.ImageButton10

store["Tick10"] = Instance.new("TextLabel")
store.Tick10.Name = "Tick"
store.Tick10.Visible = false
store.Tick10.ZIndex = 8
store.Tick10.Position = UDim2.new(1,-18,0,2)
store.Tick10.Size = UDim2.new(0,16,0,16)
store.Tick10.BackgroundTransparency = 1
store.Tick10.Text = "✓"
store.Tick10.TextColor3 = Color3.fromRGB(254,254,254)
store.Tick10.TextSize = 13
store.Tick10.Font = Enum.Font.GothamBlack
store.Tick10.Parent = store.ImageButton10

store["TextButton94"] = Instance.new("TextButton")
store.TextButton94.Name = "TextButton"
store.TextButton94.ZIndex = 6
store.TextButton94.Position = UDim2.new(0,12,0,43)
store.TextButton94.Size = UDim2.new(0,22,0,40)
store.TextButton94.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton94.BackgroundTransparency = 0.5
store.TextButton94.BorderSizePixel = 0
store.TextButton94.Text = "<"
store.TextButton94.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton94.TextSize = 13
store.TextButton94.Font = Enum.Font.GothamBlack
store.TextButton94.AutoButtonColor = false
store.TextButton94.Parent = store.Frame208

store["UICorner197"] = Instance.new("UICorner")
store.UICorner197.Name = "UICorner"
store.UICorner197.Parent = store.TextButton94

store["UIStroke132"] = Instance.new("UIStroke")
store.UIStroke132.Name = "UIStroke"
store.UIStroke132.Color = Color3.fromRGB(254,254,254)
store.UIStroke132.Thickness = 1.4
store.UIStroke132.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke132.Transparency = 0.25
store.UIStroke132.Parent = store.TextButton94

store["UIGradient39"] = Instance.new("UIGradient")
store.UIGradient39.Name = "UIGradient"
store.UIGradient39.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient39.Parent = store.UIStroke132

store["TextButton95"] = Instance.new("TextButton")
store.TextButton95.Name = "TextButton"
store.TextButton95.ZIndex = 6
store.TextButton95.Position = UDim2.new(1,-34,0,43)
store.TextButton95.Size = UDim2.new(0,22,0,40)
store.TextButton95.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton95.BackgroundTransparency = 0.5
store.TextButton95.BorderSizePixel = 0
store.TextButton95.Text = ">"
store.TextButton95.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton95.TextSize = 13
store.TextButton95.Font = Enum.Font.GothamBlack
store.TextButton95.AutoButtonColor = false
store.TextButton95.Parent = store.Frame208

store["UICorner198"] = Instance.new("UICorner")
store.UICorner198.Name = "UICorner"
store.UICorner198.Parent = store.TextButton95

store["UIStroke133"] = Instance.new("UIStroke")
store.UIStroke133.Name = "UIStroke"
store.UIStroke133.Color = Color3.fromRGB(254,254,254)
store.UIStroke133.Thickness = 1.4
store.UIStroke133.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke133.Transparency = 0.25
store.UIStroke133.Parent = store.TextButton95

store["UIGradient40"] = Instance.new("UIGradient")
store.UIGradient40.Name = "UIGradient"
store.UIGradient40.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient40.Parent = store.UIStroke133

store["Frame210"] = Instance.new("Frame")
store.Frame210.Name = "Frame"
store.Frame210.LayoutOrder = -10
store.Frame210.Size = UDim2.new(1,0,0,42)
store.Frame210.BackgroundTransparency = 1
store.Frame210.BorderSizePixel = 0
store.Frame210.Parent = store.Page_Settings

store["TextLabel99"] = Instance.new("TextLabel")
store.TextLabel99.Name = "TextLabel"
store.TextLabel99.ZIndex = 4
store.TextLabel99.Position = UDim2.new(0,0,0,20)
store.TextLabel99.Size = UDim2.new(1,0,0,16)
store.TextLabel99.BackgroundTransparency = 1
store.TextLabel99.Text = "PANELS"
store.TextLabel99.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel99.TextSize = 12
store.TextLabel99.Font = Enum.Font.GothamBlack
store.TextLabel99.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel99.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel99.Parent = store.Frame210

store["Frame211"] = Instance.new("Frame")
store.Frame211.Name = "Frame"
store.Frame211.ZIndex = 3
store.Frame211.Position = UDim2.new(0,0,0,38)
store.Frame211.Size = UDim2.new(1,0,0,1)
store.Frame211.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame211.BackgroundTransparency = 0.85
store.Frame211.BorderSizePixel = 0
store.Frame211.Parent = store.Frame210

store["Frame212"] = Instance.new("Frame")
store.Frame212.Name = "Frame"
store.Frame212.ZIndex = 4
store.Frame212.LayoutOrder = -9
store.Frame212.Size = UDim2.new(1,0,0,36)
store.Frame212.BackgroundTransparency = 1
store.Frame212.BorderSizePixel = 0
store.Frame212.Parent = store.Page_Settings

store["TextButton96"] = Instance.new("TextButton")
store.TextButton96.Name = "TextButton"
store.TextButton96.ZIndex = 5
store.TextButton96.Size = UDim2.new(1,0,1,0)
store.TextButton96.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton96.BackgroundTransparency = 0.5
store.TextButton96.BorderSizePixel = 0
store.TextButton96.Text = ""
store.TextButton96.AutoButtonColor = false
store.TextButton96.Parent = store.Frame212

store["UICorner199"] = Instance.new("UICorner")
store.UICorner199.Name = "UICorner"
store.UICorner199.CornerRadius = UDim.new(0,10)
store.UICorner199.Parent = store.TextButton96

store["UIStroke134"] = Instance.new("UIStroke")
store.UIStroke134.Name = "UIStroke"
store.UIStroke134.Color = Color3.fromRGB(254,254,254)
store.UIStroke134.Thickness = 1.4
store.UIStroke134.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke134.Transparency = 0.45
store.UIStroke134.Parent = store.TextButton96

store["UIGradient41"] = Instance.new("UIGradient")
store.UIGradient41.Name = "UIGradient"
store.UIGradient41.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient41.Parent = store.UIStroke134

store["TextLabel100"] = Instance.new("TextLabel")
store.TextLabel100.Name = "TextLabel"
store.TextLabel100.ZIndex = 6
store.TextLabel100.Size = UDim2.new(1,0,1,0)
store.TextLabel100.BackgroundTransparency = 1
store.TextLabel100.Text = "Duel Lagger"
store.TextLabel100.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel100.TextSize = 11
store.TextLabel100.Font = Enum.Font.GothamBlack
store.TextLabel100.Parent = store.TextButton96

store["Frame213"] = Instance.new("Frame")
store.Frame213.Name = "Frame"
store.Frame213.ZIndex = 4
store.Frame213.LayoutOrder = -8
store.Frame213.Size = UDim2.new(1,0,0,36)
store.Frame213.BackgroundTransparency = 1
store.Frame213.BorderSizePixel = 0
store.Frame213.Parent = store.Page_Settings

store["TextButton97"] = Instance.new("TextButton")
store.TextButton97.Name = "TextButton"
store.TextButton97.ZIndex = 5
store.TextButton97.Size = UDim2.new(1,0,1,0)
store.TextButton97.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton97.BackgroundTransparency = 0.5
store.TextButton97.BorderSizePixel = 0
store.TextButton97.Text = ""
store.TextButton97.AutoButtonColor = false
store.TextButton97.Parent = store.Frame213

store["UICorner200"] = Instance.new("UICorner")
store.UICorner200.Name = "UICorner"
store.UICorner200.CornerRadius = UDim.new(0,10)
store.UICorner200.Parent = store.TextButton97

store["UIStroke135"] = Instance.new("UIStroke")
store.UIStroke135.Name = "UIStroke"
store.UIStroke135.Color = Color3.fromRGB(254,254,254)
store.UIStroke135.Thickness = 1.4
store.UIStroke135.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke135.Transparency = 0.45
store.UIStroke135.Parent = store.TextButton97

store["UIGradient42"] = Instance.new("UIGradient")
store.UIGradient42.Name = "UIGradient"
store.UIGradient42.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient42.Parent = store.UIStroke135

store["TextLabel101"] = Instance.new("TextLabel")
store.TextLabel101.Name = "TextLabel"
store.TextLabel101.ZIndex = 6
store.TextLabel101.Size = UDim2.new(1,0,1,0)
store.TextLabel101.BackgroundTransparency = 1
store.TextLabel101.Text = "Ping Lagger"
store.TextLabel101.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel101.TextSize = 11
store.TextLabel101.Font = Enum.Font.GothamBlack
store.TextLabel101.Parent = store.TextButton97

store["Frame214"] = Instance.new("Frame")
store.Frame214.Name = "Frame"
store.Frame214.ZIndex = 4
store.Frame214.LayoutOrder = -7
store.Frame214.Size = UDim2.new(1,0,0,36)
store.Frame214.BackgroundTransparency = 1
store.Frame214.BorderSizePixel = 0
store.Frame214.Parent = store.Page_Settings

store["TextButton98"] = Instance.new("TextButton")
store.TextButton98.Name = "TextButton"
store.TextButton98.ZIndex = 5
store.TextButton98.Size = UDim2.new(1,0,1,0)
store.TextButton98.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton98.BackgroundTransparency = 0.5
store.TextButton98.BorderSizePixel = 0
store.TextButton98.Text = ""
store.TextButton98.AutoButtonColor = false
store.TextButton98.Parent = store.Frame214

store["UICorner201"] = Instance.new("UICorner")
store.UICorner201.Name = "UICorner"
store.UICorner201.CornerRadius = UDim.new(0,10)
store.UICorner201.Parent = store.TextButton98

store["UIStroke136"] = Instance.new("UIStroke")
store.UIStroke136.Name = "UIStroke"
store.UIStroke136.Color = Color3.fromRGB(254,254,254)
store.UIStroke136.Thickness = 1.4
store.UIStroke136.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke136.Transparency = 0.45
store.UIStroke136.Parent = store.TextButton98

store["UIGradient43"] = Instance.new("UIGradient")
store.UIGradient43.Name = "UIGradient"
store.UIGradient43.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient43.Parent = store.UIStroke136

store["TextLabel102"] = Instance.new("TextLabel")
store.TextLabel102.Name = "TextLabel"
store.TextLabel102.ZIndex = 6
store.TextLabel102.Size = UDim2.new(1,0,1,0)
store.TextLabel102.BackgroundTransparency = 1
store.TextLabel102.Text = "Speed Bypass"
store.TextLabel102.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel102.TextSize = 11
store.TextLabel102.Font = Enum.Font.GothamBlack
store.TextLabel102.Parent = store.TextButton98

store["Frame215"] = Instance.new("Frame")
store.Frame215.Name = "Frame"
store.Frame215.ZIndex = 4
store.Frame215.LayoutOrder = -6
store.Frame215.Size = UDim2.new(1,0,0,36)
store.Frame215.BackgroundTransparency = 1
store.Frame215.BorderSizePixel = 0
store.Frame215.Parent = store.Page_Settings

store["TextButton99"] = Instance.new("TextButton")
store.TextButton99.Name = "TextButton"
store.TextButton99.ZIndex = 5
store.TextButton99.Size = UDim2.new(1,0,1,0)
store.TextButton99.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton99.BackgroundTransparency = 0.5
store.TextButton99.BorderSizePixel = 0
store.TextButton99.Text = ""
store.TextButton99.AutoButtonColor = false
store.TextButton99.Parent = store.Frame215

store["UICorner202"] = Instance.new("UICorner")
store.UICorner202.Name = "UICorner"
store.UICorner202.CornerRadius = UDim.new(0,10)
store.UICorner202.Parent = store.TextButton99

store["UIStroke137"] = Instance.new("UIStroke")
store.UIStroke137.Name = "UIStroke"
store.UIStroke137.Color = Color3.fromRGB(254,254,254)
store.UIStroke137.Thickness = 1.4
store.UIStroke137.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke137.Transparency = 0.45
store.UIStroke137.Parent = store.TextButton99

store["UIGradient44"] = Instance.new("UIGradient")
store.UIGradient44.Name = "UIGradient"
store.UIGradient44.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient44.Parent = store.UIStroke137

store["TextLabel103"] = Instance.new("TextLabel")
store.TextLabel103.Name = "TextLabel"
store.TextLabel103.ZIndex = 6
store.TextLabel103.Size = UDim2.new(1,0,1,0)
store.TextLabel103.BackgroundTransparency = 1
store.TextLabel103.Text = "Anti TP/Bat"
store.TextLabel103.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel103.TextSize = 11
store.TextLabel103.Font = Enum.Font.GothamBlack
store.TextLabel103.Parent = store.TextButton99

store["Frame216"] = Instance.new("Frame")
store.Frame216.Name = "Frame"
store.Frame216.LayoutOrder = 2
store.Frame216.Size = UDim2.new(1,0,0,42)
store.Frame216.BackgroundTransparency = 1
store.Frame216.BorderSizePixel = 0
store.Frame216.Parent = store.Page_Settings

store["TextLabel104"] = Instance.new("TextLabel")
store.TextLabel104.Name = "TextLabel"
store.TextLabel104.ZIndex = 4
store.TextLabel104.Position = UDim2.new(0,0,0,20)
store.TextLabel104.Size = UDim2.new(1,0,0,16)
store.TextLabel104.BackgroundTransparency = 1
store.TextLabel104.Text = "INTERFACE"
store.TextLabel104.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel104.TextSize = 12
store.TextLabel104.Font = Enum.Font.GothamBlack
store.TextLabel104.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel104.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel104.Parent = store.Frame216

store["Frame217"] = Instance.new("Frame")
store.Frame217.Name = "Frame"
store.Frame217.ZIndex = 3
store.Frame217.Position = UDim2.new(0,0,0,38)
store.Frame217.Size = UDim2.new(1,0,0,1)
store.Frame217.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame217.BackgroundTransparency = 0.85
store.Frame217.BorderSizePixel = 0
store.Frame217.Parent = store.Frame216

store["Frame218"] = Instance.new("Frame")
store.Frame218.Name = "Frame"
store.Frame218.ZIndex = 4
store.Frame218.LayoutOrder = 5
store.Frame218.Size = UDim2.new(1,0,0,40)
store.Frame218.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame218.BackgroundTransparency = 0.5
store.Frame218.BorderSizePixel = 0
store.Frame218.Parent = store.Page_Settings

store["UICorner203"] = Instance.new("UICorner")
store.UICorner203.Name = "UICorner"
store.UICorner203.CornerRadius = UDim.new(0,10)
store.UICorner203.Parent = store.Frame218

store["UIStroke138"] = Instance.new("UIStroke")
store.UIStroke138.Name = "UIStroke"
store.UIStroke138.Color = Color3.fromRGB(28,28,34)
store.UIStroke138.Parent = store.Frame218

store["TextLabel105"] = Instance.new("TextLabel")
store.TextLabel105.Name = "TextLabel"
store.TextLabel105.ZIndex = 5
store.TextLabel105.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel105.Size = UDim2.new(0.6,0,0,16)
store.TextLabel105.BackgroundTransparency = 1
store.TextLabel105.Text = "Lock UI"
store.TextLabel105.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel105.TextSize = 11
store.TextLabel105.Font = Enum.Font.GothamBold
store.TextLabel105.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel105.Parent = store.Frame218

store["Frame219"] = Instance.new("Frame")
store.Frame219.Name = "Frame"
store.Frame219.Visible = false
store.Frame219.ZIndex = 5
store.Frame219.Position = UDim2.new(0,12,0.5,7)
store.Frame219.Size = UDim2.new(0,36,0,1)
store.Frame219.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame219.BackgroundTransparency = 0.5
store.Frame219.BorderSizePixel = 0
store.Frame219.Parent = store.Frame218

store["Frame220"] = Instance.new("Frame")
store.Frame220.Name = "Frame"
store.Frame220.ZIndex = 6
store.Frame220.Position = UDim2.new(1,-44,0.5,-8)
store.Frame220.Size = UDim2.new(0,32,0,16)
store.Frame220.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame220.BackgroundTransparency = 0.5
store.Frame220.BorderSizePixel = 0
store.Frame220.Parent = store.Frame218

store["UICorner204"] = Instance.new("UICorner")
store.UICorner204.Name = "UICorner"
store.UICorner204.CornerRadius = UDim.new(1,0)
store.UICorner204.Parent = store.Frame220

store["UIStroke139"] = Instance.new("UIStroke")
store.UIStroke139.Name = "UIStroke"
store.UIStroke139.Color = Color3.fromRGB(70,70,70)
store.UIStroke139.Transparency = 0.5
store.UIStroke139.Parent = store.Frame220

store["Frame221"] = Instance.new("Frame")
store.Frame221.Name = "Frame"
store.Frame221.ZIndex = 7
store.Frame221.Position = UDim2.new(0,2,0.5,-6)
store.Frame221.Size = UDim2.new(0,12,0,12)
store.Frame221.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame221.BackgroundTransparency = 0.5
store.Frame221.BorderSizePixel = 0
store.Frame221.Parent = store.Frame220

store["UICorner205"] = Instance.new("UICorner")
store.UICorner205.Name = "UICorner"
store.UICorner205.CornerRadius = UDim.new(1,0)
store.UICorner205.Parent = store.Frame221

store["TextButton100"] = Instance.new("TextButton")
store.TextButton100.Name = "TextButton"
store.TextButton100.ZIndex = 8
store.TextButton100.Size = UDim2.new(1,0,1,0)
store.TextButton100.BackgroundTransparency = 1
store.TextButton100.Text = ""
store.TextButton100.Parent = store.Frame218

store["PressPop23"] = Instance.new("UIScale")
store.PressPop23.Name = "PressPop"
store.PressPop23.Parent = store.Frame218

store["Frame222"] = Instance.new("Frame")
store.Frame222.Name = "Frame"
store.Frame222.ZIndex = 4
store.Frame222.LayoutOrder = 6
store.Frame222.Size = UDim2.new(1,0,0,62)
store.Frame222.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame222.BackgroundTransparency = 0.5
store.Frame222.BorderSizePixel = 0
store.Frame222.Parent = store.Page_Settings

store["UICorner206"] = Instance.new("UICorner")
store.UICorner206.Name = "UICorner"
store.UICorner206.CornerRadius = UDim.new(0,12)
store.UICorner206.Parent = store.Frame222

store["UIStroke140"] = Instance.new("UIStroke")
store.UIStroke140.Name = "UIStroke"
store.UIStroke140.Color = Color3.fromRGB(35,35,45)
store.UIStroke140.Transparency = 0.4
store.UIStroke140.Parent = store.Frame222

store["TextLabel106"] = Instance.new("TextLabel")
store.TextLabel106.Name = "TextLabel"
store.TextLabel106.ZIndex = 5
store.TextLabel106.Position = UDim2.new(0,12,0,8)
store.TextLabel106.Size = UDim2.new(0.7,0,0,16)
store.TextLabel106.BackgroundTransparency = 1
store.TextLabel106.Text = "Intro Song"
store.TextLabel106.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel106.TextSize = 11
store.TextLabel106.Font = Enum.Font.GothamBold
store.TextLabel106.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel106.Parent = store.Frame222

store["Frame223"] = Instance.new("Frame")
store.Frame223.Name = "Frame"
store.Frame223.Visible = false
store.Frame223.ZIndex = 5
store.Frame223.Position = UDim2.new(0,12,0,26)
store.Frame223.Size = UDim2.new(0,51,0,1)
store.Frame223.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame223.BackgroundTransparency = 0.5
store.Frame223.BorderSizePixel = 0
store.Frame223.Parent = store.Frame222

store["TextLabel107"] = Instance.new("TextLabel")
store.TextLabel107.Name = "TextLabel"
store.TextLabel107.ZIndex = 6
store.TextLabel107.Position = UDim2.new(0,54,1,-34)
store.TextLabel107.Size = UDim2.new(1,-108,0,26)
store.TextLabel107.BackgroundTransparency = 1
store.TextLabel107.Text = "SONG 2"
store.TextLabel107.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel107.TextSize = 11
store.TextLabel107.Font = Enum.Font.GothamBold
store.TextLabel107.Parent = store.Frame222

store["TextButton101"] = Instance.new("TextButton")
store.TextButton101.Name = "TextButton"
store.TextButton101.ZIndex = 7
store.TextButton101.Position = UDim2.new(0,12,1,-34)
store.TextButton101.Size = UDim2.new(0,34,0,26)
store.TextButton101.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton101.BackgroundTransparency = 0.5
store.TextButton101.BorderSizePixel = 0
store.TextButton101.Text = "<"
store.TextButton101.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton101.TextSize = 13
store.TextButton101.Font = Enum.Font.GothamBlack
store.TextButton101.AutoButtonColor = false
store.TextButton101.Parent = store.Frame222

store["UICorner207"] = Instance.new("UICorner")
store.UICorner207.Name = "UICorner"
store.UICorner207.Parent = store.TextButton101

store["UIStroke141"] = Instance.new("UIStroke")
store.UIStroke141.Name = "UIStroke"
store.UIStroke141.Color = Color3.fromRGB(254,254,254)
store.UIStroke141.Thickness = 1.4
store.UIStroke141.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke141.Transparency = 0.25
store.UIStroke141.Parent = store.TextButton101

store["UIGradient45"] = Instance.new("UIGradient")
store.UIGradient45.Name = "UIGradient"
store.UIGradient45.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient45.Parent = store.UIStroke141

store["TextButton102"] = Instance.new("TextButton")
store.TextButton102.Name = "TextButton"
store.TextButton102.ZIndex = 7
store.TextButton102.Position = UDim2.new(1,-46,1,-34)
store.TextButton102.Size = UDim2.new(0,34,0,26)
store.TextButton102.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton102.BackgroundTransparency = 0.5
store.TextButton102.BorderSizePixel = 0
store.TextButton102.Text = ">"
store.TextButton102.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton102.TextSize = 13
store.TextButton102.Font = Enum.Font.GothamBlack
store.TextButton102.AutoButtonColor = false
store.TextButton102.Parent = store.Frame222

store["UICorner208"] = Instance.new("UICorner")
store.UICorner208.Name = "UICorner"
store.UICorner208.Parent = store.TextButton102

store["UIStroke142"] = Instance.new("UIStroke")
store.UIStroke142.Name = "UIStroke"
store.UIStroke142.Color = Color3.fromRGB(254,254,254)
store.UIStroke142.Thickness = 1.4
store.UIStroke142.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke142.Transparency = 0.25
store.UIStroke142.Parent = store.TextButton102

store["UIGradient46"] = Instance.new("UIGradient")
store.UIGradient46.Name = "UIGradient"
store.UIGradient46.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient46.Parent = store.UIStroke142

store["Frame224"] = Instance.new("Frame")
store.Frame224.Name = "Frame"
store.Frame224.ZIndex = 4
store.Frame224.LayoutOrder = 7
store.Frame224.Size = UDim2.new(1,0,0,40)
store.Frame224.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame224.BackgroundTransparency = 0.5
store.Frame224.BorderSizePixel = 0
store.Frame224.Parent = store.Page_Settings

store["UICorner209"] = Instance.new("UICorner")
store.UICorner209.Name = "UICorner"
store.UICorner209.CornerRadius = UDim.new(0,10)
store.UICorner209.Parent = store.Frame224

store["UIStroke143"] = Instance.new("UIStroke")
store.UIStroke143.Name = "UIStroke"
store.UIStroke143.Color = Color3.fromRGB(28,28,34)
store.UIStroke143.Parent = store.Frame224

store["TextLabel108"] = Instance.new("TextLabel")
store.TextLabel108.Name = "TextLabel"
store.TextLabel108.ZIndex = 5
store.TextLabel108.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel108.Size = UDim2.new(0.6,0,0,16)
store.TextLabel108.BackgroundTransparency = 1
store.TextLabel108.Text = "Skip Intro"
store.TextLabel108.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel108.TextSize = 11
store.TextLabel108.Font = Enum.Font.GothamBold
store.TextLabel108.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel108.Parent = store.Frame224

store["Frame225"] = Instance.new("Frame")
store.Frame225.Name = "Frame"
store.Frame225.Visible = false
store.Frame225.ZIndex = 5
store.Frame225.Position = UDim2.new(0,12,0.5,7)
store.Frame225.Size = UDim2.new(0,47,0,1)
store.Frame225.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame225.BackgroundTransparency = 0.5
store.Frame225.BorderSizePixel = 0
store.Frame225.Parent = store.Frame224

store["Frame226"] = Instance.new("Frame")
store.Frame226.Name = "Frame"
store.Frame226.ZIndex = 6
store.Frame226.Position = UDim2.new(1,-44,0.5,-8)
store.Frame226.Size = UDim2.new(0,32,0,16)
store.Frame226.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame226.BackgroundTransparency = 0.5
store.Frame226.BorderSizePixel = 0
store.Frame226.Parent = store.Frame224

store["UICorner210"] = Instance.new("UICorner")
store.UICorner210.Name = "UICorner"
store.UICorner210.CornerRadius = UDim.new(1,0)
store.UICorner210.Parent = store.Frame226

store["UIStroke144"] = Instance.new("UIStroke")
store.UIStroke144.Name = "UIStroke"
store.UIStroke144.Color = Color3.fromRGB(70,70,70)
store.UIStroke144.Transparency = 0.5
store.UIStroke144.Parent = store.Frame226

store["Frame227"] = Instance.new("Frame")
store.Frame227.Name = "Frame"
store.Frame227.ZIndex = 7
store.Frame227.Position = UDim2.new(0,2,0.5,-6)
store.Frame227.Size = UDim2.new(0,12,0,12)
store.Frame227.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame227.BackgroundTransparency = 0.5
store.Frame227.BorderSizePixel = 0
store.Frame227.Parent = store.Frame226

store["UICorner211"] = Instance.new("UICorner")
store.UICorner211.Name = "UICorner"
store.UICorner211.CornerRadius = UDim.new(1,0)
store.UICorner211.Parent = store.Frame227

store["TextButton103"] = Instance.new("TextButton")
store.TextButton103.Name = "TextButton"
store.TextButton103.ZIndex = 8
store.TextButton103.Size = UDim2.new(1,0,1,0)
store.TextButton103.BackgroundTransparency = 1
store.TextButton103.Text = ""
store.TextButton103.Parent = store.Frame224

store["PressPop24"] = Instance.new("UIScale")
store.PressPop24.Name = "PressPop"
store.PressPop24.Parent = store.Frame224

store["Frame228"] = Instance.new("Frame")
store.Frame228.Name = "Frame"
store.Frame228.ZIndex = 4
store.Frame228.LayoutOrder = 8
store.Frame228.Size = UDim2.new(1,0,0,40)
store.Frame228.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame228.BackgroundTransparency = 0.5
store.Frame228.BorderSizePixel = 0
store.Frame228.Parent = store.Page_Settings

store["UICorner212"] = Instance.new("UICorner")
store.UICorner212.Name = "UICorner"
store.UICorner212.CornerRadius = UDim.new(0,10)
store.UICorner212.Parent = store.Frame228

store["UIStroke145"] = Instance.new("UIStroke")
store.UIStroke145.Name = "UIStroke"
store.UIStroke145.Color = Color3.fromRGB(28,28,34)
store.UIStroke145.Parent = store.Frame228

store["TextLabel109"] = Instance.new("TextLabel")
store.TextLabel109.Name = "TextLabel"
store.TextLabel109.ZIndex = 5
store.TextLabel109.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel109.Size = UDim2.new(0.6,0,0,16)
store.TextLabel109.BackgroundTransparency = 1
store.TextLabel109.Text = "UI Toggle Key"
store.TextLabel109.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel109.TextSize = 11
store.TextLabel109.Font = Enum.Font.GothamBold
store.TextLabel109.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel109.Parent = store.Frame228

store["Frame229"] = Instance.new("Frame")
store.Frame229.Name = "Frame"
store.Frame229.Visible = false
store.Frame229.ZIndex = 5
store.Frame229.Position = UDim2.new(0,12,0.5,7)
store.Frame229.Size = UDim2.new(0,67,0,1)
store.Frame229.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame229.BackgroundTransparency = 0.5
store.Frame229.BorderSizePixel = 0
store.Frame229.Parent = store.Frame228

store["Frame230"] = Instance.new("Frame")
store.Frame230.Name = "Frame"
store.Frame230.ZIndex = 6
store.Frame230.ClipsDescendants = true
store.Frame230.Position = UDim2.new(1,-68,0.5,-11)
store.Frame230.Size = UDim2.new(0,60,0,22)
store.Frame230.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame230.BackgroundTransparency = 0.5
store.Frame230.BorderSizePixel = 0
store.Frame230.Parent = store.Frame228

store["UICorner213"] = Instance.new("UICorner")
store.UICorner213.Name = "UICorner"
store.UICorner213.CornerRadius = UDim.new(0,10)
store.UICorner213.Parent = store.Frame230

store["TextLabel110"] = Instance.new("TextLabel")
store.TextLabel110.Name = "TextLabel"
store.TextLabel110.ZIndex = 7
store.TextLabel110.Size = UDim2.new(1,0,1,0)
store.TextLabel110.BackgroundTransparency = 1
store.TextLabel110.Text = "None"
store.TextLabel110.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel110.TextSize = 10
store.TextLabel110.TextScaled = true
store.TextLabel110.Font = Enum.Font.GothamBold
store.TextLabel110.TextWrapped = true
store.TextLabel110.Parent = store.Frame230

store["UITextSizeConstraint12"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint12.Name = "UITextSizeConstraint"
store.UITextSizeConstraint12.MinTextSize = 6
store.UITextSizeConstraint12.MaxTextSize = 10
store.UITextSizeConstraint12.Parent = store.TextLabel110

store["TextButton104"] = Instance.new("TextButton")
store.TextButton104.Name = "TextButton"
store.TextButton104.ZIndex = 8
store.TextButton104.Size = UDim2.new(1,0,1,0)
store.TextButton104.BackgroundTransparency = 1
store.TextButton104.Text = ""
store.TextButton104.Parent = store.Frame230

store["Frame231"] = Instance.new("Frame")
store.Frame231.Name = "Frame"
store.Frame231.LayoutOrder = 10
store.Frame231.Size = UDim2.new(1,0,0,42)
store.Frame231.BackgroundTransparency = 1
store.Frame231.BorderSizePixel = 0
store.Frame231.Parent = store.Page_Settings

store["TextLabel111"] = Instance.new("TextLabel")
store.TextLabel111.Name = "TextLabel"
store.TextLabel111.ZIndex = 4
store.TextLabel111.Position = UDim2.new(0,0,0,20)
store.TextLabel111.Size = UDim2.new(1,0,0,16)
store.TextLabel111.BackgroundTransparency = 1
store.TextLabel111.Text = "CUSTOM CONFIGURATION"
store.TextLabel111.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel111.TextSize = 12
store.TextLabel111.Font = Enum.Font.GothamBlack
store.TextLabel111.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel111.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel111.Parent = store.Frame231

store["Frame232"] = Instance.new("Frame")
store.Frame232.Name = "Frame"
store.Frame232.ZIndex = 3
store.Frame232.Position = UDim2.new(0,0,0,38)
store.Frame232.Size = UDim2.new(1,0,0,1)
store.Frame232.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame232.BackgroundTransparency = 0.85
store.Frame232.BorderSizePixel = 0
store.Frame232.Parent = store.Frame231

store["Frame233"] = Instance.new("Frame")
store.Frame233.Name = "Frame"
store.Frame233.ZIndex = 4
store.Frame233.LayoutOrder = 12
store.Frame233.Size = UDim2.new(1,0,0,40)
store.Frame233.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame233.BackgroundTransparency = 0.5
store.Frame233.BorderSizePixel = 0
store.Frame233.Parent = store.Page_Settings

store["UICorner214"] = Instance.new("UICorner")
store.UICorner214.Name = "UICorner"
store.UICorner214.CornerRadius = UDim.new(0,10)
store.UICorner214.Parent = store.Frame233

store["UIStroke146"] = Instance.new("UIStroke")
store.UIStroke146.Name = "UIStroke"
store.UIStroke146.Color = Color3.fromRGB(28,28,34)
store.UIStroke146.Parent = store.Frame233

store["TextLabel112"] = Instance.new("TextLabel")
store.TextLabel112.Name = "TextLabel"
store.TextLabel112.ZIndex = 5
store.TextLabel112.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel112.Size = UDim2.new(0.6,0,0,16)
store.TextLabel112.BackgroundTransparency = 1
store.TextLabel112.Text = "UI Size"
store.TextLabel112.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel112.TextSize = 11
store.TextLabel112.Font = Enum.Font.GothamBold
store.TextLabel112.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel112.Parent = store.Frame233

store["Frame234"] = Instance.new("Frame")
store.Frame234.Name = "Frame"
store.Frame234.Visible = false
store.Frame234.ZIndex = 5
store.Frame234.Position = UDim2.new(0,12,0.5,7)
store.Frame234.Size = UDim2.new(0,33,0,1)
store.Frame234.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame234.BackgroundTransparency = 0.5
store.Frame234.BorderSizePixel = 0
store.Frame234.Parent = store.Frame233

store["Frame235"] = Instance.new("Frame")
store.Frame235.Name = "Frame"
store.Frame235.ZIndex = 5
store.Frame235.Position = UDim2.new(1,-130,0.5,-14)
store.Frame235.Size = UDim2.new(0,118,0,28)
store.Frame235.BackgroundTransparency = 1
store.Frame235.Parent = store.Frame233

store["Frame236"] = Instance.new("Frame")
store.Frame236.Name = "Frame"
store.Frame236.ZIndex = 6
store.Frame236.Position = UDim2.new(0,34,0,0)
store.Frame236.Size = UDim2.new(0,50,0,28)
store.Frame236.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame236.BackgroundTransparency = 0.5
store.Frame236.BorderSizePixel = 0
store.Frame236.Parent = store.Frame235

store["UICorner215"] = Instance.new("UICorner")
store.UICorner215.Name = "UICorner"
store.UICorner215.Parent = store.Frame236

store["UIStroke147"] = Instance.new("UIStroke")
store.UIStroke147.Name = "UIStroke"
store.UIStroke147.Color = Color3.fromRGB(254,254,254)
store.UIStroke147.Thickness = 1.4
store.UIStroke147.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke147.Transparency = 0.25
store.UIStroke147.Parent = store.Frame236

store["UIGradient47"] = Instance.new("UIGradient")
store.UIGradient47.Name = "UIGradient"
store.UIGradient47.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient47.Parent = store.UIStroke147

store["TextLabel113"] = Instance.new("TextLabel")
store.TextLabel113.Name = "TextLabel"
store.TextLabel113.ZIndex = 7
store.TextLabel113.Size = UDim2.new(1,0,1,0)
store.TextLabel113.BackgroundTransparency = 1
store.TextLabel113.Text = "1.00"
store.TextLabel113.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel113.TextSize = 11
store.TextLabel113.Font = Enum.Font.GothamBlack
store.TextLabel113.Parent = store.Frame236

store["TextButton105"] = Instance.new("TextButton")
store.TextButton105.Name = "TextButton"
store.TextButton105.ZIndex = 6
store.TextButton105.Size = UDim2.new(0,28,0,28)
store.TextButton105.BackgroundColor3 = Color3.fromRGB(32,32,32)
store.TextButton105.BackgroundTransparency = 0.5
store.TextButton105.BorderSizePixel = 0
store.TextButton105.Text = "-"
store.TextButton105.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton105.TextSize = 14
store.TextButton105.Font = Enum.Font.GothamBlack
store.TextButton105.AutoButtonColor = false
store.TextButton105.Parent = store.Frame235

store["UICorner216"] = Instance.new("UICorner")
store.UICorner216.Name = "UICorner"
store.UICorner216.Parent = store.TextButton105

store["UIStroke148"] = Instance.new("UIStroke")
store.UIStroke148.Name = "UIStroke"
store.UIStroke148.Color = Color3.fromRGB(254,254,254)
store.UIStroke148.Thickness = 1.4
store.UIStroke148.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke148.Transparency = 0.25
store.UIStroke148.Parent = store.TextButton105

store["UIGradient48"] = Instance.new("UIGradient")
store.UIGradient48.Name = "UIGradient"
store.UIGradient48.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient48.Parent = store.UIStroke148

store["TextButton106"] = Instance.new("TextButton")
store.TextButton106.Name = "TextButton"
store.TextButton106.ZIndex = 6
store.TextButton106.Position = UDim2.new(0,90,0,0)
store.TextButton106.Size = UDim2.new(0,28,0,28)
store.TextButton106.BackgroundColor3 = Color3.fromRGB(32,32,32)
store.TextButton106.BackgroundTransparency = 0.5
store.TextButton106.BorderSizePixel = 0
store.TextButton106.Text = "+"
store.TextButton106.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton106.TextSize = 14
store.TextButton106.Font = Enum.Font.GothamBlack
store.TextButton106.AutoButtonColor = false
store.TextButton106.Parent = store.Frame235

store["UICorner217"] = Instance.new("UICorner")
store.UICorner217.Name = "UICorner"
store.UICorner217.Parent = store.TextButton106

store["UIStroke149"] = Instance.new("UIStroke")
store.UIStroke149.Name = "UIStroke"
store.UIStroke149.Color = Color3.fromRGB(254,254,254)
store.UIStroke149.Thickness = 1.4
store.UIStroke149.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke149.Transparency = 0.25
store.UIStroke149.Parent = store.TextButton106

store["UIGradient49"] = Instance.new("UIGradient")
store.UIGradient49.Name = "UIGradient"
store.UIGradient49.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient49.Parent = store.UIStroke149

store["Frame237"] = Instance.new("Frame")
store.Frame237.Name = "Frame"
store.Frame237.ZIndex = 4
store.Frame237.LayoutOrder = 13
store.Frame237.Size = UDim2.new(1,0,0,40)
store.Frame237.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame237.BackgroundTransparency = 0.5
store.Frame237.BorderSizePixel = 0
store.Frame237.Parent = store.Page_Settings

store["UICorner218"] = Instance.new("UICorner")
store.UICorner218.Name = "UICorner"
store.UICorner218.CornerRadius = UDim.new(0,10)
store.UICorner218.Parent = store.Frame237

store["UIStroke150"] = Instance.new("UIStroke")
store.UIStroke150.Name = "UIStroke"
store.UIStroke150.Color = Color3.fromRGB(28,28,34)
store.UIStroke150.Parent = store.Frame237

store["TextLabel114"] = Instance.new("TextLabel")
store.TextLabel114.Name = "TextLabel"
store.TextLabel114.ZIndex = 5
store.TextLabel114.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel114.Size = UDim2.new(0.6,0,0,16)
store.TextLabel114.BackgroundTransparency = 1
store.TextLabel114.Text = "Steal Bar Scale"
store.TextLabel114.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel114.TextSize = 11
store.TextLabel114.Font = Enum.Font.GothamBold
store.TextLabel114.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel114.Parent = store.Frame237

store["Frame238"] = Instance.new("Frame")
store.Frame238.Name = "Frame"
store.Frame238.Visible = false
store.Frame238.ZIndex = 5
store.Frame238.Position = UDim2.new(0,12,0.5,7)
store.Frame238.Size = UDim2.new(0,72,0,1)
store.Frame238.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame238.BackgroundTransparency = 0.5
store.Frame238.BorderSizePixel = 0
store.Frame238.Parent = store.Frame237

store["Frame239"] = Instance.new("Frame")
store.Frame239.Name = "Frame"
store.Frame239.ZIndex = 5
store.Frame239.Position = UDim2.new(1,-130,0.5,-14)
store.Frame239.Size = UDim2.new(0,118,0,28)
store.Frame239.BackgroundTransparency = 1
store.Frame239.Parent = store.Frame237

store["Frame240"] = Instance.new("Frame")
store.Frame240.Name = "Frame"
store.Frame240.ZIndex = 6
store.Frame240.Position = UDim2.new(0,34,0,0)
store.Frame240.Size = UDim2.new(0,50,0,28)
store.Frame240.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame240.BackgroundTransparency = 0.5
store.Frame240.BorderSizePixel = 0
store.Frame240.Parent = store.Frame239

store["UICorner219"] = Instance.new("UICorner")
store.UICorner219.Name = "UICorner"
store.UICorner219.Parent = store.Frame240

store["UIStroke151"] = Instance.new("UIStroke")
store.UIStroke151.Name = "UIStroke"
store.UIStroke151.Color = Color3.fromRGB(254,254,254)
store.UIStroke151.Thickness = 1.4
store.UIStroke151.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke151.Transparency = 0.25
store.UIStroke151.Parent = store.Frame240

store["UIGradient50"] = Instance.new("UIGradient")
store.UIGradient50.Name = "UIGradient"
store.UIGradient50.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient50.Parent = store.UIStroke151

store["TextLabel115"] = Instance.new("TextLabel")
store.TextLabel115.Name = "TextLabel"
store.TextLabel115.ZIndex = 7
store.TextLabel115.Size = UDim2.new(1,0,1,0)
store.TextLabel115.BackgroundTransparency = 1
store.TextLabel115.Text = "1.00"
store.TextLabel115.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel115.TextSize = 11
store.TextLabel115.Font = Enum.Font.GothamBlack
store.TextLabel115.Parent = store.Frame240

store["TextButton107"] = Instance.new("TextButton")
store.TextButton107.Name = "TextButton"
store.TextButton107.ZIndex = 6
store.TextButton107.Size = UDim2.new(0,28,0,28)
store.TextButton107.BackgroundColor3 = Color3.fromRGB(32,32,32)
store.TextButton107.BackgroundTransparency = 0.5
store.TextButton107.BorderSizePixel = 0
store.TextButton107.Text = "-"
store.TextButton107.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton107.TextSize = 14
store.TextButton107.Font = Enum.Font.GothamBlack
store.TextButton107.AutoButtonColor = false
store.TextButton107.Parent = store.Frame239

store["UICorner220"] = Instance.new("UICorner")
store.UICorner220.Name = "UICorner"
store.UICorner220.Parent = store.TextButton107

store["UIStroke152"] = Instance.new("UIStroke")
store.UIStroke152.Name = "UIStroke"
store.UIStroke152.Color = Color3.fromRGB(254,254,254)
store.UIStroke152.Thickness = 1.4
store.UIStroke152.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke152.Transparency = 0.25
store.UIStroke152.Parent = store.TextButton107

store["UIGradient51"] = Instance.new("UIGradient")
store.UIGradient51.Name = "UIGradient"
store.UIGradient51.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient51.Parent = store.UIStroke152

store["TextButton108"] = Instance.new("TextButton")
store.TextButton108.Name = "TextButton"
store.TextButton108.ZIndex = 6
store.TextButton108.Position = UDim2.new(0,90,0,0)
store.TextButton108.Size = UDim2.new(0,28,0,28)
store.TextButton108.BackgroundColor3 = Color3.fromRGB(32,32,32)
store.TextButton108.BackgroundTransparency = 0.5
store.TextButton108.BorderSizePixel = 0
store.TextButton108.Text = "+"
store.TextButton108.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton108.TextSize = 14
store.TextButton108.Font = Enum.Font.GothamBlack
store.TextButton108.AutoButtonColor = false
store.TextButton108.Parent = store.Frame239

store["UICorner221"] = Instance.new("UICorner")
store.UICorner221.Name = "UICorner"
store.UICorner221.Parent = store.TextButton108

store["UIStroke153"] = Instance.new("UIStroke")
store.UIStroke153.Name = "UIStroke"
store.UIStroke153.Color = Color3.fromRGB(254,254,254)
store.UIStroke153.Thickness = 1.4
store.UIStroke153.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke153.Transparency = 0.25
store.UIStroke153.Parent = store.TextButton108

store["UIGradient52"] = Instance.new("UIGradient")
store.UIGradient52.Name = "UIGradient"
store.UIGradient52.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient52.Parent = store.UIStroke153

store["Frame241"] = Instance.new("Frame")
store.Frame241.Name = "Frame"
store.Frame241.ZIndex = 4
store.Frame241.LayoutOrder = 14
store.Frame241.Size = UDim2.new(1,0,0,40)
store.Frame241.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame241.BackgroundTransparency = 0.5
store.Frame241.BorderSizePixel = 0
store.Frame241.Parent = store.Page_Settings

store["UICorner222"] = Instance.new("UICorner")
store.UICorner222.Name = "UICorner"
store.UICorner222.CornerRadius = UDim.new(0,10)
store.UICorner222.Parent = store.Frame241

store["UIStroke154"] = Instance.new("UIStroke")
store.UIStroke154.Name = "UIStroke"
store.UIStroke154.Color = Color3.fromRGB(28,28,34)
store.UIStroke154.Parent = store.Frame241

store["TextLabel116"] = Instance.new("TextLabel")
store.TextLabel116.Name = "TextLabel"
store.TextLabel116.ZIndex = 5
store.TextLabel116.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel116.Size = UDim2.new(0.6,0,0,16)
store.TextLabel116.BackgroundTransparency = 1
store.TextLabel116.Text = "Mobile Btn Size"
store.TextLabel116.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel116.TextSize = 11
store.TextLabel116.Font = Enum.Font.GothamBold
store.TextLabel116.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel116.Parent = store.Frame241

store["Frame242"] = Instance.new("Frame")
store.Frame242.Name = "Frame"
store.Frame242.Visible = false
store.Frame242.ZIndex = 5
store.Frame242.Position = UDim2.new(0,12,0.5,7)
store.Frame242.Size = UDim2.new(0,75,0,1)
store.Frame242.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame242.BackgroundTransparency = 0.5
store.Frame242.BorderSizePixel = 0
store.Frame242.Parent = store.Frame241

store["Frame243"] = Instance.new("Frame")
store.Frame243.Name = "Frame"
store.Frame243.ZIndex = 5
store.Frame243.Position = UDim2.new(1,-130,0.5,-14)
store.Frame243.Size = UDim2.new(0,118,0,28)
store.Frame243.BackgroundTransparency = 1
store.Frame243.Parent = store.Frame241

store["Frame244"] = Instance.new("Frame")
store.Frame244.Name = "Frame"
store.Frame244.ZIndex = 6
store.Frame244.Position = UDim2.new(0,34,0,0)
store.Frame244.Size = UDim2.new(0,50,0,28)
store.Frame244.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame244.BackgroundTransparency = 0.5
store.Frame244.BorderSizePixel = 0
store.Frame244.Parent = store.Frame243

store["UICorner223"] = Instance.new("UICorner")
store.UICorner223.Name = "UICorner"
store.UICorner223.Parent = store.Frame244

store["UIStroke155"] = Instance.new("UIStroke")
store.UIStroke155.Name = "UIStroke"
store.UIStroke155.Color = Color3.fromRGB(254,254,254)
store.UIStroke155.Thickness = 1.4
store.UIStroke155.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke155.Transparency = 0.25
store.UIStroke155.Parent = store.Frame244

store["UIGradient53"] = Instance.new("UIGradient")
store.UIGradient53.Name = "UIGradient"
store.UIGradient53.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient53.Parent = store.UIStroke155

store["TextLabel117"] = Instance.new("TextLabel")
store.TextLabel117.Name = "TextLabel"
store.TextLabel117.ZIndex = 7
store.TextLabel117.Size = UDim2.new(1,0,1,0)
store.TextLabel117.BackgroundTransparency = 1
store.TextLabel117.Text = "1.00"
store.TextLabel117.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel117.TextSize = 11
store.TextLabel117.Font = Enum.Font.GothamBlack
store.TextLabel117.Parent = store.Frame244

store["TextButton109"] = Instance.new("TextButton")
store.TextButton109.Name = "TextButton"
store.TextButton109.ZIndex = 6
store.TextButton109.Size = UDim2.new(0,28,0,28)
store.TextButton109.BackgroundColor3 = Color3.fromRGB(32,32,32)
store.TextButton109.BackgroundTransparency = 0.5
store.TextButton109.BorderSizePixel = 0
store.TextButton109.Text = "-"
store.TextButton109.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton109.TextSize = 14
store.TextButton109.Font = Enum.Font.GothamBlack
store.TextButton109.AutoButtonColor = false
store.TextButton109.Parent = store.Frame243

store["UICorner224"] = Instance.new("UICorner")
store.UICorner224.Name = "UICorner"
store.UICorner224.Parent = store.TextButton109

store["UIStroke156"] = Instance.new("UIStroke")
store.UIStroke156.Name = "UIStroke"
store.UIStroke156.Color = Color3.fromRGB(254,254,254)
store.UIStroke156.Thickness = 1.4
store.UIStroke156.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke156.Transparency = 0.25
store.UIStroke156.Parent = store.TextButton109

store["UIGradient54"] = Instance.new("UIGradient")
store.UIGradient54.Name = "UIGradient"
store.UIGradient54.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient54.Parent = store.UIStroke156

store["TextButton110"] = Instance.new("TextButton")
store.TextButton110.Name = "TextButton"
store.TextButton110.ZIndex = 6
store.TextButton110.Position = UDim2.new(0,90,0,0)
store.TextButton110.Size = UDim2.new(0,28,0,28)
store.TextButton110.BackgroundColor3 = Color3.fromRGB(32,32,32)
store.TextButton110.BackgroundTransparency = 0.5
store.TextButton110.BorderSizePixel = 0
store.TextButton110.Text = "+"
store.TextButton110.TextColor3 = Color3.fromRGB(254,254,254)
store.TextButton110.TextSize = 14
store.TextButton110.Font = Enum.Font.GothamBlack
store.TextButton110.AutoButtonColor = false
store.TextButton110.Parent = store.Frame243

store["UICorner225"] = Instance.new("UICorner")
store.UICorner225.Name = "UICorner"
store.UICorner225.Parent = store.TextButton110

store["UIStroke157"] = Instance.new("UIStroke")
store.UIStroke157.Name = "UIStroke"
store.UIStroke157.Color = Color3.fromRGB(254,254,254)
store.UIStroke157.Thickness = 1.4
store.UIStroke157.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke157.Transparency = 0.25
store.UIStroke157.Parent = store.TextButton110

store["UIGradient55"] = Instance.new("UIGradient")
store.UIGradient55.Name = "UIGradient"
store.UIGradient55.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient55.Parent = store.UIStroke157

store["Frame245"] = Instance.new("Frame")
store.Frame245.Name = "Frame"
store.Frame245.ZIndex = 4
store.Frame245.LayoutOrder = 15
store.Frame245.Size = UDim2.new(1,0,0,40)
store.Frame245.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame245.BackgroundTransparency = 0.5
store.Frame245.BorderSizePixel = 0
store.Frame245.Parent = store.Page_Settings

store["UICorner226"] = Instance.new("UICorner")
store.UICorner226.Name = "UICorner"
store.UICorner226.CornerRadius = UDim.new(0,10)
store.UICorner226.Parent = store.Frame245

store["UIStroke158"] = Instance.new("UIStroke")
store.UIStroke158.Name = "UIStroke"
store.UIStroke158.Color = Color3.fromRGB(28,28,34)
store.UIStroke158.Parent = store.Frame245

store["TextLabel118"] = Instance.new("TextLabel")
store.TextLabel118.Name = "TextLabel"
store.TextLabel118.ZIndex = 5
store.TextLabel118.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel118.Size = UDim2.new(0.6,0,0,16)
store.TextLabel118.BackgroundTransparency = 1
store.TextLabel118.Text = "Hide Mobile Buttons"
store.TextLabel118.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel118.TextSize = 11
store.TextLabel118.Font = Enum.Font.GothamBold
store.TextLabel118.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel118.Parent = store.Frame245

store["Frame246"] = Instance.new("Frame")
store.Frame246.Name = "Frame"
store.Frame246.Visible = false
store.Frame246.ZIndex = 5
store.Frame246.Position = UDim2.new(0,12,0.5,7)
store.Frame246.Size = UDim2.new(0,100,0,1)
store.Frame246.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame246.BackgroundTransparency = 0.5
store.Frame246.BorderSizePixel = 0
store.Frame246.Parent = store.Frame245

store["Frame247"] = Instance.new("Frame")
store.Frame247.Name = "Frame"
store.Frame247.ZIndex = 6
store.Frame247.Position = UDim2.new(1,-44,0.5,-8)
store.Frame247.Size = UDim2.new(0,32,0,16)
store.Frame247.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame247.BackgroundTransparency = 0.5
store.Frame247.BorderSizePixel = 0
store.Frame247.Parent = store.Frame245

store["UICorner227"] = Instance.new("UICorner")
store.UICorner227.Name = "UICorner"
store.UICorner227.CornerRadius = UDim.new(1,0)
store.UICorner227.Parent = store.Frame247

store["UIStroke159"] = Instance.new("UIStroke")
store.UIStroke159.Name = "UIStroke"
store.UIStroke159.Color = Color3.fromRGB(70,70,70)
store.UIStroke159.Transparency = 0.5
store.UIStroke159.Parent = store.Frame247

store["Frame248"] = Instance.new("Frame")
store.Frame248.Name = "Frame"
store.Frame248.ZIndex = 7
store.Frame248.Position = UDim2.new(0,2,0.5,-6)
store.Frame248.Size = UDim2.new(0,12,0,12)
store.Frame248.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame248.BackgroundTransparency = 0.5
store.Frame248.BorderSizePixel = 0
store.Frame248.Parent = store.Frame247

store["UICorner228"] = Instance.new("UICorner")
store.UICorner228.Name = "UICorner"
store.UICorner228.CornerRadius = UDim.new(1,0)
store.UICorner228.Parent = store.Frame248

store["TextButton111"] = Instance.new("TextButton")
store.TextButton111.Name = "TextButton"
store.TextButton111.ZIndex = 8
store.TextButton111.Size = UDim2.new(1,0,1,0)
store.TextButton111.BackgroundTransparency = 1
store.TextButton111.Text = ""
store.TextButton111.Parent = store.Frame245

store["PressPop25"] = Instance.new("UIScale")
store.PressPop25.Name = "PressPop"
store.PressPop25.Parent = store.Frame245

store["TextButton112"] = Instance.new("TextButton")
store.TextButton112.Name = "TextButton"
store.TextButton112.ZIndex = 12
store.TextButton112.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton112.Size = UDim2.new(0,32,0,22)
store.TextButton112.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton112.BackgroundTransparency = 0.5
store.TextButton112.BorderSizePixel = 0
store.TextButton112.Text = ""
store.TextButton112.AutoButtonColor = false
store.TextButton112.Parent = store.Frame245

store["UICorner229"] = Instance.new("UICorner")
store.UICorner229.Name = "UICorner"
store.UICorner229.CornerRadius = UDim.new(0,6)
store.UICorner229.Parent = store.TextButton112

store["UIStroke160"] = Instance.new("UIStroke")
store.UIStroke160.Name = "UIStroke"
store.UIStroke160.Color = Color3.fromRGB(254,254,254)
store.UIStroke160.Thickness = 1.4
store.UIStroke160.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke160.Transparency = 0.25
store.UIStroke160.Parent = store.TextButton112

store["UIGradient56"] = Instance.new("UIGradient")
store.UIGradient56.Name = "UIGradient"
store.UIGradient56.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient56.Parent = store.UIStroke160

store["TextLabel119"] = Instance.new("TextLabel")
store.TextLabel119.Name = "TextLabel"
store.TextLabel119.ZIndex = 20
store.TextLabel119.Size = UDim2.new(1,0,1,0)
store.TextLabel119.BackgroundTransparency = 1
store.TextLabel119.Text = "▼"
store.TextLabel119.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel119.TextSize = 15
store.TextLabel119.Font = Enum.Font.GothamBlack
store.TextLabel119.Parent = store.TextButton112

store["Frame249"] = Instance.new("Frame")
store.Frame249.Name = "Frame"
store.Frame249.ZIndex = 4
store.Frame249.LayoutOrder = 28
store.Frame249.Size = UDim2.new(1,0,0,40)
store.Frame249.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame249.BackgroundTransparency = 0.5
store.Frame249.BorderSizePixel = 0
store.Frame249.Parent = store.Page_Settings

store["UICorner230"] = Instance.new("UICorner")
store.UICorner230.Name = "UICorner"
store.UICorner230.CornerRadius = UDim.new(0,10)
store.UICorner230.Parent = store.Frame249

store["UIStroke161"] = Instance.new("UIStroke")
store.UIStroke161.Name = "UIStroke"
store.UIStroke161.Color = Color3.fromRGB(28,28,34)
store.UIStroke161.Parent = store.Frame249

store["TextLabel120"] = Instance.new("TextLabel")
store.TextLabel120.Name = "TextLabel"
store.TextLabel120.ZIndex = 5
store.TextLabel120.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel120.Size = UDim2.new(0.6,0,0,16)
store.TextLabel120.BackgroundTransparency = 1
store.TextLabel120.Text = "Circle Buttons"
store.TextLabel120.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel120.TextSize = 11
store.TextLabel120.Font = Enum.Font.GothamBold
store.TextLabel120.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel120.Parent = store.Frame249

store["Frame250"] = Instance.new("Frame")
store.Frame250.Name = "Frame"
store.Frame250.Visible = false
store.Frame250.ZIndex = 5
store.Frame250.Position = UDim2.new(0,12,0.5,7)
store.Frame250.Size = UDim2.new(0,69,0,1)
store.Frame250.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame250.BackgroundTransparency = 0.5
store.Frame250.BorderSizePixel = 0
store.Frame250.Parent = store.Frame249

store["Frame251"] = Instance.new("Frame")
store.Frame251.Name = "Frame"
store.Frame251.ZIndex = 6
store.Frame251.Position = UDim2.new(1,-44,0.5,-8)
store.Frame251.Size = UDim2.new(0,32,0,16)
store.Frame251.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame251.BackgroundTransparency = 0.5
store.Frame251.BorderSizePixel = 0
store.Frame251.Parent = store.Frame249

store["UICorner231"] = Instance.new("UICorner")
store.UICorner231.Name = "UICorner"
store.UICorner231.CornerRadius = UDim.new(1,0)
store.UICorner231.Parent = store.Frame251

store["UIStroke162"] = Instance.new("UIStroke")
store.UIStroke162.Name = "UIStroke"
store.UIStroke162.Color = Color3.fromRGB(70,70,70)
store.UIStroke162.Transparency = 0.5
store.UIStroke162.Parent = store.Frame251

store["Frame252"] = Instance.new("Frame")
store.Frame252.Name = "Frame"
store.Frame252.ZIndex = 7
store.Frame252.Position = UDim2.new(0,2,0.5,-6)
store.Frame252.Size = UDim2.new(0,12,0,12)
store.Frame252.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame252.BackgroundTransparency = 0.5
store.Frame252.BorderSizePixel = 0
store.Frame252.Parent = store.Frame251

store["UICorner232"] = Instance.new("UICorner")
store.UICorner232.Name = "UICorner"
store.UICorner232.CornerRadius = UDim.new(1,0)
store.UICorner232.Parent = store.Frame252

store["TextButton113"] = Instance.new("TextButton")
store.TextButton113.Name = "TextButton"
store.TextButton113.ZIndex = 8
store.TextButton113.Size = UDim2.new(1,0,1,0)
store.TextButton113.BackgroundTransparency = 1
store.TextButton113.Text = ""
store.TextButton113.Parent = store.Frame249

store["PressPop26"] = Instance.new("UIScale")
store.PressPop26.Name = "PressPop"
store.PressPop26.Parent = store.Frame249

store["Frame253"] = Instance.new("Frame")
store.Frame253.Name = "Frame"
store.Frame253.ZIndex = 4
store.Frame253.LayoutOrder = 29
store.Frame253.Size = UDim2.new(1,0,0,36)
store.Frame253.BackgroundTransparency = 1
store.Frame253.BorderSizePixel = 0
store.Frame253.Parent = store.Page_Settings

store["TextButton114"] = Instance.new("TextButton")
store.TextButton114.Name = "TextButton"
store.TextButton114.ZIndex = 5
store.TextButton114.Size = UDim2.new(1,0,1,0)
store.TextButton114.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton114.BackgroundTransparency = 0.5
store.TextButton114.BorderSizePixel = 0
store.TextButton114.Text = ""
store.TextButton114.AutoButtonColor = false
store.TextButton114.Parent = store.Frame253

store["UICorner233"] = Instance.new("UICorner")
store.UICorner233.Name = "UICorner"
store.UICorner233.CornerRadius = UDim.new(0,10)
store.UICorner233.Parent = store.TextButton114

store["UIStroke163"] = Instance.new("UIStroke")
store.UIStroke163.Name = "UIStroke"
store.UIStroke163.Color = Color3.fromRGB(254,254,254)
store.UIStroke163.Thickness = 1.4
store.UIStroke163.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke163.Transparency = 0.25
store.UIStroke163.Parent = store.TextButton114

store["UIGradient57"] = Instance.new("UIGradient")
store.UIGradient57.Name = "UIGradient"
store.UIGradient57.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient57.Parent = store.UIStroke163

store["TextLabel121"] = Instance.new("TextLabel")
store.TextLabel121.Name = "TextLabel"
store.TextLabel121.ZIndex = 6
store.TextLabel121.Size = UDim2.new(1,0,1,0)
store.TextLabel121.BackgroundTransparency = 1
store.TextLabel121.Text = "RESET MOBILE BUTTONS"
store.TextLabel121.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel121.TextSize = 11
store.TextLabel121.Font = Enum.Font.GothamBlack
store.TextLabel121.Parent = store.TextButton114

store["Frame254"] = Instance.new("Frame")
store.Frame254.Name = "Frame"
store.Frame254.ZIndex = 4
store.Frame254.LayoutOrder = 200
store.Frame254.Size = UDim2.new(1,0,0,48)
store.Frame254.BackgroundTransparency = 1
store.Frame254.BorderSizePixel = 0
store.Frame254.Parent = store.Page_Settings

store["ImageLabel"] = Instance.new("ImageLabel")
store.ImageLabel.Name = "ImageLabel"
store.ImageLabel.ZIndex = 4
store.ImageLabel.Position = UDim2.new(0,-10,0,-10)
store.ImageLabel.Size = UDim2.new(1,20,1,20)
store.ImageLabel.BackgroundTransparency = 1
store.ImageLabel.Image = "rbxassetid://5028857084"
store.ImageLabel.ImageColor3 = Color3.fromRGB(254,254,254)
store.ImageLabel.ImageTransparency = 0.88
store.ImageLabel.ScaleType = Enum.ScaleType.Slice
store.ImageLabel.SliceCenter = Rect.new(24,24,276,276)
store.ImageLabel.Parent = store.Frame254

store["TextButton115"] = Instance.new("TextButton")
store.TextButton115.Name = "TextButton"
store.TextButton115.ZIndex = 5
store.TextButton115.Position = UDim2.new(0,0,0.5,-18)
store.TextButton115.Size = UDim2.new(1,0,0,36)
store.TextButton115.BackgroundColor3 = Color3.fromRGB(18,12,20)
store.TextButton115.BackgroundTransparency = 0.5
store.TextButton115.BorderSizePixel = 0
store.TextButton115.Text = ""
store.TextButton115.AutoButtonColor = false
store.TextButton115.Parent = store.Frame254

store["UICorner234"] = Instance.new("UICorner")
store.UICorner234.Name = "UICorner"
store.UICorner234.CornerRadius = UDim.new(0,10)
store.UICorner234.Parent = store.TextButton115

store["UIGradient58"] = Instance.new("UIGradient")
store.UIGradient58.Name = "UIGradient"
store.UIGradient58.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(30,16,32)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(16,10,20)),ColorSequenceKeypoint.new(1,Color3.fromRGB(30,16,32))})
store.UIGradient58.Rotation = 135
store.UIGradient58.Parent = store.TextButton115

store["UIStroke164"] = Instance.new("UIStroke")
store.UIStroke164.Name = "UIStroke"
store.UIStroke164.Color = Color3.fromRGB(254,254,254)
store.UIStroke164.Thickness = 1.4
store.UIStroke164.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke164.Transparency = 0.2
store.UIStroke164.Parent = store.TextButton115

store["UIGradient59"] = Instance.new("UIGradient")
store.UIGradient59.Name = "UIGradient"
store.UIGradient59.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.3,Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(254,254,254)),ColorSequenceKeypoint.new(0.7,Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient59.Parent = store.UIStroke164

store["TextLabel122"] = Instance.new("TextLabel")
store.TextLabel122.Name = "TextLabel"
store.TextLabel122.ZIndex = 7
store.TextLabel122.Size = UDim2.new(1,0,1,0)
store.TextLabel122.BackgroundTransparency = 1
store.TextLabel122.Text = "RESET ALL CONFIG"
store.TextLabel122.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel122.TextSize = 12
store.TextLabel122.Font = Enum.Font.GothamBlack
store.TextLabel122.Parent = store.TextButton115

store["UIGradient60"] = Instance.new("UIGradient")
store.UIGradient60.Name = "UIGradient"
store.UIGradient60.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(254,254,254)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(245,245,245)),ColorSequenceKeypoint.new(1,Color3.fromRGB(254,254,254))})
store.UIGradient60.Parent = store.TextLabel122

store["Frame255"] = Instance.new("Frame")
store.Frame255.Name = "Frame"
store.Frame255.LayoutOrder = 30
store.Frame255.Size = UDim2.new(1,0,0,42)
store.Frame255.BackgroundTransparency = 1
store.Frame255.BorderSizePixel = 0
store.Frame255.Parent = store.Page_Settings

store["TextLabel123"] = Instance.new("TextLabel")
store.TextLabel123.Name = "TextLabel"
store.TextLabel123.ZIndex = 4
store.TextLabel123.Position = UDim2.new(0,0,0,20)
store.TextLabel123.Size = UDim2.new(1,0,0,16)
store.TextLabel123.BackgroundTransparency = 1
store.TextLabel123.Text = "CONFIGS"
store.TextLabel123.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel123.TextSize = 12
store.TextLabel123.Font = Enum.Font.GothamBlack
store.TextLabel123.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel123.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel123.Parent = store.Frame255

store["Frame256"] = Instance.new("Frame")
store.Frame256.Name = "Frame"
store.Frame256.ZIndex = 3
store.Frame256.Position = UDim2.new(0,0,0,38)
store.Frame256.Size = UDim2.new(1,0,0,1)
store.Frame256.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame256.BackgroundTransparency = 0.85
store.Frame256.BorderSizePixel = 0
store.Frame256.Parent = store.Frame255

store["Frame257"] = Instance.new("Frame")
store.Frame257.Name = "Frame"
store.Frame257.ZIndex = 4
store.Frame257.LayoutOrder = 31
store.Frame257.Size = UDim2.new(1,0,0,34)
store.Frame257.BackgroundTransparency = 1
store.Frame257.BorderSizePixel = 0
store.Frame257.Parent = store.Page_Settings

store["Frame258"] = Instance.new("Frame")
store.Frame258.Name = "Frame"
store.Frame258.Size = UDim2.new(0.65,-4,1,0)
store.Frame258.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame258.BackgroundTransparency = 0.5
store.Frame258.BorderSizePixel = 0
store.Frame258.Parent = store.Frame257

store["UICorner235"] = Instance.new("UICorner")
store.UICorner235.Name = "UICorner"
store.UICorner235.CornerRadius = UDim.new(0,12)
store.UICorner235.Parent = store.Frame258

store["UIStroke165"] = Instance.new("UIStroke")
store.UIStroke165.Name = "UIStroke"
store.UIStroke165.Color = Color3.fromRGB(254,254,254)
store.UIStroke165.Transparency = 0.5
store.UIStroke165.Parent = store.Frame258

store["TextBox14"] = Instance.new("TextBox")
store.TextBox14.Name = "TextBox"
store.TextBox14.ZIndex = 5
store.TextBox14.Position = UDim2.new(0,8,0,0)
store.TextBox14.Size = UDim2.new(1,-16,1,0)
store.TextBox14.BackgroundTransparency = 1
store.TextBox14.Text = ""
store.TextBox14.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox14.TextSize = 10
store.TextBox14.Font = Enum.Font.GothamBold
store.TextBox14.TextXAlignment = Enum.TextXAlignment.Left
store.TextBox14.PlaceholderText = "Config name..."
store.TextBox14.PlaceholderColor3 = Color3.fromRGB(120,120,130)
store.TextBox14.ClearTextOnFocus = false
store.TextBox14.Parent = store.Frame258

store["TextButton116"] = Instance.new("TextButton")
store.TextButton116.Name = "TextButton"
store.TextButton116.ZIndex = 5
store.TextButton116.Position = UDim2.new(0.65,4,0,0)
store.TextButton116.Size = UDim2.new(0.35,-4,1,0)
store.TextButton116.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton116.BackgroundTransparency = 0.5
store.TextButton116.BorderSizePixel = 0
store.TextButton116.Text = "SAVE"
store.TextButton116.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton116.TextSize = 10
store.TextButton116.Font = Enum.Font.GothamBlack
store.TextButton116.AutoButtonColor = false
store.TextButton116.Parent = store.Frame257

store["UICorner236"] = Instance.new("UICorner")
store.UICorner236.Name = "UICorner"
store.UICorner236.CornerRadius = UDim.new(0,12)
store.UICorner236.Parent = store.TextButton116

store["Frame259"] = Instance.new("Frame")
store.Frame259.Name = "Frame"
store.Frame259.Visible = false
store.Frame259.ZIndex = 4
store.Frame259.LayoutOrder = 16
store.Frame259.Size = UDim2.new(1,0,0,40)
store.Frame259.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame259.BackgroundTransparency = 0.5
store.Frame259.BorderSizePixel = 0
store.Frame259.Parent = store.Page_Settings

store["UICorner237"] = Instance.new("UICorner")
store.UICorner237.Name = "UICorner"
store.UICorner237.CornerRadius = UDim.new(0,10)
store.UICorner237.Parent = store.Frame259

store["UIStroke166"] = Instance.new("UIStroke")
store.UIStroke166.Name = "UIStroke"
store.UIStroke166.Color = Color3.fromRGB(28,28,34)
store.UIStroke166.Parent = store.Frame259

store["TextLabel124"] = Instance.new("TextLabel")
store.TextLabel124.Name = "TextLabel"
store.TextLabel124.ZIndex = 5
store.TextLabel124.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel124.Size = UDim2.new(0.6,0,0,16)
store.TextLabel124.BackgroundTransparency = 1
store.TextLabel124.Text = "TP BAT"
store.TextLabel124.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel124.TextSize = 11
store.TextLabel124.Font = Enum.Font.GothamBold
store.TextLabel124.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel124.Parent = store.Frame259

store["Frame260"] = Instance.new("Frame")
store.Frame260.Name = "Frame"
store.Frame260.Visible = false
store.Frame260.ZIndex = 5
store.Frame260.Position = UDim2.new(0,12,0.5,7)
store.Frame260.Size = UDim2.new(0,35,0,1)
store.Frame260.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame260.BackgroundTransparency = 0.5
store.Frame260.BorderSizePixel = 0
store.Frame260.Parent = store.Frame259

store["Frame261"] = Instance.new("Frame")
store.Frame261.Name = "Frame"
store.Frame261.ZIndex = 6
store.Frame261.Position = UDim2.new(1,-44,0.5,-8)
store.Frame261.Size = UDim2.new(0,32,0,16)
store.Frame261.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame261.BackgroundTransparency = 0.5
store.Frame261.BorderSizePixel = 0
store.Frame261.Parent = store.Frame259

store["UICorner238"] = Instance.new("UICorner")
store.UICorner238.Name = "UICorner"
store.UICorner238.CornerRadius = UDim.new(1,0)
store.UICorner238.Parent = store.Frame261

store["UIStroke167"] = Instance.new("UIStroke")
store.UIStroke167.Name = "UIStroke"
store.UIStroke167.Color = Color3.fromRGB(255,255,255)
store.UIStroke167.Transparency = 0.4
store.UIStroke167.Parent = store.Frame261

store["Frame262"] = Instance.new("Frame")
store.Frame262.Name = "Frame"
store.Frame262.ZIndex = 7
store.Frame262.Position = UDim2.new(0,18,0.5,-6)
store.Frame262.Size = UDim2.new(0,12,0,12)
store.Frame262.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame262.BackgroundTransparency = 0.5
store.Frame262.BorderSizePixel = 0
store.Frame262.Parent = store.Frame261

store["UICorner239"] = Instance.new("UICorner")
store.UICorner239.Name = "UICorner"
store.UICorner239.CornerRadius = UDim.new(1,0)
store.UICorner239.Parent = store.Frame262

store["TextButton117"] = Instance.new("TextButton")
store.TextButton117.Name = "TextButton"
store.TextButton117.ZIndex = 8
store.TextButton117.Size = UDim2.new(1,0,1,0)
store.TextButton117.BackgroundTransparency = 1
store.TextButton117.Text = ""
store.TextButton117.Parent = store.Frame259

store["PressPop27"] = Instance.new("UIScale")
store.PressPop27.Name = "PressPop"
store.PressPop27.Parent = store.Frame259

store["Frame263"] = Instance.new("Frame")
store.Frame263.Name = "Frame"
store.Frame263.Visible = false
store.Frame263.ZIndex = 4
store.Frame263.LayoutOrder = 17
store.Frame263.Size = UDim2.new(1,0,0,40)
store.Frame263.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame263.BackgroundTransparency = 0.5
store.Frame263.BorderSizePixel = 0
store.Frame263.Parent = store.Page_Settings

store["UICorner240"] = Instance.new("UICorner")
store.UICorner240.Name = "UICorner"
store.UICorner240.CornerRadius = UDim.new(0,10)
store.UICorner240.Parent = store.Frame263

store["UIStroke168"] = Instance.new("UIStroke")
store.UIStroke168.Name = "UIStroke"
store.UIStroke168.Color = Color3.fromRGB(28,28,34)
store.UIStroke168.Parent = store.Frame263

store["TextLabel125"] = Instance.new("TextLabel")
store.TextLabel125.Name = "TextLabel"
store.TextLabel125.ZIndex = 5
store.TextLabel125.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel125.Size = UDim2.new(0.6,0,0,16)
store.TextLabel125.BackgroundTransparency = 1
store.TextLabel125.Text = "DROP"
store.TextLabel125.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel125.TextSize = 11
store.TextLabel125.Font = Enum.Font.GothamBold
store.TextLabel125.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel125.Parent = store.Frame263

store["Frame264"] = Instance.new("Frame")
store.Frame264.Name = "Frame"
store.Frame264.Visible = false
store.Frame264.ZIndex = 5
store.Frame264.Position = UDim2.new(0,12,0.5,7)
store.Frame264.Size = UDim2.new(0,30,0,1)
store.Frame264.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame264.BackgroundTransparency = 0.5
store.Frame264.BorderSizePixel = 0
store.Frame264.Parent = store.Frame263

store["Frame265"] = Instance.new("Frame")
store.Frame265.Name = "Frame"
store.Frame265.ZIndex = 6
store.Frame265.Position = UDim2.new(1,-44,0.5,-8)
store.Frame265.Size = UDim2.new(0,32,0,16)
store.Frame265.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame265.BackgroundTransparency = 0.5
store.Frame265.BorderSizePixel = 0
store.Frame265.Parent = store.Frame263

store["UICorner241"] = Instance.new("UICorner")
store.UICorner241.Name = "UICorner"
store.UICorner241.CornerRadius = UDim.new(1,0)
store.UICorner241.Parent = store.Frame265

store["UIStroke169"] = Instance.new("UIStroke")
store.UIStroke169.Name = "UIStroke"
store.UIStroke169.Color = Color3.fromRGB(255,255,255)
store.UIStroke169.Transparency = 0.4
store.UIStroke169.Parent = store.Frame265

store["Frame266"] = Instance.new("Frame")
store.Frame266.Name = "Frame"
store.Frame266.ZIndex = 7
store.Frame266.Position = UDim2.new(0,18,0.5,-6)
store.Frame266.Size = UDim2.new(0,12,0,12)
store.Frame266.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame266.BackgroundTransparency = 0.5
store.Frame266.BorderSizePixel = 0
store.Frame266.Parent = store.Frame265

store["UICorner242"] = Instance.new("UICorner")
store.UICorner242.Name = "UICorner"
store.UICorner242.CornerRadius = UDim.new(1,0)
store.UICorner242.Parent = store.Frame266

store["TextButton118"] = Instance.new("TextButton")
store.TextButton118.Name = "TextButton"
store.TextButton118.ZIndex = 8
store.TextButton118.Size = UDim2.new(1,0,1,0)
store.TextButton118.BackgroundTransparency = 1
store.TextButton118.Text = ""
store.TextButton118.Parent = store.Frame263

store["PressPop28"] = Instance.new("UIScale")
store.PressPop28.Name = "PressPop"
store.PressPop28.Parent = store.Frame263

store["Frame267"] = Instance.new("Frame")
store.Frame267.Name = "Frame"
store.Frame267.Visible = false
store.Frame267.ZIndex = 4
store.Frame267.LayoutOrder = 18
store.Frame267.Size = UDim2.new(1,0,0,40)
store.Frame267.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame267.BackgroundTransparency = 0.5
store.Frame267.BorderSizePixel = 0
store.Frame267.Parent = store.Page_Settings

store["UICorner243"] = Instance.new("UICorner")
store.UICorner243.Name = "UICorner"
store.UICorner243.CornerRadius = UDim.new(0,10)
store.UICorner243.Parent = store.Frame267

store["UIStroke170"] = Instance.new("UIStroke")
store.UIStroke170.Name = "UIStroke"
store.UIStroke170.Color = Color3.fromRGB(28,28,34)
store.UIStroke170.Parent = store.Frame267

store["TextLabel126"] = Instance.new("TextLabel")
store.TextLabel126.Name = "TextLabel"
store.TextLabel126.ZIndex = 5
store.TextLabel126.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel126.Size = UDim2.new(0.6,0,0,16)
store.TextLabel126.BackgroundTransparency = 1
store.TextLabel126.Text = "AUTO LEFT"
store.TextLabel126.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel126.TextSize = 11
store.TextLabel126.Font = Enum.Font.GothamBold
store.TextLabel126.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel126.Parent = store.Frame267

store["Frame268"] = Instance.new("Frame")
store.Frame268.Name = "Frame"
store.Frame268.Visible = false
store.Frame268.ZIndex = 5
store.Frame268.Position = UDim2.new(0,12,0.5,7)
store.Frame268.Size = UDim2.new(0,55,0,1)
store.Frame268.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame268.BackgroundTransparency = 0.5
store.Frame268.BorderSizePixel = 0
store.Frame268.Parent = store.Frame267

store["Frame269"] = Instance.new("Frame")
store.Frame269.Name = "Frame"
store.Frame269.ZIndex = 6
store.Frame269.Position = UDim2.new(1,-44,0.5,-8)
store.Frame269.Size = UDim2.new(0,32,0,16)
store.Frame269.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame269.BackgroundTransparency = 0.5
store.Frame269.BorderSizePixel = 0
store.Frame269.Parent = store.Frame267

store["UICorner244"] = Instance.new("UICorner")
store.UICorner244.Name = "UICorner"
store.UICorner244.CornerRadius = UDim.new(1,0)
store.UICorner244.Parent = store.Frame269

store["UIStroke171"] = Instance.new("UIStroke")
store.UIStroke171.Name = "UIStroke"
store.UIStroke171.Color = Color3.fromRGB(255,255,255)
store.UIStroke171.Transparency = 0.4
store.UIStroke171.Parent = store.Frame269

store["Frame270"] = Instance.new("Frame")
store.Frame270.Name = "Frame"
store.Frame270.ZIndex = 7
store.Frame270.Position = UDim2.new(0,18,0.5,-6)
store.Frame270.Size = UDim2.new(0,12,0,12)
store.Frame270.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame270.BackgroundTransparency = 0.5
store.Frame270.BorderSizePixel = 0
store.Frame270.Parent = store.Frame269

store["UICorner245"] = Instance.new("UICorner")
store.UICorner245.Name = "UICorner"
store.UICorner245.CornerRadius = UDim.new(1,0)
store.UICorner245.Parent = store.Frame270

store["TextButton119"] = Instance.new("TextButton")
store.TextButton119.Name = "TextButton"
store.TextButton119.ZIndex = 8
store.TextButton119.Size = UDim2.new(1,0,1,0)
store.TextButton119.BackgroundTransparency = 1
store.TextButton119.Text = ""
store.TextButton119.Parent = store.Frame267

store["PressPop29"] = Instance.new("UIScale")
store.PressPop29.Name = "PressPop"
store.PressPop29.Parent = store.Frame267

store["Frame271"] = Instance.new("Frame")
store.Frame271.Name = "Frame"
store.Frame271.Visible = false
store.Frame271.ZIndex = 4
store.Frame271.LayoutOrder = 19
store.Frame271.Size = UDim2.new(1,0,0,40)
store.Frame271.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame271.BackgroundTransparency = 0.5
store.Frame271.BorderSizePixel = 0
store.Frame271.Parent = store.Page_Settings

store["UICorner246"] = Instance.new("UICorner")
store.UICorner246.Name = "UICorner"
store.UICorner246.CornerRadius = UDim.new(0,10)
store.UICorner246.Parent = store.Frame271

store["UIStroke172"] = Instance.new("UIStroke")
store.UIStroke172.Name = "UIStroke"
store.UIStroke172.Color = Color3.fromRGB(28,28,34)
store.UIStroke172.Parent = store.Frame271

store["TextLabel127"] = Instance.new("TextLabel")
store.TextLabel127.Name = "TextLabel"
store.TextLabel127.ZIndex = 5
store.TextLabel127.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel127.Size = UDim2.new(0.6,0,0,16)
store.TextLabel127.BackgroundTransparency = 1
store.TextLabel127.Text = "INSTA RESET"
store.TextLabel127.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel127.TextSize = 11
store.TextLabel127.Font = Enum.Font.GothamBold
store.TextLabel127.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel127.Parent = store.Frame271

store["Frame272"] = Instance.new("Frame")
store.Frame272.Name = "Frame"
store.Frame272.Visible = false
store.Frame272.ZIndex = 5
store.Frame272.Position = UDim2.new(0,12,0.5,7)
store.Frame272.Size = UDim2.new(0,63,0,1)
store.Frame272.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame272.BackgroundTransparency = 0.5
store.Frame272.BorderSizePixel = 0
store.Frame272.Parent = store.Frame271

store["Frame273"] = Instance.new("Frame")
store.Frame273.Name = "Frame"
store.Frame273.ZIndex = 6
store.Frame273.Position = UDim2.new(1,-44,0.5,-8)
store.Frame273.Size = UDim2.new(0,32,0,16)
store.Frame273.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame273.BackgroundTransparency = 0.5
store.Frame273.BorderSizePixel = 0
store.Frame273.Parent = store.Frame271

store["UICorner247"] = Instance.new("UICorner")
store.UICorner247.Name = "UICorner"
store.UICorner247.CornerRadius = UDim.new(1,0)
store.UICorner247.Parent = store.Frame273

store["UIStroke173"] = Instance.new("UIStroke")
store.UIStroke173.Name = "UIStroke"
store.UIStroke173.Color = Color3.fromRGB(255,255,255)
store.UIStroke173.Transparency = 0.4
store.UIStroke173.Parent = store.Frame273

store["Frame274"] = Instance.new("Frame")
store.Frame274.Name = "Frame"
store.Frame274.ZIndex = 7
store.Frame274.Position = UDim2.new(0,18,0.5,-6)
store.Frame274.Size = UDim2.new(0,12,0,12)
store.Frame274.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame274.BackgroundTransparency = 0.5
store.Frame274.BorderSizePixel = 0
store.Frame274.Parent = store.Frame273

store["UICorner248"] = Instance.new("UICorner")
store.UICorner248.Name = "UICorner"
store.UICorner248.CornerRadius = UDim.new(1,0)
store.UICorner248.Parent = store.Frame274

store["TextButton120"] = Instance.new("TextButton")
store.TextButton120.Name = "TextButton"
store.TextButton120.ZIndex = 8
store.TextButton120.Size = UDim2.new(1,0,1,0)
store.TextButton120.BackgroundTransparency = 1
store.TextButton120.Text = ""
store.TextButton120.Parent = store.Frame271

store["PressPop30"] = Instance.new("UIScale")
store.PressPop30.Name = "PressPop"
store.PressPop30.Parent = store.Frame271

store["Frame275"] = Instance.new("Frame")
store.Frame275.Name = "Frame"
store.Frame275.Visible = false
store.Frame275.ZIndex = 4
store.Frame275.LayoutOrder = 20
store.Frame275.Size = UDim2.new(1,0,0,40)
store.Frame275.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame275.BackgroundTransparency = 0.5
store.Frame275.BorderSizePixel = 0
store.Frame275.Parent = store.Page_Settings

store["UICorner249"] = Instance.new("UICorner")
store.UICorner249.Name = "UICorner"
store.UICorner249.CornerRadius = UDim.new(0,10)
store.UICorner249.Parent = store.Frame275

store["UIStroke174"] = Instance.new("UIStroke")
store.UIStroke174.Name = "UIStroke"
store.UIStroke174.Color = Color3.fromRGB(28,28,34)
store.UIStroke174.Parent = store.Frame275

store["TextLabel128"] = Instance.new("TextLabel")
store.TextLabel128.Name = "TextLabel"
store.TextLabel128.ZIndex = 5
store.TextLabel128.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel128.Size = UDim2.new(0.6,0,0,16)
store.TextLabel128.BackgroundTransparency = 1
store.TextLabel128.Text = "AIMBOT"
store.TextLabel128.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel128.TextSize = 11
store.TextLabel128.Font = Enum.Font.GothamBold
store.TextLabel128.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel128.Parent = store.Frame275

store["Frame276"] = Instance.new("Frame")
store.Frame276.Name = "Frame"
store.Frame276.Visible = false
store.Frame276.ZIndex = 5
store.Frame276.Position = UDim2.new(0,12,0.5,7)
store.Frame276.Size = UDim2.new(0,40,0,1)
store.Frame276.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame276.BackgroundTransparency = 0.5
store.Frame276.BorderSizePixel = 0
store.Frame276.Parent = store.Frame275

store["Frame277"] = Instance.new("Frame")
store.Frame277.Name = "Frame"
store.Frame277.ZIndex = 6
store.Frame277.Position = UDim2.new(1,-44,0.5,-8)
store.Frame277.Size = UDim2.new(0,32,0,16)
store.Frame277.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame277.BackgroundTransparency = 0.5
store.Frame277.BorderSizePixel = 0
store.Frame277.Parent = store.Frame275

store["UICorner250"] = Instance.new("UICorner")
store.UICorner250.Name = "UICorner"
store.UICorner250.CornerRadius = UDim.new(1,0)
store.UICorner250.Parent = store.Frame277

store["UIStroke175"] = Instance.new("UIStroke")
store.UIStroke175.Name = "UIStroke"
store.UIStroke175.Color = Color3.fromRGB(255,255,255)
store.UIStroke175.Transparency = 0.4
store.UIStroke175.Parent = store.Frame277

store["Frame278"] = Instance.new("Frame")
store.Frame278.Name = "Frame"
store.Frame278.ZIndex = 7
store.Frame278.Position = UDim2.new(0,18,0.5,-6)
store.Frame278.Size = UDim2.new(0,12,0,12)
store.Frame278.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame278.BackgroundTransparency = 0.5
store.Frame278.BorderSizePixel = 0
store.Frame278.Parent = store.Frame277

store["UICorner251"] = Instance.new("UICorner")
store.UICorner251.Name = "UICorner"
store.UICorner251.CornerRadius = UDim.new(1,0)
store.UICorner251.Parent = store.Frame278

store["TextButton121"] = Instance.new("TextButton")
store.TextButton121.Name = "TextButton"
store.TextButton121.ZIndex = 8
store.TextButton121.Size = UDim2.new(1,0,1,0)
store.TextButton121.BackgroundTransparency = 1
store.TextButton121.Text = ""
store.TextButton121.Parent = store.Frame275

store["PressPop31"] = Instance.new("UIScale")
store.PressPop31.Name = "PressPop"
store.PressPop31.Parent = store.Frame275

store["Frame279"] = Instance.new("Frame")
store.Frame279.Name = "Frame"
store.Frame279.Visible = false
store.Frame279.ZIndex = 4
store.Frame279.LayoutOrder = 21
store.Frame279.Size = UDim2.new(1,0,0,40)
store.Frame279.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame279.BackgroundTransparency = 0.5
store.Frame279.BorderSizePixel = 0
store.Frame279.Parent = store.Page_Settings

store["UICorner252"] = Instance.new("UICorner")
store.UICorner252.Name = "UICorner"
store.UICorner252.CornerRadius = UDim.new(0,10)
store.UICorner252.Parent = store.Frame279

store["UIStroke176"] = Instance.new("UIStroke")
store.UIStroke176.Name = "UIStroke"
store.UIStroke176.Color = Color3.fromRGB(28,28,34)
store.UIStroke176.Parent = store.Frame279

store["TextLabel129"] = Instance.new("TextLabel")
store.TextLabel129.Name = "TextLabel"
store.TextLabel129.ZIndex = 5
store.TextLabel129.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel129.Size = UDim2.new(0.6,0,0,16)
store.TextLabel129.BackgroundTransparency = 1
store.TextLabel129.Text = "AUTO RIGHT"
store.TextLabel129.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel129.TextSize = 11
store.TextLabel129.Font = Enum.Font.GothamBold
store.TextLabel129.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel129.Parent = store.Frame279

store["Frame280"] = Instance.new("Frame")
store.Frame280.Name = "Frame"
store.Frame280.Visible = false
store.Frame280.ZIndex = 5
store.Frame280.Position = UDim2.new(0,12,0.5,7)
store.Frame280.Size = UDim2.new(0,62,0,1)
store.Frame280.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame280.BackgroundTransparency = 0.5
store.Frame280.BorderSizePixel = 0
store.Frame280.Parent = store.Frame279

store["Frame281"] = Instance.new("Frame")
store.Frame281.Name = "Frame"
store.Frame281.ZIndex = 6
store.Frame281.Position = UDim2.new(1,-44,0.5,-8)
store.Frame281.Size = UDim2.new(0,32,0,16)
store.Frame281.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame281.BackgroundTransparency = 0.5
store.Frame281.BorderSizePixel = 0
store.Frame281.Parent = store.Frame279

store["UICorner253"] = Instance.new("UICorner")
store.UICorner253.Name = "UICorner"
store.UICorner253.CornerRadius = UDim.new(1,0)
store.UICorner253.Parent = store.Frame281

store["UIStroke177"] = Instance.new("UIStroke")
store.UIStroke177.Name = "UIStroke"
store.UIStroke177.Color = Color3.fromRGB(255,255,255)
store.UIStroke177.Transparency = 0.4
store.UIStroke177.Parent = store.Frame281

store["Frame282"] = Instance.new("Frame")
store.Frame282.Name = "Frame"
store.Frame282.ZIndex = 7
store.Frame282.Position = UDim2.new(0,18,0.5,-6)
store.Frame282.Size = UDim2.new(0,12,0,12)
store.Frame282.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame282.BackgroundTransparency = 0.5
store.Frame282.BorderSizePixel = 0
store.Frame282.Parent = store.Frame281

store["UICorner254"] = Instance.new("UICorner")
store.UICorner254.Name = "UICorner"
store.UICorner254.CornerRadius = UDim.new(1,0)
store.UICorner254.Parent = store.Frame282

store["TextButton122"] = Instance.new("TextButton")
store.TextButton122.Name = "TextButton"
store.TextButton122.ZIndex = 8
store.TextButton122.Size = UDim2.new(1,0,1,0)
store.TextButton122.BackgroundTransparency = 1
store.TextButton122.Text = ""
store.TextButton122.Parent = store.Frame279

store["PressPop32"] = Instance.new("UIScale")
store.PressPop32.Name = "PressPop"
store.PressPop32.Parent = store.Frame279

store["Frame283"] = Instance.new("Frame")
store.Frame283.Name = "Frame"
store.Frame283.Visible = false
store.Frame283.ZIndex = 4
store.Frame283.LayoutOrder = 22
store.Frame283.Size = UDim2.new(1,0,0,40)
store.Frame283.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame283.BackgroundTransparency = 0.5
store.Frame283.BorderSizePixel = 0
store.Frame283.Parent = store.Page_Settings

store["UICorner255"] = Instance.new("UICorner")
store.UICorner255.Name = "UICorner"
store.UICorner255.CornerRadius = UDim.new(0,10)
store.UICorner255.Parent = store.Frame283

store["UIStroke178"] = Instance.new("UIStroke")
store.UIStroke178.Name = "UIStroke"
store.UIStroke178.Color = Color3.fromRGB(28,28,34)
store.UIStroke178.Parent = store.Frame283

store["TextLabel130"] = Instance.new("TextLabel")
store.TextLabel130.Name = "TextLabel"
store.TextLabel130.ZIndex = 5
store.TextLabel130.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel130.Size = UDim2.new(0.6,0,0,16)
store.TextLabel130.BackgroundTransparency = 1
store.TextLabel130.Text = "CUSTOM SPEED"
store.TextLabel130.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel130.TextSize = 11
store.TextLabel130.Font = Enum.Font.GothamBold
store.TextLabel130.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel130.Parent = store.Frame283

store["Frame284"] = Instance.new("Frame")
store.Frame284.Name = "Frame"
store.Frame284.Visible = false
store.Frame284.ZIndex = 5
store.Frame284.Position = UDim2.new(0,12,0.5,7)
store.Frame284.Size = UDim2.new(0,79,0,1)
store.Frame284.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame284.BackgroundTransparency = 0.5
store.Frame284.BorderSizePixel = 0
store.Frame284.Parent = store.Frame283

store["Frame285"] = Instance.new("Frame")
store.Frame285.Name = "Frame"
store.Frame285.ZIndex = 6
store.Frame285.Position = UDim2.new(1,-44,0.5,-8)
store.Frame285.Size = UDim2.new(0,32,0,16)
store.Frame285.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame285.BackgroundTransparency = 0.5
store.Frame285.BorderSizePixel = 0
store.Frame285.Parent = store.Frame283

store["UICorner256"] = Instance.new("UICorner")
store.UICorner256.Name = "UICorner"
store.UICorner256.CornerRadius = UDim.new(1,0)
store.UICorner256.Parent = store.Frame285

store["UIStroke179"] = Instance.new("UIStroke")
store.UIStroke179.Name = "UIStroke"
store.UIStroke179.Color = Color3.fromRGB(255,255,255)
store.UIStroke179.Transparency = 0.4
store.UIStroke179.Parent = store.Frame285

store["Frame286"] = Instance.new("Frame")
store.Frame286.Name = "Frame"
store.Frame286.ZIndex = 7
store.Frame286.Position = UDim2.new(0,18,0.5,-6)
store.Frame286.Size = UDim2.new(0,12,0,12)
store.Frame286.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame286.BackgroundTransparency = 0.5
store.Frame286.BorderSizePixel = 0
store.Frame286.Parent = store.Frame285

store["UICorner257"] = Instance.new("UICorner")
store.UICorner257.Name = "UICorner"
store.UICorner257.CornerRadius = UDim.new(1,0)
store.UICorner257.Parent = store.Frame286

store["TextButton123"] = Instance.new("TextButton")
store.TextButton123.Name = "TextButton"
store.TextButton123.ZIndex = 8
store.TextButton123.Size = UDim2.new(1,0,1,0)
store.TextButton123.BackgroundTransparency = 1
store.TextButton123.Text = ""
store.TextButton123.Parent = store.Frame283

store["PressPop33"] = Instance.new("UIScale")
store.PressPop33.Name = "PressPop"
store.PressPop33.Parent = store.Frame283

store["Frame287"] = Instance.new("Frame")
store.Frame287.Name = "Frame"
store.Frame287.Visible = false
store.Frame287.ZIndex = 4
store.Frame287.LayoutOrder = 23
store.Frame287.Size = UDim2.new(1,0,0,40)
store.Frame287.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame287.BackgroundTransparency = 0.5
store.Frame287.BorderSizePixel = 0
store.Frame287.Parent = store.Page_Settings

store["UICorner258"] = Instance.new("UICorner")
store.UICorner258.Name = "UICorner"
store.UICorner258.CornerRadius = UDim.new(0,10)
store.UICorner258.Parent = store.Frame287

store["UIStroke180"] = Instance.new("UIStroke")
store.UIStroke180.Name = "UIStroke"
store.UIStroke180.Color = Color3.fromRGB(28,28,34)
store.UIStroke180.Parent = store.Frame287

store["TextLabel131"] = Instance.new("TextLabel")
store.TextLabel131.Name = "TextLabel"
store.TextLabel131.ZIndex = 5
store.TextLabel131.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel131.Size = UDim2.new(0.6,0,0,16)
store.TextLabel131.BackgroundTransparency = 1
store.TextLabel131.Text = "TP DOWN"
store.TextLabel131.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel131.TextSize = 11
store.TextLabel131.Font = Enum.Font.GothamBold
store.TextLabel131.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel131.Parent = store.Frame287

store["Frame288"] = Instance.new("Frame")
store.Frame288.Name = "Frame"
store.Frame288.Visible = false
store.Frame288.ZIndex = 5
store.Frame288.Position = UDim2.new(0,12,0.5,7)
store.Frame288.Size = UDim2.new(0,49,0,1)
store.Frame288.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame288.BackgroundTransparency = 0.5
store.Frame288.BorderSizePixel = 0
store.Frame288.Parent = store.Frame287

store["Frame289"] = Instance.new("Frame")
store.Frame289.Name = "Frame"
store.Frame289.ZIndex = 6
store.Frame289.Position = UDim2.new(1,-44,0.5,-8)
store.Frame289.Size = UDim2.new(0,32,0,16)
store.Frame289.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame289.BackgroundTransparency = 0.5
store.Frame289.BorderSizePixel = 0
store.Frame289.Parent = store.Frame287

store["UICorner259"] = Instance.new("UICorner")
store.UICorner259.Name = "UICorner"
store.UICorner259.CornerRadius = UDim.new(1,0)
store.UICorner259.Parent = store.Frame289

store["UIStroke181"] = Instance.new("UIStroke")
store.UIStroke181.Name = "UIStroke"
store.UIStroke181.Color = Color3.fromRGB(255,255,255)
store.UIStroke181.Transparency = 0.4
store.UIStroke181.Parent = store.Frame289

store["Frame290"] = Instance.new("Frame")
store.Frame290.Name = "Frame"
store.Frame290.ZIndex = 7
store.Frame290.Position = UDim2.new(0,18,0.5,-6)
store.Frame290.Size = UDim2.new(0,12,0,12)
store.Frame290.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame290.BackgroundTransparency = 0.5
store.Frame290.BorderSizePixel = 0
store.Frame290.Parent = store.Frame289

store["UICorner260"] = Instance.new("UICorner")
store.UICorner260.Name = "UICorner"
store.UICorner260.CornerRadius = UDim.new(1,0)
store.UICorner260.Parent = store.Frame290

store["TextButton124"] = Instance.new("TextButton")
store.TextButton124.Name = "TextButton"
store.TextButton124.ZIndex = 8
store.TextButton124.Size = UDim2.new(1,0,1,0)
store.TextButton124.BackgroundTransparency = 1
store.TextButton124.Text = ""
store.TextButton124.Parent = store.Frame287

store["PressPop34"] = Instance.new("UIScale")
store.PressPop34.Name = "PressPop"
store.PressPop34.Parent = store.Frame287

store["Frame291"] = Instance.new("Frame")
store.Frame291.Name = "Frame"
store.Frame291.Visible = false
store.Frame291.ZIndex = 4
store.Frame291.LayoutOrder = 24
store.Frame291.Size = UDim2.new(1,0,0,40)
store.Frame291.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame291.BackgroundTransparency = 0.5
store.Frame291.BorderSizePixel = 0
store.Frame291.Parent = store.Page_Settings

store["UICorner261"] = Instance.new("UICorner")
store.UICorner261.Name = "UICorner"
store.UICorner261.CornerRadius = UDim.new(0,10)
store.UICorner261.Parent = store.Frame291

store["UIStroke182"] = Instance.new("UIStroke")
store.UIStroke182.Name = "UIStroke"
store.UIStroke182.Color = Color3.fromRGB(28,28,34)
store.UIStroke182.Parent = store.Frame291

store["TextLabel132"] = Instance.new("TextLabel")
store.TextLabel132.Name = "TextLabel"
store.TextLabel132.ZIndex = 5
store.TextLabel132.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel132.Size = UDim2.new(0.6,0,0,16)
store.TextLabel132.BackgroundTransparency = 1
store.TextLabel132.Text = "CARRY SPEED"
store.TextLabel132.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel132.TextSize = 11
store.TextLabel132.Font = Enum.Font.GothamBold
store.TextLabel132.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel132.Parent = store.Frame291

store["Frame292"] = Instance.new("Frame")
store.Frame292.Name = "Frame"
store.Frame292.Visible = false
store.Frame292.ZIndex = 5
store.Frame292.Position = UDim2.new(0,12,0.5,7)
store.Frame292.Size = UDim2.new(0,70,0,1)
store.Frame292.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame292.BackgroundTransparency = 0.5
store.Frame292.BorderSizePixel = 0
store.Frame292.Parent = store.Frame291

store["Frame293"] = Instance.new("Frame")
store.Frame293.Name = "Frame"
store.Frame293.ZIndex = 6
store.Frame293.Position = UDim2.new(1,-44,0.5,-8)
store.Frame293.Size = UDim2.new(0,32,0,16)
store.Frame293.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame293.BackgroundTransparency = 0.5
store.Frame293.BorderSizePixel = 0
store.Frame293.Parent = store.Frame291

store["UICorner262"] = Instance.new("UICorner")
store.UICorner262.Name = "UICorner"
store.UICorner262.CornerRadius = UDim.new(1,0)
store.UICorner262.Parent = store.Frame293

store["UIStroke183"] = Instance.new("UIStroke")
store.UIStroke183.Name = "UIStroke"
store.UIStroke183.Color = Color3.fromRGB(255,255,255)
store.UIStroke183.Transparency = 0.4
store.UIStroke183.Parent = store.Frame293

store["Frame294"] = Instance.new("Frame")
store.Frame294.Name = "Frame"
store.Frame294.ZIndex = 7
store.Frame294.Position = UDim2.new(0,18,0.5,-6)
store.Frame294.Size = UDim2.new(0,12,0,12)
store.Frame294.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame294.BackgroundTransparency = 0.5
store.Frame294.BorderSizePixel = 0
store.Frame294.Parent = store.Frame293

store["UICorner263"] = Instance.new("UICorner")
store.UICorner263.Name = "UICorner"
store.UICorner263.CornerRadius = UDim.new(1,0)
store.UICorner263.Parent = store.Frame294

store["TextButton125"] = Instance.new("TextButton")
store.TextButton125.Name = "TextButton"
store.TextButton125.ZIndex = 8
store.TextButton125.Size = UDim2.new(1,0,1,0)
store.TextButton125.BackgroundTransparency = 1
store.TextButton125.Text = ""
store.TextButton125.Parent = store.Frame291

store["PressPop35"] = Instance.new("UIScale")
store.PressPop35.Name = "PressPop"
store.PressPop35.Parent = store.Frame291

store["Frame295"] = Instance.new("Frame")
store.Frame295.Name = "Frame"
store.Frame295.Visible = false
store.Frame295.ZIndex = 4
store.Frame295.LayoutOrder = 25
store.Frame295.Size = UDim2.new(1,0,0,40)
store.Frame295.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame295.BackgroundTransparency = 0.5
store.Frame295.BorderSizePixel = 0
store.Frame295.Parent = store.Page_Settings

store["UICorner264"] = Instance.new("UICorner")
store.UICorner264.Name = "UICorner"
store.UICorner264.CornerRadius = UDim.new(0,10)
store.UICorner264.Parent = store.Frame295

store["UIStroke184"] = Instance.new("UIStroke")
store.UIStroke184.Name = "UIStroke"
store.UIStroke184.Color = Color3.fromRGB(28,28,34)
store.UIStroke184.Parent = store.Frame295

store["TextLabel133"] = Instance.new("TextLabel")
store.TextLabel133.Name = "TextLabel"
store.TextLabel133.ZIndex = 5
store.TextLabel133.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel133.Size = UDim2.new(0.6,0,0,16)
store.TextLabel133.BackgroundTransparency = 1
store.TextLabel133.Text = "CUSTOM CARRY"
store.TextLabel133.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel133.TextSize = 11
store.TextLabel133.Font = Enum.Font.GothamBold
store.TextLabel133.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel133.Parent = store.Frame295

store["Frame296"] = Instance.new("Frame")
store.Frame296.Name = "Frame"
store.Frame296.Visible = false
store.Frame296.ZIndex = 5
store.Frame296.Position = UDim2.new(0,12,0.5,7)
store.Frame296.Size = UDim2.new(0,79,0,1)
store.Frame296.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame296.BackgroundTransparency = 0.5
store.Frame296.BorderSizePixel = 0
store.Frame296.Parent = store.Frame295

store["Frame297"] = Instance.new("Frame")
store.Frame297.Name = "Frame"
store.Frame297.ZIndex = 6
store.Frame297.Position = UDim2.new(1,-44,0.5,-8)
store.Frame297.Size = UDim2.new(0,32,0,16)
store.Frame297.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame297.BackgroundTransparency = 0.5
store.Frame297.BorderSizePixel = 0
store.Frame297.Parent = store.Frame295

store["UICorner265"] = Instance.new("UICorner")
store.UICorner265.Name = "UICorner"
store.UICorner265.CornerRadius = UDim.new(1,0)
store.UICorner265.Parent = store.Frame297

store["UIStroke185"] = Instance.new("UIStroke")
store.UIStroke185.Name = "UIStroke"
store.UIStroke185.Color = Color3.fromRGB(255,255,255)
store.UIStroke185.Transparency = 0.4
store.UIStroke185.Parent = store.Frame297

store["Frame298"] = Instance.new("Frame")
store.Frame298.Name = "Frame"
store.Frame298.ZIndex = 7
store.Frame298.Position = UDim2.new(0,18,0.5,-6)
store.Frame298.Size = UDim2.new(0,12,0,12)
store.Frame298.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame298.BackgroundTransparency = 0.5
store.Frame298.BorderSizePixel = 0
store.Frame298.Parent = store.Frame297

store["UICorner266"] = Instance.new("UICorner")
store.UICorner266.Name = "UICorner"
store.UICorner266.CornerRadius = UDim.new(1,0)
store.UICorner266.Parent = store.Frame298

store["TextButton126"] = Instance.new("TextButton")
store.TextButton126.Name = "TextButton"
store.TextButton126.ZIndex = 8
store.TextButton126.Size = UDim2.new(1,0,1,0)
store.TextButton126.BackgroundTransparency = 1
store.TextButton126.Text = ""
store.TextButton126.Parent = store.Frame295

store["PressPop36"] = Instance.new("UIScale")
store.PressPop36.Name = "PressPop"
store.PressPop36.Parent = store.Frame295

store["Frame299"] = Instance.new("Frame")
store.Frame299.Name = "Frame"
store.Frame299.Visible = false
store.Frame299.ZIndex = 4
store.Frame299.LayoutOrder = 26
store.Frame299.Size = UDim2.new(1,0,0,40)
store.Frame299.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame299.BackgroundTransparency = 0.5
store.Frame299.BorderSizePixel = 0
store.Frame299.Parent = store.Page_Settings

store["UICorner267"] = Instance.new("UICorner")
store.UICorner267.Name = "UICorner"
store.UICorner267.CornerRadius = UDim.new(0,10)
store.UICorner267.Parent = store.Frame299

store["UIStroke186"] = Instance.new("UIStroke")
store.UIStroke186.Name = "UIStroke"
store.UIStroke186.Color = Color3.fromRGB(28,28,34)
store.UIStroke186.Parent = store.Frame299

store["TextLabel134"] = Instance.new("TextLabel")
store.TextLabel134.Name = "TextLabel"
store.TextLabel134.ZIndex = 5
store.TextLabel134.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel134.Size = UDim2.new(0.6,0,0,16)
store.TextLabel134.BackgroundTransparency = 1
store.TextLabel134.Text = "LAGGER CARRY"
store.TextLabel134.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel134.TextSize = 11
store.TextLabel134.Font = Enum.Font.GothamBold
store.TextLabel134.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel134.Parent = store.Frame299

store["Frame300"] = Instance.new("Frame")
store.Frame300.Name = "Frame"
store.Frame300.Visible = false
store.Frame300.ZIndex = 5
store.Frame300.Position = UDim2.new(0,12,0.5,7)
store.Frame300.Size = UDim2.new(0,77,0,1)
store.Frame300.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame300.BackgroundTransparency = 0.5
store.Frame300.BorderSizePixel = 0
store.Frame300.Parent = store.Frame299

store["Frame301"] = Instance.new("Frame")
store.Frame301.Name = "Frame"
store.Frame301.ZIndex = 6
store.Frame301.Position = UDim2.new(1,-44,0.5,-8)
store.Frame301.Size = UDim2.new(0,32,0,16)
store.Frame301.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame301.BackgroundTransparency = 0.5
store.Frame301.BorderSizePixel = 0
store.Frame301.Parent = store.Frame299

store["UICorner268"] = Instance.new("UICorner")
store.UICorner268.Name = "UICorner"
store.UICorner268.CornerRadius = UDim.new(1,0)
store.UICorner268.Parent = store.Frame301

store["UIStroke187"] = Instance.new("UIStroke")
store.UIStroke187.Name = "UIStroke"
store.UIStroke187.Color = Color3.fromRGB(255,255,255)
store.UIStroke187.Transparency = 0.4
store.UIStroke187.Parent = store.Frame301

store["Frame302"] = Instance.new("Frame")
store.Frame302.Name = "Frame"
store.Frame302.ZIndex = 7
store.Frame302.Position = UDim2.new(0,18,0.5,-6)
store.Frame302.Size = UDim2.new(0,12,0,12)
store.Frame302.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame302.BackgroundTransparency = 0.5
store.Frame302.BorderSizePixel = 0
store.Frame302.Parent = store.Frame301

store["UICorner269"] = Instance.new("UICorner")
store.UICorner269.Name = "UICorner"
store.UICorner269.CornerRadius = UDim.new(1,0)
store.UICorner269.Parent = store.Frame302

store["TextButton127"] = Instance.new("TextButton")
store.TextButton127.Name = "TextButton"
store.TextButton127.ZIndex = 8
store.TextButton127.Size = UDim2.new(1,0,1,0)
store.TextButton127.BackgroundTransparency = 1
store.TextButton127.Text = ""
store.TextButton127.Parent = store.Frame299

store["PressPop37"] = Instance.new("UIScale")
store.PressPop37.Name = "PressPop"
store.PressPop37.Parent = store.Frame299

store["Frame303"] = Instance.new("Frame")
store.Frame303.Name = "Frame"
store.Frame303.Visible = false
store.Frame303.ZIndex = 4
store.Frame303.LayoutOrder = 27
store.Frame303.Size = UDim2.new(1,0,0,40)
store.Frame303.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame303.BackgroundTransparency = 0.5
store.Frame303.BorderSizePixel = 0
store.Frame303.Parent = store.Page_Settings

store["UICorner270"] = Instance.new("UICorner")
store.UICorner270.Name = "UICorner"
store.UICorner270.CornerRadius = UDim.new(0,10)
store.UICorner270.Parent = store.Frame303

store["UIStroke188"] = Instance.new("UIStroke")
store.UIStroke188.Name = "UIStroke"
store.UIStroke188.Color = Color3.fromRGB(28,28,34)
store.UIStroke188.Parent = store.Frame303

store["TextLabel135"] = Instance.new("TextLabel")
store.TextLabel135.Name = "TextLabel"
store.TextLabel135.ZIndex = 5
store.TextLabel135.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel135.Size = UDim2.new(0.6,0,0,16)
store.TextLabel135.BackgroundTransparency = 1
store.TextLabel135.Text = "LAGGER SPEED"
store.TextLabel135.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel135.TextSize = 11
store.TextLabel135.Font = Enum.Font.GothamBold
store.TextLabel135.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel135.Parent = store.Frame303

store["Frame304"] = Instance.new("Frame")
store.Frame304.Name = "Frame"
store.Frame304.Visible = false
store.Frame304.ZIndex = 5
store.Frame304.Position = UDim2.new(0,12,0.5,7)
store.Frame304.Size = UDim2.new(0,77,0,1)
store.Frame304.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame304.BackgroundTransparency = 0.5
store.Frame304.BorderSizePixel = 0
store.Frame304.Parent = store.Frame303

store["Frame305"] = Instance.new("Frame")
store.Frame305.Name = "Frame"
store.Frame305.ZIndex = 6
store.Frame305.Position = UDim2.new(1,-44,0.5,-8)
store.Frame305.Size = UDim2.new(0,32,0,16)
store.Frame305.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame305.BackgroundTransparency = 0.5
store.Frame305.BorderSizePixel = 0
store.Frame305.Parent = store.Frame303

store["UICorner271"] = Instance.new("UICorner")
store.UICorner271.Name = "UICorner"
store.UICorner271.CornerRadius = UDim.new(1,0)
store.UICorner271.Parent = store.Frame305

store["UIStroke189"] = Instance.new("UIStroke")
store.UIStroke189.Name = "UIStroke"
store.UIStroke189.Color = Color3.fromRGB(255,255,255)
store.UIStroke189.Transparency = 0.4
store.UIStroke189.Parent = store.Frame305

store["Frame306"] = Instance.new("Frame")
store.Frame306.Name = "Frame"
store.Frame306.ZIndex = 7
store.Frame306.Position = UDim2.new(0,18,0.5,-6)
store.Frame306.Size = UDim2.new(0,12,0,12)
store.Frame306.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame306.BackgroundTransparency = 0.5
store.Frame306.BorderSizePixel = 0
store.Frame306.Parent = store.Frame305

store["UICorner272"] = Instance.new("UICorner")
store.UICorner272.Name = "UICorner"
store.UICorner272.CornerRadius = UDim.new(1,0)
store.UICorner272.Parent = store.Frame306

store["TextButton128"] = Instance.new("TextButton")
store.TextButton128.Name = "TextButton"
store.TextButton128.ZIndex = 8
store.TextButton128.Size = UDim2.new(1,0,1,0)
store.TextButton128.BackgroundTransparency = 1
store.TextButton128.Text = ""
store.TextButton128.Parent = store.Frame303

store["PressPop38"] = Instance.new("UIScale")
store.PressPop38.Name = "PressPop"
store.PressPop38.Parent = store.Frame303

store["UIScale"] = Instance.new("UIScale")
store.UIScale.Name = "UIScale"
store.UIScale.Scale = 0.8
store.UIScale.Parent = store.Outer

-- Mobile Buttons
store["VezyMobileButtons"] = Instance.new("Frame")
store.VezyMobileButtons.Name = "VezyMobileButtons"
store.VezyMobileButtons.Active = true
store.VezyMobileButtons.ZIndex = 100
store.VezyMobileButtons.Position = UDim2.new(1,-220,0.5,-118)
store.VezyMobileButtons.Size = UDim2.new(0,202,0,236)
store.VezyMobileButtons.BackgroundTransparency = 1
store.VezyMobileButtons.Parent = store.KrixHubGUI

store["MB_tpBat"] = Instance.new("TextButton")
store.MB_tpBat.Name = "MB_tpBat"
store.MB_tpBat.ZIndex = 101
store.MB_tpBat.Position = UDim2.new(1,-220,0.5,-118)
store.MB_tpBat.Size = UDim2.new(0,64,0,55)
store.MB_tpBat.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_tpBat.BorderSizePixel = 0
store.MB_tpBat.Text = "TP BAT"
store.MB_tpBat.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_tpBat.TextSize = 10
store.MB_tpBat.Font = Enum.Font.GothamBlack
store.MB_tpBat.TextWrapped = true
store.MB_tpBat.AutoButtonColor = false
store.MB_tpBat.Parent = store.KrixHubGUI

store["UICorner274"] = Instance.new("UICorner")
store.UICorner274.Name = "UICorner"
store.UICorner274.CornerRadius = UDim.new(0,16)
store.UICorner274.Parent = store.MB_tpBat

store["UIStroke191"] = Instance.new("UIStroke")
store.UIStroke191.Name = "UIStroke"
store.UIStroke191.Color = Color3.fromRGB(254,254,254)
store.UIStroke191.Thickness = 3.5
store.UIStroke191.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke191.Transparency = 1
store.UIStroke191.Parent = store.MB_tpBat

store["UIGradient61"] = Instance.new("UIGradient")
store.UIGradient61.Name = "UIGradient"
store.UIGradient61.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient61.Parent = store.UIStroke191

store["MB_drop"] = Instance.new("TextButton")
store.MB_drop.Name = "MB_drop"
store.MB_drop.ZIndex = 101
store.MB_drop.Position = UDim2.new(1,-150,0.5,-118)
store.MB_drop.Size = UDim2.new(0,64,0,55)
store.MB_drop.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_drop.BorderSizePixel = 0
store.MB_drop.Text = "DROP"
store.MB_drop.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_drop.TextSize = 10
store.MB_drop.Font = Enum.Font.GothamBlack
store.MB_drop.TextWrapped = true
store.MB_drop.AutoButtonColor = false
store.MB_drop.Parent = store.KrixHubGUI

store["UICorner275"] = Instance.new("UICorner")
store.UICorner275.Name = "UICorner"
store.UICorner275.CornerRadius = UDim.new(0,16)
store.UICorner275.Parent = store.MB_drop

store["UIStroke192"] = Instance.new("UIStroke")
store.UIStroke192.Name = "UIStroke"
store.UIStroke192.Color = Color3.fromRGB(254,254,254)
store.UIStroke192.Thickness = 3.5
store.UIStroke192.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke192.Transparency = 1
store.UIStroke192.Parent = store.MB_drop

store["UIGradient62"] = Instance.new("UIGradient")
store.UIGradient62.Name = "UIGradient"
store.UIGradient62.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient62.Parent = store.UIStroke192

store["MB_autoLeft"] = Instance.new("TextButton")
store.MB_autoLeft.Name = "MB_autoLeft"
store.MB_autoLeft.ZIndex = 101
store.MB_autoLeft.Position = UDim2.new(1,-80,0.5,-118)
store.MB_autoLeft.Size = UDim2.new(0,64,0,55)
store.MB_autoLeft.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_autoLeft.BorderSizePixel = 0
store.MB_autoLeft.Text = "AUTO LEFT"
store.MB_autoLeft.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_autoLeft.TextSize = 10
store.MB_autoLeft.Font = Enum.Font.GothamBlack
store.MB_autoLeft.TextWrapped = true
store.MB_autoLeft.AutoButtonColor = false
store.MB_autoLeft.Parent = store.KrixHubGUI

store["UICorner276"] = Instance.new("UICorner")
store.UICorner276.Name = "UICorner"
store.UICorner276.CornerRadius = UDim.new(0,16)
store.UICorner276.Parent = store.MB_autoLeft

store["UIStroke193"] = Instance.new("UIStroke")
store.UIStroke193.Name = "UIStroke"
store.UIStroke193.Color = Color3.fromRGB(254,254,254)
store.UIStroke193.Thickness = 3.5
store.UIStroke193.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke193.Transparency = 1
store.UIStroke193.Parent = store.MB_autoLeft

store["UIGradient63"] = Instance.new("UIGradient")
store.UIGradient63.Name = "UIGradient"
store.UIGradient63.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient63.Parent = store.UIStroke193

store["MB_reset"] = Instance.new("TextButton")
store.MB_reset.Name = "MB_reset"
store.MB_reset.ZIndex = 101
store.MB_reset.Position = UDim2.new(1,-220,0.5,-57)
store.MB_reset.Size = UDim2.new(0,64,0,55)
store.MB_reset.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_reset.BorderSizePixel = 0
store.MB_reset.Text = "INSTA RESET"
store.MB_reset.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_reset.TextSize = 10
store.MB_reset.Font = Enum.Font.GothamBlack
store.MB_reset.TextWrapped = true
store.MB_reset.AutoButtonColor = false
store.MB_reset.Parent = store.KrixHubGUI

store["UICorner277"] = Instance.new("UICorner")
store.UICorner277.Name = "UICorner"
store.UICorner277.CornerRadius = UDim.new(0,16)
store.UICorner277.Parent = store.MB_reset

store["UIStroke194"] = Instance.new("UIStroke")
store.UIStroke194.Name = "UIStroke"
store.UIStroke194.Color = Color3.fromRGB(254,254,254)
store.UIStroke194.Thickness = 3.5
store.UIStroke194.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke194.Transparency = 1
store.UIStroke194.Parent = store.MB_reset

store["UIGradient64"] = Instance.new("UIGradient")
store.UIGradient64.Name = "UIGradient"
store.UIGradient64.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient64.Parent = store.UIStroke194

store["MB_batLock"] = Instance.new("TextButton")
store.MB_batLock.Name = "MB_batLock"
store.MB_batLock.ZIndex = 101
store.MB_batLock.Position = UDim2.new(1,-150,0.5,-57)
store.MB_batLock.Size = UDim2.new(0,64,0,55)
store.MB_batLock.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_batLock.BorderSizePixel = 0
store.MB_batLock.Text = "AIMBOT"
store.MB_batLock.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_batLock.TextSize = 10
store.MB_batLock.Font = Enum.Font.GothamBlack
store.MB_batLock.TextWrapped = true
store.MB_batLock.AutoButtonColor = false
store.MB_batLock.Parent = store.KrixHubGUI

store["UICorner278"] = Instance.new("UICorner")
store.UICorner278.Name = "UICorner"
store.UICorner278.CornerRadius = UDim.new(0,16)
store.UICorner278.Parent = store.MB_batLock

store["UIStroke195"] = Instance.new("UIStroke")
store.UIStroke195.Name = "UIStroke"
store.UIStroke195.Color = Color3.fromRGB(254,254,254)
store.UIStroke195.Thickness = 3.5
store.UIStroke195.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke195.Transparency = 1
store.UIStroke195.Parent = store.MB_batLock

store["UIGradient65"] = Instance.new("UIGradient")
store.UIGradient65.Name = "UIGradient"
store.UIGradient65.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient65.Parent = store.UIStroke195

store["MB_autoRight"] = Instance.new("TextButton")
store.MB_autoRight.Name = "MB_autoRight"
store.MB_autoRight.ZIndex = 101
store.MB_autoRight.Position = UDim2.new(1,-80,0.5,-57)
store.MB_autoRight.Size = UDim2.new(0,64,0,55)
store.MB_autoRight.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_autoRight.BorderSizePixel = 0
store.MB_autoRight.Text = "AUTO RIGHT"
store.MB_autoRight.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_autoRight.TextSize = 10
store.MB_autoRight.Font = Enum.Font.GothamBlack
store.MB_autoRight.TextWrapped = true
store.MB_autoRight.AutoButtonColor = false
store.MB_autoRight.Parent = store.KrixHubGUI

store["UICorner279"] = Instance.new("UICorner")
store.UICorner279.Name = "UICorner"
store.UICorner279.CornerRadius = UDim.new(0,16)
store.UICorner279.Parent = store.MB_autoRight

store["UIStroke196"] = Instance.new("UIStroke")
store.UIStroke196.Name = "UIStroke"
store.UIStroke196.Color = Color3.fromRGB(254,254,254)
store.UIStroke196.Thickness = 3.5
store.UIStroke196.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke196.Transparency = 1
store.UIStroke196.Parent = store.MB_autoRight

store["UIGradient66"] = Instance.new("UIGradient")
store.UIGradient66.Name = "UIGradient"
store.UIGradient66.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient66.Parent = store.UIStroke196

store["MB_customSpeed"] = Instance.new("TextButton")
store.MB_customSpeed.Name = "MB_customSpeed"
store.MB_customSpeed.ZIndex = 101
store.MB_customSpeed.Position = UDim2.new(1,-220,0.5,4)
store.MB_customSpeed.Size = UDim2.new(0,64,0,55)
store.MB_customSpeed.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_customSpeed.BorderSizePixel = 0
store.MB_customSpeed.Text = "CUSTOM SPEED"
store.MB_customSpeed.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_customSpeed.TextSize = 10
store.MB_customSpeed.Font = Enum.Font.GothamBlack
store.MB_customSpeed.TextWrapped = true
store.MB_customSpeed.AutoButtonColor = false
store.MB_customSpeed.Parent = store.KrixHubGUI

store["UICorner280"] = Instance.new("UICorner")
store.UICorner280.Name = "UICorner"
store.UICorner280.CornerRadius = UDim.new(0,16)
store.UICorner280.Parent = store.MB_customSpeed

store["UIStroke197"] = Instance.new("UIStroke")
store.UIStroke197.Name = "UIStroke"
store.UIStroke197.Color = Color3.fromRGB(254,254,254)
store.UIStroke197.Thickness = 3.5
store.UIStroke197.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke197.Transparency = 1
store.UIStroke197.Parent = store.MB_customSpeed

store["UIGradient67"] = Instance.new("UIGradient")
store.UIGradient67.Name = "UIGradient"
store.UIGradient67.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient67.Parent = store.UIStroke197

store["MB_tpDown"] = Instance.new("TextButton")
store.MB_tpDown.Name = "MB_tpDown"
store.MB_tpDown.ZIndex = 101
store.MB_tpDown.Position = UDim2.new(1,-150,0.5,4)
store.MB_tpDown.Size = UDim2.new(0,64,0,55)
store.MB_tpDown.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_tpDown.BorderSizePixel = 0
store.MB_tpDown.Text = "TP DOWN"
store.MB_tpDown.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_tpDown.TextSize = 10
store.MB_tpDown.Font = Enum.Font.GothamBlack
store.MB_tpDown.TextWrapped = true
store.MB_tpDown.AutoButtonColor = false
store.MB_tpDown.Parent = store.KrixHubGUI

store["UICorner281"] = Instance.new("UICorner")
store.UICorner281.Name = "UICorner"
store.UICorner281.CornerRadius = UDim.new(0,16)
store.UICorner281.Parent = store.MB_tpDown

store["UIStroke198"] = Instance.new("UIStroke")
store.UIStroke198.Name = "UIStroke"
store.UIStroke198.Color = Color3.fromRGB(254,254,254)
store.UIStroke198.Thickness = 3.5
store.UIStroke198.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke198.Transparency = 1
store.UIStroke198.Parent = store.MB_tpDown

store["UIGradient68"] = Instance.new("UIGradient")
store.UIGradient68.Name = "UIGradient"
store.UIGradient68.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient68.Parent = store.UIStroke198

store["MB_carry"] = Instance.new("TextButton")
store.MB_carry.Name = "MB_carry"
store.MB_carry.ZIndex = 101
store.MB_carry.Position = UDim2.new(1,-80,0.5,4)
store.MB_carry.Size = UDim2.new(0,64,0,55)
store.MB_carry.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_carry.BorderSizePixel = 0
store.MB_carry.Text = "CARRY SPEED"
store.MB_carry.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_carry.TextSize = 10
store.MB_carry.Font = Enum.Font.GothamBlack
store.MB_carry.TextWrapped = true
store.MB_carry.AutoButtonColor = false
store.MB_carry.Parent = store.KrixHubGUI

store["UICorner282"] = Instance.new("UICorner")
store.UICorner282.Name = "UICorner"
store.UICorner282.CornerRadius = UDim.new(0,16)
store.UICorner282.Parent = store.MB_carry

store["UIStroke199"] = Instance.new("UIStroke")
store.UIStroke199.Name = "UIStroke"
store.UIStroke199.Color = Color3.fromRGB(254,254,254)
store.UIStroke199.Thickness = 3.5
store.UIStroke199.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke199.Transparency = 1
store.UIStroke199.Parent = store.MB_carry

store["UIGradient69"] = Instance.new("UIGradient")
store.UIGradient69.Name = "UIGradient"
store.UIGradient69.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient69.Parent = store.UIStroke199

store["MB_customCarry"] = Instance.new("TextButton")
store.MB_customCarry.Name = "MB_customCarry"
store.MB_customCarry.ZIndex = 101
store.MB_customCarry.Position = UDim2.new(1,-220,0.5,65)
store.MB_customCarry.Size = UDim2.new(0,64,0,55)
store.MB_customCarry.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_customCarry.BorderSizePixel = 0
store.MB_customCarry.Text = "CUSTOM CARRY"
store.MB_customCarry.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_customCarry.TextSize = 10
store.MB_customCarry.Font = Enum.Font.GothamBlack
store.MB_customCarry.TextWrapped = true
store.MB_customCarry.AutoButtonColor = false
store.MB_customCarry.Parent = store.KrixHubGUI

store["UICorner283"] = Instance.new("UICorner")
store.UICorner283.Name = "UICorner"
store.UICorner283.CornerRadius = UDim.new(0,16)
store.UICorner283.Parent = store.MB_customCarry

store["UIStroke200"] = Instance.new("UIStroke")
store.UIStroke200.Name = "UIStroke"
store.UIStroke200.Color = Color3.fromRGB(254,254,254)
store.UIStroke200.Thickness = 3.5
store.UIStroke200.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke200.Transparency = 1
store.UIStroke200.Parent = store.MB_customCarry

store["UIGradient70"] = Instance.new("UIGradient")
store.UIGradient70.Name = "UIGradient"
store.UIGradient70.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient70.Parent = store.UIStroke200

store["MB_laggerCarry"] = Instance.new("TextButton")
store.MB_laggerCarry.Name = "MB_laggerCarry"
store.MB_laggerCarry.ZIndex = 101
store.MB_laggerCarry.Position = UDim2.new(1,-150,0.5,65)
store.MB_laggerCarry.Size = UDim2.new(0,64,0,55)
store.MB_laggerCarry.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_laggerCarry.BorderSizePixel = 0
store.MB_laggerCarry.Text = "LAGGER CARRY"
store.MB_laggerCarry.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_laggerCarry.TextSize = 10
store.MB_laggerCarry.Font = Enum.Font.GothamBlack
store.MB_laggerCarry.TextWrapped = true
store.MB_laggerCarry.AutoButtonColor = false
store.MB_laggerCarry.Parent = store.KrixHubGUI

store["UICorner284"] = Instance.new("UICorner")
store.UICorner284.Name = "UICorner"
store.UICorner284.CornerRadius = UDim.new(0,16)
store.UICorner284.Parent = store.MB_laggerCarry

store["UIStroke201"] = Instance.new("UIStroke")
store.UIStroke201.Name = "UIStroke"
store.UIStroke201.Color = Color3.fromRGB(254,254,254)
store.UIStroke201.Thickness = 3.5
store.UIStroke201.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke201.Transparency = 1
store.UIStroke201.Parent = store.MB_laggerCarry

store["UIGradient71"] = Instance.new("UIGradient")
store.UIGradient71.Name = "UIGradient"
store.UIGradient71.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient71.Parent = store.UIStroke201

store["MB_laggerSpeed"] = Instance.new("TextButton")
store.MB_laggerSpeed.Name = "MB_laggerSpeed"
store.MB_laggerSpeed.ZIndex = 101
store.MB_laggerSpeed.Position = UDim2.new(1,-80,0.5,65)
store.MB_laggerSpeed.Size = UDim2.new(0,64,0,55)
store.MB_laggerSpeed.BackgroundColor3 = Color3.fromRGB(8,8,10)
store.MB_laggerSpeed.BorderSizePixel = 0
store.MB_laggerSpeed.Text = "LAGGER SPEED"
store.MB_laggerSpeed.TextColor3 = Color3.fromRGB(255,255,255)
store.MB_laggerSpeed.TextSize = 10
store.MB_laggerSpeed.Font = Enum.Font.GothamBlack
store.MB_laggerSpeed.TextWrapped = true
store.MB_laggerSpeed.AutoButtonColor = false
store.MB_laggerSpeed.Parent = store.KrixHubGUI

store["UICorner285"] = Instance.new("UICorner")
store.UICorner285.Name = "UICorner"
store.UICorner285.CornerRadius = UDim.new(0,16)
store.UICorner285.Parent = store.MB_laggerSpeed

store["UIStroke202"] = Instance.new("UIStroke")
store.UIStroke202.Name = "UIStroke"
store.UIStroke202.Color = Color3.fromRGB(254,254,254)
store.UIStroke202.Thickness = 3.5
store.UIStroke202.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke202.Transparency = 1
store.UIStroke202.Parent = store.MB_laggerSpeed

store["UIGradient72"] = Instance.new("UIGradient")
store.UIGradient72.Name = "UIGradient"
store.UIGradient72.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient72.Parent = store.UIStroke202

-- Steal Bar
store["StealBar"] = Instance.new("Frame")
store.StealBar.Name = "StealBar"
store.StealBar.Active = true
store.StealBar.ZIndex = 50
store.StealBar.AnchorPoint = Vector2.new(0.5,1)
store.StealBar.Position = UDim2.new(0.5,2,1,-41)
store.StealBar.Size = UDim2.new(0,324,0,58)
store.StealBar.BackgroundColor3 = Color3.fromRGB(12,12,14)
store.StealBar.BorderSizePixel = 0
store.StealBar.Parent = store.KrixHubGUI

store["UICorner286"] = Instance.new("UICorner")
store.UICorner286.Name = "UICorner"
store.UICorner286.CornerRadius = UDim.new(0,16)
store.UICorner286.Parent = store.StealBar

store["UIGradient73"] = Instance.new("UIGradient")
store.UIGradient73.Name = "UIGradient"
store.UIGradient73.Color = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(110,110,118))
store.UIGradient73.Rotation = 90
store.UIGradient73.Parent = store.StealBar

store["UIStroke203"] = Instance.new("UIStroke")
store.UIStroke203.Name = "UIStroke"
store.UIStroke203.Color = Color3.fromRGB(254,254,254)
store.UIStroke203.Thickness = 2.4
store.UIStroke203.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke203.Transparency = 0.25
store.UIStroke203.Parent = store.StealBar

store["UIGradient74"] = Instance.new("UIGradient")
store.UIGradient74.Name = "UIGradient"
store.UIGradient74.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient74.Parent = store.UIStroke203

store["Edge"] = Instance.new("Frame")
store.Edge.Name = "Edge"
store.Edge.ZIndex = 49
store.Edge.Position = UDim2.new(0,-4,0,-4)
store.Edge.Size = UDim2.new(1,8,1,8)
store.Edge.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Edge.BorderSizePixel = 0
store.Edge.Parent = store.StealBar

store["UICorner287"] = Instance.new("UICorner")
store.UICorner287.Name = "UICorner"
store.UICorner287.CornerRadius = UDim.new(0,20)
store.UICorner287.Parent = store.Edge

store["UIScale2"] = Instance.new("UIScale")
store.UIScale2.Name = "UIScale"
store.UIScale2.Scale = 0.8
store.UIScale2.Parent = store.StealBar

store["StealPercent"] = Instance.new("TextLabel")
store.StealPercent.Name = "StealPercent"
store.StealPercent.ZIndex = 54
store.StealPercent.Position = UDim2.new(0,11,0,2)
store.StealPercent.Size = UDim2.new(0,90,0,18)
store.StealPercent.BackgroundTransparency = 1
store.StealPercent.Text = "0%"
store.StealPercent.TextColor3 = Color3.fromRGB(255,255,255)
store.StealPercent.TextSize = 17
store.StealPercent.Font = Enum.Font.GothamBlack
store.StealPercent.TextXAlignment = Enum.TextXAlignment.Left
store.StealPercent.Parent = store.StealBar

store["StealFps"] = Instance.new("TextLabel")
store.StealFps.Name = "StealFps"
store.StealFps.ZIndex = 54
store.StealFps.Position = UDim2.new(0,11,0,21)
store.StealFps.Size = UDim2.new(0,90,0,13)
store.StealFps.BackgroundTransparency = 1
store.StealFps.Text = "FPS: 60"
store.StealFps.TextColor3 = Color3.fromRGB(190,190,198)
store.StealFps.TextSize = 11
store.StealFps.Font = Enum.Font.GothamBold
store.StealFps.TextXAlignment = Enum.TextXAlignment.Left
store.StealFps.Parent = store.StealBar

store["StealModeInfo"] = Instance.new("TextLabel")
store.StealModeInfo.Name = "StealModeInfo"
store.StealModeInfo.ZIndex = 54
store.StealModeInfo.Position = UDim2.new(0.5,-80,0,21)
store.StealModeInfo.Size = UDim2.new(0,160,0,13)
store.StealModeInfo.BackgroundTransparency = 1
store.StealModeInfo.Text = "NORMAL 62 RADIUS"
store.StealModeInfo.TextColor3 = Color3.fromRGB(190,190,198)
store.StealModeInfo.TextSize = 11
store.StealModeInfo.Font = Enum.Font.GothamBold
store.StealModeInfo.Parent = store.StealBar

store["StealPing"] = Instance.new("TextLabel")
store.StealPing.Name = "StealPing"
store.StealPing.ZIndex = 54
store.StealPing.Position = UDim2.new(1,-101,0,21)
store.StealPing.Size = UDim2.new(0,90,0,13)
store.StealPing.BackgroundTransparency = 1
store.StealPing.Text = "PING: 160ms"
store.StealPing.TextColor3 = Color3.fromRGB(190,190,198)
store.StealPing.TextSize = 11
store.StealPing.Font = Enum.Font.GothamBold
store.StealPing.TextXAlignment = Enum.TextXAlignment.Right
store.StealPing.Parent = store.StealBar

store["StealBarTrack"] = Instance.new("Frame")
store.StealBarTrack.Name = "StealBarTrack"
store.StealBarTrack.ZIndex = 51
store.StealBarTrack.ClipsDescendants = true
store.StealBarTrack.Position = UDim2.new(0,9,1,-22)
store.StealBarTrack.Size = UDim2.new(1,-18,0,16)
store.StealBarTrack.BackgroundColor3 = Color3.fromRGB(22,22,26)
store.StealBarTrack.BorderSizePixel = 0
store.StealBarTrack.Parent = store.StealBar

store["UICorner288"] = Instance.new("UICorner")
store.UICorner288.Name = "UICorner"
store.UICorner288.CornerRadius = UDim.new(1,0)
store.UICorner288.Parent = store.StealBarTrack

store["Fill"] = Instance.new("Frame")
store.Fill.Name = "Fill"
store.Fill.ZIndex = 52
store.Fill.Size = UDim2.new(0,0,1,0)
store.Fill.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Fill.BorderSizePixel = 0
store.Fill.Parent = store.StealBarTrack

store["UICorner289"] = Instance.new("UICorner")
store.UICorner289.Name = "UICorner"
store.UICorner289.CornerRadius = UDim.new(1,0)
store.UICorner289.Parent = store.Fill

store["UIGradient75"] = Instance.new("UIGradient")
store.UIGradient75.Name = "UIGradient"
store.UIGradient75.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(150,150,150)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(150,150,150))})
store.UIGradient75.Parent = store.Fill

-- ======================
-- UI LOGIC & SETUP
-- ======================

local UIS = game:GetService("UserInputService")

local gui = store.KrixHubGUI
local outer = store.Outer
local inner = store.Inner
local scroll = store.ScrollingFrame
local tabBar = store.BottomTabBar

if outer then
	outer.Position = UDim2.new(0.5, -165, 0.5, -235)
	outer.Size = UDim2.new(0, 330, 0, 470)
	outer.Active = true
end
if inner then
	inner.BackgroundTransparency = 1
	inner.ClipsDescendants = true
end
if store.BgGradient then
	store.BgGradient.BackgroundTransparency = 0
end

if scroll then
	scroll.Position = UDim2.new(0, 0, 0, 64)
	scroll.Size = UDim2.new(1, 0, 1, -110)
	scroll.ScrollBarThickness = 3
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	if not scroll:FindFirstChildOfClass("UIListLayout") then
		local lay = Instance.new("UIListLayout")
		lay.SortOrder = Enum.SortOrder.LayoutOrder
		lay.Padding = UDim.new(0, 6)
		lay.Parent = scroll
	end
	if not scroll:FindFirstChildOfClass("UIPadding") then
		local pad = Instance.new("UIPadding")
		pad.PaddingTop = UDim.new(0, 8)
		pad.PaddingBottom = UDim.new(0, 12)
		pad.PaddingLeft = UDim.new(0, 10)
		pad.PaddingRight = UDim.new(0, 10)
		pad.Parent = scroll
	end
end

local pageMap = {
	Speed = store.Page_Speed,
	Steal = store.Page_Steal,
	Movement = store.Page_Movement,
	Visual = store.Page_Visual,
	Auto = store.Page_Auto,
	Settings = store.Page_Settings,
}
for _, page in pairs(pageMap) do
	if page then
		page.Visible = false
		page.Size = UDim2.new(1, 0, 0, 0)
		page.AutomaticSize = Enum.AutomaticSize.Y
		if not page:FindFirstChildOfClass("UIListLayout") then
			local pl = Instance.new("UIListLayout")
			pl.SortOrder = Enum.SortOrder.LayoutOrder
			pl.Padding = UDim.new(0, 6)
			pl.Parent = page
		end
	end
end

for _, key in ipairs({"DropdownPanel","DropdownPanel2","DropdownPanel3","DropdownPanel4","DropdownPanel5","DropdownPanel6"}) do
	local d = store[key]
	if d then d.Visible = false end
end

if tabBar then
	tabBar.Visible = true
	tabBar.Position = UDim2.new(0, 8, 1, -42)
	tabBar.Size = UDim2.new(1, -16, 0, 36)
	tabBar.ScrollingDirection = Enum.ScrollingDirection.X
	tabBar.ScrollBarThickness = 0
	tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
	tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local tabButtons = {}
if tabBar then
	for _, child in ipairs(tabBar:GetChildren()) do
		if child:IsA("TextButton") then
			local label = child:FindFirstChild("Label")
			local underline = child:FindFirstChild("Underline")
			tabButtons[#tabButtons + 1] = {
				btn = child,
				label = label,
				underline = underline,
				name = label and label.Text or "",
			}
		end
	end
	table.sort(tabButtons, function(a, b)
		return (a.btn.LayoutOrder or 0) < (b.btn.LayoutOrder or 0)
	end)
end

local function setTab(name)
	for _, page in pairs(pageMap) do
		if page then page.Visible = false end
	end
	local target = pageMap[name]
	if not target then
		-- fallback removed: if name not in map, do nothing
		return
	end
	if target then target.Visible = true end
	for _, t in ipairs(tabButtons) do
		local on = (t.name == name)
		if t.label then
			t.label.TextColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 135, 145)
		end
		if t.underline then
			t.underline.BackgroundTransparency = on and 0 or 1
		end
	end
end

for _, t in ipairs(tabButtons) do
	t.btn.Activated:Connect(function()
		setTab(t.name)
	end)
end

if pageMap.Speed then
	setTab("Speed")
elseif pageMap.Steal then
	setTab("Steal")
end

local minBtn = store.TextButton
local minimized = false
if minBtn and outer then
	minBtn.Activated:Connect(function()
		minimized = not minimized
		if scroll then scroll.Visible = not minimized end
		if tabBar then tabBar.Visible = not minimized end
		if minimized then
			outer.Size = UDim2.new(0, 330, 0, 64)
			minBtn.Text = "+"
		else
			outer.Size = UDim2.new(0, 330, 0, 470)
			minBtn.Text = "-"
		end
	end)
end

if outer then
	local dragging, startIn, startPos = false, nil, nil
	local header = store.Frame or outer
	header.InputBegan:Connect(function(input)
		if _G.__KrixLockUI then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startIn = input.Position
			startPos = outer.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - startIn
			outer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

if store.StealBar then
	store.StealBar.AnchorPoint = Vector2.new(0.5, 1)
	store.StealBar.Position = UDim2.new(0.5, 0, 1, -24)
end

if gui then
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 1000000
	gui.Enabled = true
	pcall(function()
		local old = pg:FindFirstChild("KrixHubGUI")
		if old and old ~= gui then old:Destroy() end
	end)
	parentGui(gui)
end

-- ============================
-- TOGGLE LOGIC FOR BUTTONS
-- ============================

local toggles = {}  -- store state per button
local function toggleButton(btn, state)
	if state == nil then
		state = not toggles[btn]
	end
	toggles[btn] = state
	-- Visual feedback: change stroke transparency or background
	local stroke = btn:FindFirstChildOfClass("UIStroke")
	if stroke then
		stroke.Transparency = state and 0.1 or 1
	end
	-- Also change background color slightly
	if state then
		btn.BackgroundColor3 = Color3.fromRGB(30,30,35)
	else
		btn.BackgroundColor3 = Color3.fromRGB(8,8,10)
	end
	return state
end

-- Mobile buttons
local mobileBtns = {
	store.MB_tpBat,
	store.MB_drop,
	store.MB_autoLeft,
	store.MB_reset,
	store.MB_batLock,
	store.MB_autoRight,
	store.MB_customSpeed,
	store.MB_tpDown,
	store.MB_carry,
	store.MB_customCarry,
	store.MB_laggerCarry,
	store.MB_laggerSpeed,
}
for _, btn in ipairs(mobileBtns) do
	if btn then
		btn.Activated:Connect(function()
			toggleButton(btn)
		end)
		-- initialize off
		toggleButton(btn, false)
	end
end

-- Dropdown toggles: arrow buttons to show/hide panels
local dropdownPairs = {
	{ btn = store.TextButton19, panel = store.DropdownPanel },
	{ btn = store.TextButton23, panel = store.DropdownPanel2 },
	{ btn = store.TextButton45, panel = store.DropdownPanel3 },
	{ btn = store.TextButton49, panel = store.DropdownPanel4 },
	{ btn = store.TextButton55, panel = store.DropdownPanel5 },
	{ btn = store.TextButton79, panel = store.DropdownPanel6 },
}
for _, pair in ipairs(dropdownPairs) do
	if pair.btn and pair.panel then
		pair.btn.Activated:Connect(function()
			pair.panel.Visible = not pair.panel.Visible
		end)
	end
end

-- Selection buttons (V1/V2, modes, etc.) -- FIXED: direct store refs (FindFirstChild missed: instance Names are generic)
local SELECT_ON_BG = Color3.fromRGB(254, 254, 254)
local SELECT_ON_TX = Color3.fromRGB(0, 0, 0)
local SELECT_OFF_BG = Color3.fromRGB(30, 30, 30)
local SELECT_OFF_TX = Color3.fromRGB(165, 165, 170)
local selectionGroups = {} -- {buttons, selected, snapshot, onSelect, select}
local function paintSelectBtn(btn, on)
	btn.BackgroundTransparency = 0.5
	if on then
		btn.BackgroundColor3 = SELECT_ON_BG
		btn.TextColor3 = SELECT_ON_TX
	else
		btn.BackgroundColor3 = SELECT_OFF_BG
		btn.TextColor3 = SELECT_OFF_TX
	end
end
local function setupSelectionGroup2(storeKeys, defaultIndex, onSelect)
	local buttons = {}
	for _, key in ipairs(storeKeys) do
		local btn = store[key]
		if btn then buttons[#buttons + 1] = btn end
	end
	if #buttons == 0 then return nil end
	local group = { buttons = buttons, selected = nil, snapshot = {}, onSelect = onSelect }
	for _, btn in ipairs(buttons) do
		group.snapshot[btn] = { bg = btn.BackgroundColor3, tx = btn.TextColor3, tr = btn.BackgroundTransparency }
	end
	local function select(btn)
		group.selected = btn
		for _, other in ipairs(buttons) do
			paintSelectBtn(other, other == btn)
		end
		if group.onSelect then pcall(group.onSelect, btn) end
	end
	group.select = select
	for _, btn in ipairs(buttons) do
		btn.Activated:Connect(function()
			select(btn)
		end)
	end
	local initial = buttons[defaultIndex or 1] or buttons[1]
	for _, btn in ipairs(buttons) do
		if btn.BackgroundColor3 == SELECT_ON_BG or btn.TextColor3 == SELECT_ON_TX then
			initial = btn
			break
		end
	end
	select(initial)
	selectionGroups[#selectionGroups + 1] = group
	return group
end

setupSelectionGroup2({"TextButton16", "TextButton17"}, 1) -- Speed Change Method V1/V2
setupSelectionGroup2({"TextButton24", "TextButton25"}, 1) -- Steal Mode Normal/Semi
setupSelectionGroup2({"TextButton33", "TextButton34"}, 2) -- TP Mode V1/V2
setupSelectionGroup2({"TextButton42", "TextButton43"}, 1) -- Aimbot Mode Normal/Bypass
setupSelectionGroup2({"TextButton67", "TextButton68"}, 1) -- Auto Play Mode
setupSelectionGroup2({"TextButton71", "TextButton72", "TextButton73"}, 1) -- Display Default/FOV/Stretch
setupSelectionGroup2({"TextButton80", "TextButton81", "TextButton82", "TextButton83", "TextButton84"}, 1) -- ESP Type
setupSelectionGroup2({"TextButton20", "TextButton21"}, 1) -- Auto Speed: On Pick Up / Soft Steal
setupSelectionGroup2({"TextButton46", "TextButton47"}, 1) -- Jump Mode Single/Hold
setupSelectionGroup2({"TextButton50", "TextButton51"}, 1) -- Ragdoll Mode V1/V2
setupSelectionGroup2({"TextButton56", "TextButton57"}, 1) -- Drop Type Stand/Jump


-- Settings: Panels (Frame212, Frame213, Frame214, Frame215) are buttons that can be toggled
local panelBtns = {
	store.TextButton96,
	store.TextButton97,
	store.TextButton98,
	store.TextButton99,
}
for _, btn in ipairs(panelBtns) do
	if btn then
		btn.Activated:Connect(function()
			toggleButton(btn)
		end)
		toggleButton(btn, false)
	end
end

-- ============================
-- KEYBIND SYSTEM
-- ============================

local keybindButton = store.TextButton104  -- the one in Settings -> UI Toggle Key
local keybindLabel = store.TextLabel110
local toggleKey = nil  -- will store Enum.KeyCode
local capturingUIKey = false
local function keyName(code)
	return tostring(code):gsub("Enum.KeyCode.", "")
end

if keybindButton then
	keybindButton.Activated:Connect(function()
		if capturingUIKey then return end
		capturingUIKey = true
		local prev = (keybindLabel and keybindLabel.Text) or ""
		if keybindLabel then keybindLabel.Text = "..." end
		local con
		con = UIS.InputBegan:Connect(function(input, gameProcessed)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if input.KeyCode == Enum.KeyCode.Escape then
				if keybindLabel then keybindLabel.Text = prev end
			elseif not gameProcessed then
				toggleKey = input.KeyCode
				if keybindLabel then keybindLabel.Text = keyName(toggleKey) end
			else
				if keybindLabel then keybindLabel.Text = prev end
			end
			capturingUIKey = false
			con:Disconnect()
		end)
	end)
end

-- Global keybind to toggle UI visibility
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or capturingUIKey then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if toggleKey and input.KeyCode == toggleKey then
			gui.Enabled = not gui.Enabled
		end
	end
end)

if not toggleKey then
	toggleKey = Enum.KeyCode.RightShift  -- default
end
if keybindLabel then keybindLabel.Text = keyName(toggleKey) end


-- ============================
-- STEAL BAR FILL UPDATE
-- ============================
local stealBarFill = store.Fill
local stealPercentLabel = store.StealPercent
local function updateStealBar(percent)
	if stealBarFill then
		stealBarFill.Size = UDim2.new(math.clamp(percent/100, 0, 1), 0, 1, 0)
	end
	if stealPercentLabel then
		stealPercentLabel.Text = tostring(math.floor(percent)).."%"
	end
end

-- Example: update steal bar to 45% on startup
updateStealBar(45)

-- ============================
-- END OF MODIFICATIONS
-- ============================

-- The UI is now fully functional.

-- ============================================================
-- PEPSI CUSTOMIZATION + BUGFIX PACK
-- (header branding, toggles, dropdowns, keybinds, steppers,
--  sliders, cyclers, boxes, mobile buttons, reset, live stats)
-- ============================================================

local PEPSI_BLUE = Color3.fromRGB(0, 150, 255)

-- ---------- environment snapshot ----------
local camRef = workspace.CurrentCamera
local lightRef = game:GetService("Lighting")
local initCamFOV, initClockTime, initBrightness = 70, 14, 2
pcall(function()
	if camRef then initCamFOV = camRef.FieldOfView end
	initClockTime = lightRef.ClockTime
	initBrightness = lightRef.Brightness
end)
local function safely(fn)
	pcall(fn)
end

-- ---------- 1. header: Pepsi title (middle) + logo (left) ----------
do
	local header = store.Frame
	if header then
		-- soft blue glow behind the logo (same glow style the UI already uses)
		local glow = Instance.new("ImageLabel")
		glow.Name = "PepsiLogoGlow"
		glow.ZIndex = 5
		glow.AnchorPoint = Vector2.new(0, 0.5)
		glow.Position = UDim2.new(0, 4, 0.5, 0)
		glow.Size = UDim2.new(0, 56, 0, 56)
		glow.BackgroundTransparency = 1
		glow.Image = "rbxassetid://5028857084"
		glow.ImageColor3 = PEPSI_BLUE
		glow.ImageTransparency = 0.75
		glow.ScaleType = Enum.ScaleType.Slice
		glow.SliceCenter = Rect.new(24, 24, 276, 276)
		glow.Parent = header

		-- logo: bigger, rounded like the UI cards, signature gradient border
		local logo = Instance.new("ImageLabel")
		logo.Name = "PepsiLogo"
		logo.ZIndex = 6
		logo.AnchorPoint = Vector2.new(0, 0.5)
		logo.Position = UDim2.new(0, 10, 0.5, 0)
		logo.Size = UDim2.new(0, 44, 0, 44)
		logo.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		logo.BackgroundTransparency = 0.5
		logo.BorderSizePixel = 0
		logo.Image = "rbxassetid://98828561238094"
		logo.ScaleType = Enum.ScaleType.Fit
		logo.Parent = header
		local logoCorner = Instance.new("UICorner")
		logoCorner.CornerRadius = UDim.new(0, 12)
		logoCorner.Parent = logo
		local logoStroke = Instance.new("UIStroke")
		logoStroke.Color = Color3.fromRGB(254, 254, 254)
		logoStroke.Thickness = 1.4
		logoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		logoStroke.Transparency = 0.25
		logoStroke.Parent = logo
		local logoGrad = Instance.new("UIGradient")
		logoGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 90, 90)), ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 90, 90))})
		logoGrad.Parent = logoStroke

		-- title: bigger + smooth glossy gradient
		local title = Instance.new("TextLabel")
		title.Name = "PepsiTitle"
		title.ZIndex = 6
		title.Position = UDim2.new(0, 0, 0, 4)
		title.Size = UDim2.new(1, 0, 0, 34)
		title.BackgroundTransparency = 1
		title.Text = "Pepsi"
		title.TextColor3 = PEPSI_BLUE
		title.TextSize = 30
		title.Font = Enum.Font.GothamBlack
		title.Parent = header
		local titleGrad = Instance.new("UIGradient")
		titleGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 210, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 110, 220))})
		titleGrad.Rotation = 90
		titleGrad.Parent = title
		local titleStroke = Instance.new("UIStroke")
		titleStroke.Color = Color3.fromRGB(0, 40, 90)
		titleStroke.Thickness = 1
		titleStroke.Transparency = 0.35
		titleStroke.Parent = title
		-- subtitle: discord invite, click to copy
		local subtitle = Instance.new("TextLabel")
		subtitle.Name = "PepsiDiscord"
		subtitle.ZIndex = 6
		subtitle.Position = UDim2.new(0, 0, 0, 38)
		subtitle.Size = UDim2.new(1, 0, 0, 16)
		subtitle.BackgroundTransparency = 1
		subtitle.Text = "discord.gg/pepsihub"
		subtitle.TextColor3 = Color3.fromRGB(130, 190, 255)
		subtitle.TextSize = 12
		subtitle.Font = Enum.Font.GothamBold
		subtitle.Parent = header
		local copyBtn = Instance.new("TextButton")
		copyBtn.Name = "PepsiDiscordCopy"
		copyBtn.ZIndex = 7
		copyBtn.Position = UDim2.new(0, 0, 0, 38)
		copyBtn.Size = UDim2.new(1, 0, 0, 16)
		copyBtn.BackgroundTransparency = 1
		copyBtn.Text = ""
		copyBtn.AutoButtonColor = false
		copyBtn.Parent = header
		copyBtn.Activated:Connect(function()
			if typeof(setclipboard) == "function" then
				pcall(setclipboard, "https://discord.gg/pepsihub")
			end
			subtitle.Text = "Copied to clipboard!"
			subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			task.delay(1.2, function()
				pcall(function()
					subtitle.Text = "discord.gg/pepsihub"
					subtitle.TextColor3 = Color3.fromRGB(130, 190, 255)
				end)
			end)
		end)
	end
end

-- ---------- 2. toggle switches (visual on/off + behaviors) ----------
local switchStates = {}
local switchSnapshot = {}
local switchBehaviors = {}
local SW_ON_PILL = Color3.fromRGB(254, 254, 254)
local SW_OFF_PILL = Color3.fromRGB(40, 40, 40)
local SW_ON_KNOB = Color3.fromRGB(255, 255, 255)
local SW_OFF_KNOB = Color3.fromRGB(120, 120, 120)
local SW_ON_POS = UDim2.new(0, 18, 0.5, -6)
local SW_OFF_POS = UDim2.new(0, 2, 0.5, -6)

local function paintSwitch(pill, knob, on)
	if pill then
		pill.BackgroundColor3 = on and SW_ON_PILL or SW_OFF_PILL
		local st = pill:FindFirstChildOfClass("UIStroke")
		if st then
			st.Color = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(70, 70, 70)
			st.Transparency = on and 0.4 or 0.5
		end
	end
	if knob then
		knob.Position = on and SW_ON_POS or SW_OFF_POS
		knob.BackgroundColor3 = on and SW_ON_KNOB or SW_OFF_KNOB
	end
end

local function wireSwitch(btnKey, pillKey, knobKey)
	local btn = store[btnKey]
	local pill = store[pillKey]
	local knob = store[knobKey]
	if not (btn and pill and knob) then return end
	local on = knob.Position.X.Offset >= 10
	switchStates[btn] = { pill = pill, knob = knob, on = on, key = btnKey }
	switchSnapshot[btn] = on
	paintSwitch(pill, knob, on)
	btn.Activated:Connect(function()
		local s = switchStates[btn]
		if not s then return end
		s.on = not s.on
		paintSwitch(s.pill, s.knob, s.on)
		local bh = switchBehaviors[s.key]
		if bh then safely(function() bh(s.on) end) end
	end)
end

local function setSwitch(btnKey, on, runBehavior)
	local btn = store[btnKey]
	local s = btn and switchStates[btn]
	if not s then return end
	s.on = on
	paintSwitch(s.pill, s.knob, on)
	if runBehavior then
		local bh = switchBehaviors[btnKey]
		if bh then safely(function() bh(on) end) end
	end
end

local switchDefs = {
	{"TextButton18","Frame26","Frame27"},{"TextButton22","Frame36","Frame37"},
	{"TextButton26","Frame41","Frame42"},{"TextButton29","Frame58","Frame59"},
	{"TextButton30","Frame62","Frame63"},{"TextButton35","Frame71","Frame72"},
	{"TextButton36","Frame75","Frame76"},{"TextButton37","Frame79","Frame80"},
	{"TextButton38","Frame83","Frame84"},{"TextButton39","Frame87","Frame88"},
	{"TextButton41","Frame94","Frame95"},{"TextButton44","Frame103","Frame104"},
	{"TextButton48","Frame108","Frame109"},{"TextButton60","Frame127","Frame128"},
	{"TextButton63","Frame134","Frame135"},{"TextButton64","Frame139","Frame140"},
	{"TextButton77","Frame172","Frame173"},{"TextButton78","Frame178","Frame179"},
	{"TextButton87","Frame185","Frame186"},{"TextButton88","Frame189","Frame190"},
	{"TextButton89","Frame193","Frame194"},{"TextButton90","Frame197","Frame198"},
	{"TextButton91","Frame201","Frame202"},{"TextButton100","Frame220","Frame221"},
	{"TextButton103","Frame226","Frame227"},{"TextButton111","Frame247","Frame248"},
	{"TextButton113","Frame251","Frame252"},{"TextButton117","Frame261","Frame262"},
	{"TextButton118","Frame265","Frame266"},{"TextButton119","Frame269","Frame270"},
	{"TextButton120","Frame273","Frame274"},{"TextButton121","Frame277","Frame278"},
	{"TextButton122","Frame281","Frame282"},{"TextButton123","Frame285","Frame286"},
	{"TextButton124","Frame289","Frame290"},{"TextButton125","Frame293","Frame294"},
	{"TextButton126","Frame297","Frame298"},{"TextButton127","Frame301","Frame302"},
	{"TextButton128","Frame305","Frame306"},
}
for _, d in ipairs(switchDefs) do
	wireSwitch(d[1], d[2], d[3])
end

-- ---------- 3. mobile buttons: scale/drag/visibility ----------
local mobileBtnList = mobileBtns -- reuse list wired earlier
local mbSnapshot = {}
for _, b in ipairs(mobileBtnList) do
	if b then
		mbSnapshot[b] = { pos = b.Position, size = b.Size }
		if not b:FindFirstChildOfClass("UIScale") then
			local sc = Instance.new("UIScale")
			sc.Scale = 1
			sc.Parent = b
		end
	end
end
local perBtnMap = {
	TextButton117 = "MB_tpBat", TextButton118 = "MB_drop",
	TextButton119 = "MB_autoLeft", TextButton120 = "MB_reset",
	TextButton121 = "MB_batLock", TextButton122 = "MB_autoRight",
	TextButton123 = "MB_customSpeed", TextButton124 = "MB_tpDown",
	TextButton125 = "MB_carry", TextButton126 = "MB_customCarry",
	TextButton127 = "MB_laggerCarry", TextButton128 = "MB_laggerSpeed",
}
local function refreshMobileVisibility()
	local master = switchStates[store.TextButton111]
	local hidden = master and master.on or false
	for tKey, mbKey in pairs(perBtnMap) do
		local sw = switchStates[store[tKey]]
		local mb = store[mbKey]
		if mb then
			local individual = (sw == nil) or sw.on
			mb.Visible = (not hidden) and individual
		end
	end
	if store.VezyMobileButtons then
		store.VezyMobileButtons.Visible = not hidden
	end
end
local function applyCircleButtons(on)
	for _, b in ipairs(mobileBtnList) do
		if b then
			local c = b:FindFirstChildOfClass("UICorner")
			if c then c.CornerRadius = on and UDim.new(1, 0) or UDim.new(0, 16) end
		end
	end
end

switchBehaviors["TextButton111"] = function() refreshMobileVisibility() end
switchBehaviors["TextButton113"] = function(on) applyCircleButtons(on) end
for tKey, _ in pairs(perBtnMap) do
	switchBehaviors[tKey] = function() refreshMobileVisibility() end
end
switchBehaviors["TextButton100"] = function(on) _G.__KrixLockUI = on end
switchBehaviors["TextButton91"] = function(on)
	if on then
		pcall(function() lightRef.ClockTime = 0 end)
	else
		pcall(function() lightRef.ClockTime = initClockTime end)
	end
end
local infJumpOn = false
switchBehaviors["TextButton44"] = function(on) infJumpOn = on end
UIS.JumpRequest:Connect(function()
	if not infJumpOn then return end
	safely(function()
		local ch = LP.Character
		local hum = ch and ch:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end)
end)

-- sync initial mobile visibility / circle / lock states
refreshMobileVisibility()
do
	local cs = switchStates[store.TextButton113]
	if cs then applyCircleButtons(cs.on) end
	local lk = switchStates[store.TextButton100]
	if lk then _G.__KrixLockUI = lk.on end
end

-- draggable mobile buttons (+ undo accidental toggle after a drag)
for _, b in ipairs(mobileBtnList) do
	if b then
		do
			local draggingMB = false
			local startInMB, startPosMB = nil, nil
			b.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingMB = true
					b._movedFar = nil
					startInMB = input.Position
					startPosMB = b.Position
				end
			end)
			UIS.InputChanged:Connect(function(input)
				if not draggingMB then return end
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					local d = input.Position - startInMB
					if math.abs(d.X) + math.abs(d.Y) > 10 then b._movedFar = true end
					b.Position = UDim2.new(startPosMB.X.Scale, startPosMB.X.Offset + d.X, startPosMB.Y.Scale, startPosMB.Y.Offset + d.Y)
				end
			end)
			UIS.InputEnded:Connect(function(input)
				if input.UserInputState == Enum.UserInputState.End then draggingMB = false end
			end)
			b.Activated:Connect(function()
				if b._movedFar then
					b._movedFar = nil
					toggleButton(b, not toggles[b])
				end
			end)
		end
	end
end

-- ---------- 4. dropdown arrows that were never wired ----------
local function setArrow(btn, open)
	if not btn then return end
	local lbl = btn:FindFirstChildOfClass("TextLabel")
	if lbl and (lbl.Text == "▼" or lbl.Text == "▲") then
		lbl.Text = open and "▲" or "▼"
	end
end
if store.Frame73 then store.Frame73.LayoutOrder = 33 end -- sit under the TP Bat row
local extraDropdowns = {
	{ btn = "TextButton28", panels = {"Frame96","Frame50","Frame52","Frame54","Frame56"} },
	{ btn = "TextButton32", panels = {"Frame73","Frame67","Frame69","Frame60"} },
	{ btn = "TextButton40", panels = {"Frame89","Frame98"} },
	{ btn = "TextButton61", panels = {"Frame129"} },
	{ btn = "TextButton92", panels = {"Frame203"} },
	{ btn = "TextButton112", panels = {"Frame259","Frame263","Frame267","Frame271","Frame275","Frame279","Frame283","Frame287","Frame291","Frame295","Frame299","Frame303"} },
}
for _, item in ipairs(extraDropdowns) do
	local btn = store[item.btn]
	if btn then
		btn.Activated:Connect(function()
			local first = store[item.panels[1]]
			if not first then return end
			local show = not first.Visible
			for _, pkey in ipairs(item.panels) do
				local p = store[pkey]
				if p then p.Visible = show end
			end
			setArrow(btn, show)
		end)
	end
end
-- arrow flip for the dropdowns wired earlier too
for _, pair in ipairs(dropdownPairs) do
	if pair.btn and pair.panel then
		pair.btn.Activated:Connect(function()
			setArrow(pair.btn, pair.panel.Visible)
		end)
	end
end

-- ---------- 5. selectable speed rows ----------
local speedRows = {
	{ btn = "TextButton10", stroke = "UIStroke", id = "lagger" },
	{ btn = "TextButton12", stroke = "UIStroke4", id = "custom" },
	{ btn = "TextButton14", stroke = "UIStroke7", id = "normal" },
}
local speedStrokeSnap = {}
for _, r in ipairs(speedRows) do
	local st = store[r.stroke]
	if st then speedStrokeSnap[r.id] = { c = st.Color, t = st.Thickness, tr = st.Transparency } end
end
local selectedSpeedId = "normal"
local speedInitId = "normal"
local function selectSpeedRow(id)
	selectedSpeedId = id
	store.SelectedSpeed = id
	for _, r in ipairs(speedRows) do
		local st = store[r.stroke]
		if st then
			if r.id == id then
				st.Color = Color3.fromRGB(254, 254, 254)
				st.Thickness = 1.4
				st.Transparency = 0.2
			else
				st.Color = Color3.fromRGB(38, 38, 38)
				st.Thickness = 1
				st.Transparency = 0.5
			end
		end
	end
end
do
	for _, r in ipairs(speedRows) do
		local st = store[r.stroke]
		if st and st.Color == Color3.fromRGB(254, 254, 254) then speedInitId = r.id break end
	end
	for _, r in ipairs(speedRows) do
		local b = store[r.btn]
		if b then b.Activated:Connect(function() selectSpeedRow(r.id) end) end
	end
	selectSpeedRow(speedInitId)
end

-- ---------- 6. feature keybinds ----------
local featureKeys = {}
store.FeatureKeys = featureKeys
local capturingFeature = false
local function bindFeatureKey(btnKey, labelKey, id)
	local btn = store[btnKey]
	local label = store[labelKey]
	if not (btn and label) then return end
	btn.Activated:Connect(function()
		if capturingFeature or capturingUIKey then return end
		capturingFeature = true
		local prev = label.Text
		label.Text = "..."
		local con
		con = UIS.InputBegan:Connect(function(input, gameProcessed)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if input.KeyCode == Enum.KeyCode.Escape then
				label.Text = prev
			elseif not gameProcessed then
				featureKeys[id] = input.KeyCode
				label.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
			else
				label.Text = prev
			end
			capturingFeature = false
			con:Disconnect()
		end)
	end)
end
bindFeatureKey("TextButton11", "TextLabel3", "laggerSpeed")
bindFeatureKey("TextButton13", "TextLabel5", "customSpeed")
bindFeatureKey("TextButton15", "TextLabel7", "normalSpeed")
bindFeatureKey("TextButton27", "TextLabel21", "batAimbot")
bindFeatureKey("TextButton31", "TextLabel29", "tpBat")
bindFeatureKey("TextButton54", "TextLabel53", "dropBrainrot")
bindFeatureKey("TextButton59", "TextLabel59", "instaReset")
bindFeatureKey("TextButton65", "TextLabel68", "autoLeft")
bindFeatureKey("TextButton66", "TextLabel70", "autoRight")
bindFeatureKey("TextButton58", "TextLabel57", "tpDown")
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or capturingFeature or capturingUIKey then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	local kc = input.KeyCode
	if featureKeys.laggerSpeed and kc == featureKeys.laggerSpeed then
		selectSpeedRow("lagger")
	elseif featureKeys.customSpeed and kc == featureKeys.customSpeed then
		selectSpeedRow("custom")
	elseif featureKeys.normalSpeed and kc == featureKeys.normalSpeed then
		selectSpeedRow("normal")
	end
end)

-- ---------- 7. +/- steppers (UI size, steal scale, mobile size, FOV) ----------
local steppers = {}
local function findGroupByMember(btnKey)
	local target = store[btnKey]
	if not target then return nil end
	for _, g in ipairs(selectionGroups) do
		for _, b in ipairs(g.buttons) do
			if b == target then return g end
		end
	end
	return nil
end
local function displaySelected()
	local g = findGroupByMember("TextButton71")
	if g and g.selected then return g.selected.Text end
	return "Default"
end
local function makeStepper(minusKey, plusKey, labelKey, opt)
	local minus = store[minusKey]
	local plus = store[plusKey]
	local label = store[labelKey]
	if not (minus and plus and label) then return nil end
	local s = { label = label, opt = opt, value = opt.get() }
	s.init = s.value
	local function render()
		label.Text = string.format(opt.fmt, s.value)
	end
	s.render = render
	s.reset = function()
		s.value = s.init
		render()
		safely(function() opt.set(s.value) end)
	end
	render()
	minus.Activated:Connect(function()
		s.value = math.clamp(s.value - opt.step, opt.min, opt.max)
		render()
		safely(function() opt.set(s.value) end)
	end)
	plus.Activated:Connect(function()
		s.value = math.clamp(s.value + opt.step, opt.min, opt.max)
		render()
		safely(function() opt.set(s.value) end)
	end)
	steppers[#steppers + 1] = s
	return s
end
local mobileStepper
makeStepper("TextButton105", "TextButton106", "TextLabel113", {
	min = 0.7, max = 1.3, step = 0.05, fmt = "%.2f",
	get = function()
		if store.UIScale then return store.UIScale.Scale end
		return 1
	end,
	set = function(v)
		if store.UIScale then store.UIScale.Scale = v end
	end,
})
makeStepper("TextButton107", "TextButton108", "TextLabel115", {
	min = 0.7, max = 1.3, step = 0.05, fmt = "%.2f",
	get = function()
		if store.UIScale2 then return store.UIScale2.Scale end
		return 1
	end,
	set = function(v)
		if store.UIScale2 then store.UIScale2.Scale = v end
	end,
})
mobileStepper = makeStepper("TextButton109", "TextButton110", "TextLabel117", {
	min = 0.7, max = 1.5, step = 0.05, fmt = "%.2f",
	get = function() return 1 end,
	set = function(v)
		for _, b in ipairs(mobileBtnList) do
			if b then
				local sc = b:FindFirstChildOfClass("UIScale")
				if sc then sc.Scale = v end
			end
		end
	end,
})
makeStepper("TextButton74", "TextButton75", "TextLabel79", {
	min = 70, max = 120, step = 5, fmt = "%.0f",
	get = function() return tonumber(store.TextLabel79.Text) or 120 end,
	set = function(v)
		if displaySelected() == "FOV" and camRef then
			pcall(function() camRef.FieldOfView = v end)
		end
	end,
})

-- ---------- 8. sliders (stretch rez, darkness) ----------
local sliders = {}
local function makeSlider(trackKey, fillKey, knobKey, coverKey, labelKey, opt)
	local track = store[trackKey]
	local fill = store[fillKey]
	local knob = store[knobKey]
	local cover = store[coverKey]
	local label = store[labelKey]
	if not (track and fill and knob and label) then return nil end
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	local sl = { frac = fill.Size.X.Scale, opt = opt, value = 0 }
	sl.init = sl.frac
	local function apply(runCallback)
		local v = opt.min + sl.frac * (opt.max - opt.min)
		v = math.clamp(math.floor(v / opt.step + 0.5) * opt.step, opt.min, opt.max)
		sl.value = v
		label.Text = string.format(opt.fmt, v)
		fill.Size = UDim2.new(sl.frac, 0, 1, 0)
		knob.Position = UDim2.new(sl.frac, 0, 0.5, 0)
		if runCallback and opt.onChange then safely(function() opt.onChange(v) end) end
	end
	sl.reset = function()
		sl.frac = sl.init
		apply(true)
	end
	local function setFromX(x)
		local ax = track.AbsolutePosition.X
		local aw = track.AbsoluteSize.X
		if aw <= 0 then return end
		sl.frac = math.clamp((x - ax) / aw, 0, 1)
		apply(true)
	end
	apply(false)
	local draggingSL = false
	local function begin(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSL = true
			setFromX(input.Position.X)
		end
	end
	if cover then cover.InputBegan:Connect(begin) end
	track.InputBegan:Connect(begin)
	knob.InputBegan:Connect(begin)
	UIS.InputChanged:Connect(function(input)
		if not draggingSL then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			setFromX(input.Position.X)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputState == Enum.UserInputState.End then draggingSL = false end
	end)
	sliders[#sliders + 1] = sl
	return sl
end
makeSlider("Frame168", "Frame169", "SliderKnob", "TextButton76", "TextLabel81", {
	min = 0.3, max = 1.0, step = 0.1, fmt = "%.1f",
})
makeSlider("Frame206", "Frame207", "SliderKnob2", "TextButton93", "TextLabel96", {
	min = 0, max = 10, step = 0.1, fmt = "%.1f",
	onChange = function(v)
		pcall(function() lightRef.Brightness = v end)
	end,
})

-- ---------- 9. < / > cyclers ----------
local cyclers = {}
local function makeCycler(prevKey, nextKey, labelKey, options)
	local prev = store[prevKey]
	local nxt = store[nextKey]
	local label = store[labelKey]
	if not label then return nil end
	local c = { options = options, idx = 1 }
	for i, op in ipairs(options) do
		if label.Text == op then c.idx = i break end
	end
	c.init = c.idx
	c.reset = function()
		c.idx = c.init
		label.Text = options[c.idx]
	end
	local function step(d)
		c.idx = ((c.idx - 1 + d) % #options) + 1
		label.Text = options[c.idx]
	end
	if prev then prev.Activated:Connect(function() step(-1) end) end
	if nxt then nxt.Activated:Connect(function() step(1) end) end
	cyclers[#cyclers + 1] = c
	return c
end
makeCycler("TextButton52", "TextButton53", "TextLabel50", {"OFF", "ON"})
makeCycler("TextButton69", "TextButton70", "TextLabel76", {"OFF", "ON"})
makeCycler("TextButton85", "TextButton86", "TextLabel88", {"OFF", "ON"})
makeCycler("TextButton101", "TextButton102", "TextLabel107", {"SONG 1", "SONG 2", "SONG 3"})

-- ---------- 10. numeric textboxes ----------
local boxSnapshot = {}
local boxLastValid = {}
local numericBoxes = {"TextBox","TextBox2","TextBox3","TextBox4","TextBox5","TextBox6","TextBox7","TextBox8","TextBox9","TextBox10","TextBox11","TextBox12","TextBox13"}
for _, key in ipairs(numericBoxes) do
	local b = store[key]
	if b then
		boxSnapshot[b] = b.Text
		boxLastValid[b] = b.Text
		b.FocusLost:Connect(function()
			local t = b.Text
			if t ~= nil and t ~= "" and tonumber(t) ~= nil then
				boxLastValid[b] = t
				if key == "TextBox7" then refreshStealModeInfo() end
			else
				b.Text = boxLastValid[b]
			end
		end)
	end
end

-- ---------- 11. steal bar info + display side effects ----------
function refreshStealModeInfo()
	local mode = "NORMAL"
	local g = findGroupByMember("TextButton24")
	if g and g.selected and g.selected.Text then
		mode = string.upper(g.selected.Text)
	end
	local r = "62"
	if store.TextBox7 and tonumber(store.TextBox7.Text) then
		r = tostring(math.floor(tonumber(store.TextBox7.Text)))
	end
	if store.StealModeInfo then
		store.StealModeInfo.Text = mode .. " " .. r .. " RADIUS"
	end
end
do
	local stealGroup = findGroupByMember("TextButton24")
	if stealGroup then
		stealGroup.onSelect = function() refreshStealModeInfo() end
		refreshStealModeInfo()
	end
	local dispGroup = findGroupByMember("TextButton71")
	if dispGroup then
		dispGroup.onSelect = function(btn)
			local t = btn.Text
			if store.Frame162 then store.Frame162.Visible = (t == "FOV") end
			if store.Frame165 then store.Frame165.Visible = (t == "Stretch") end
			if t == "FOV" then
				local v = tonumber(store.TextLabel79.Text) or 70
				if camRef then pcall(function() camRef.FieldOfView = v end) end
			elseif t == "Default" then
				if camRef then pcall(function() camRef.FieldOfView = initCamFOV end) end
			end
		end
		safely(function() dispGroup.onSelect(dispGroup.selected) end)
	end
end

-- ---------- 12. background image picker ----------
local bgSnapshot = { image = nil, visible = true }
if store.BackgroundImage then
	bgSnapshot.image = store.BackgroundImage.Image
	bgSnapshot.visible = store.BackgroundImage.Visible
end
do
	local sf = store.ScrollingFrame2
	if sf then
		sf.AutomaticCanvasSize = Enum.AutomaticSize.X
		sf.CanvasSize = UDim2.new(0, 0, 0, 0)
		if not sf:FindFirstChildOfClass("UIListLayout") then
			local lay = Instance.new("UIListLayout")
			lay.FillDirection = Enum.FillDirection.Horizontal
			lay.VerticalAlignment = Enum.VerticalAlignment.Center
			lay.Padding = UDim.new(0, 6)
			lay.SortOrder = Enum.SortOrder.LayoutOrder
			lay.Parent = sf
		end
	end
	local bgBtnKeys = {"ImageButton","ImageButton2","ImageButton3","ImageButton4","ImageButton5","ImageButton6","ImageButton7","ImageButton8","ImageButton9","ImageButton10"}
	local bgTickKeys = {"Tick","Tick2","Tick3","Tick4","Tick5","Tick6","Tick7","Tick8","Tick9","Tick10"}
	local function hideAllTicks()
		for _, tk in ipairs(bgTickKeys) do
			local t = store[tk]
			if t then t.Visible = false end
		end
	end
	hideAllTicks() -- startup image is custom (not in the list)
	for i, bk in ipairs(bgBtnKeys) do
		local b = store[bk]
		if b then
			b.Activated:Connect(function()
				local img = b.Image
				if store.BackgroundImage then
					if img and img ~= "" then
						store.BackgroundImage.Visible = true
						store.BackgroundImage.Image = img
					else
						store.BackgroundImage.Visible = false
					end
				end
				hideAllTicks()
				local t = store[bgTickKeys[i]]
				if t then t.Visible = true end
			end)
		end
	end
	local function pageBG(dir)
		if not sf then return end
		local w = sf.AbsoluteWindowSize.X
		if w <= 0 then w = sf.AbsoluteSize.X end
		if w <= 0 then w = 200 end
		sf.CanvasPosition = Vector2.new(math.max(0, sf.CanvasPosition.X + dir * w), 0)
	end
	if store.TextButton94 then store.TextButton94.Activated:Connect(function() pageBG(-1) end) end
	if store.TextButton95 then store.TextButton95.Activated:Connect(function() pageBG(1) end) end
end

-- ---------- 13. SAVE config button (feedback) ----------
if store.TextButton116 then
	local saveBtn = store.TextButton116
	saveBtn.Activated:Connect(function()
		local old = "SAVE"
		saveBtn.Text = "SAVED ✓"
		task.delay(1.2, function()
			pcall(function() saveBtn.Text = old end)
		end)
	end)
end

-- ---------- 14. draggable steal bar ----------
do
	local bar = store.StealBar
	if bar then
		local draggingBar = false
		local startInBar, startPosBar = nil, nil
		bar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				draggingBar = true
				startInBar = input.Position
				startPosBar = bar.Position
			end
		end)
		UIS.InputChanged:Connect(function(input)
			if not draggingBar then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local d = input.Position - startInBar
				bar.Position = UDim2.new(startPosBar.X.Scale, startPosBar.X.Offset + d.X, startPosBar.Y.Scale, startPosBar.Y.Offset + d.Y)
			end
		end)
		UIS.InputEnded:Connect(function(input)
			if input.UserInputState == Enum.UserInputState.End then draggingBar = false end
		end)
	end
end

-- ---------- 15. RESET MOBILE BUTTONS + RESET ALL CONFIG ----------
local function resetMobileButtons()
	for _, b in ipairs(mobileBtnList) do
		if b then
			local s = mbSnapshot[b]
			if s then
				b.Position = s.pos
				b.Size = s.size
			end
			local sc = b:FindFirstChildOfClass("UIScale")
			if sc then sc.Scale = 1 end
			toggleButton(b, false)
		end
	end
	if mobileStepper then mobileStepper.reset() end
	refreshMobileVisibility()
end
if store.TextButton114 then
	store.TextButton114.Activated:Connect(function()
		safely(resetMobileButtons)
	end)
end

local function resetAllConfig()
	-- toggles
	for btn, initOn in pairs(switchSnapshot) do
		local s = switchStates[btn]
		if s then setSwitch(s.key, initOn, true) end
	end
	-- selections
	for _, g in ipairs(selectionGroups) do
		for btn, snap in pairs(g.snapshot) do
			btn.BackgroundColor3 = snap.bg
			btn.TextColor3 = snap.tx
			btn.BackgroundTransparency = snap.tr
		end
		g.selected = g.buttons[1]
		for _, b in ipairs(g.buttons) do
			if b.BackgroundColor3 == SELECT_ON_BG or b.TextColor3 == SELECT_ON_TX then
				g.selected = b
				break
			end
		end
		if g.onSelect and g.selected then safely(function() g.onSelect(g.selected) end) end
	end
	-- speed rows
	selectSpeedRow(speedInitId)
	-- textboxes
	for b, txt in pairs(boxSnapshot) do
		b.Text = txt
		boxLastValid[b] = txt
	end
	refreshStealModeInfo()
	-- steppers / sliders / cyclers
	for _, s in ipairs(steppers) do safely(function() s.reset() end) end
	for _, sl in ipairs(sliders) do safely(function() sl.reset() end) end
	for _, c in ipairs(cyclers) do safely(function() c.reset() end) end
	-- keybinds
	for k in pairs(featureKeys) do featureKeys[k] = nil end
	for _, lk in ipairs({"TextLabel3","TextLabel5","TextLabel7","TextLabel21","TextLabel29","TextLabel53","TextLabel59","TextLabel68","TextLabel70","TextLabel57"}) do
		if store[lk] then store[lk].Text = "None" end
	end
	toggleKey = Enum.KeyCode.RightShift
	if keybindLabel then keybindLabel.Text = keyName(toggleKey) end
	-- mobile buttons
	resetMobileButtons()
	-- background
	if store.BackgroundImage then
		store.BackgroundImage.Image = bgSnapshot.image
		store.BackgroundImage.Visible = bgSnapshot.visible
	end
	for _, tk in ipairs({"Tick","Tick2","Tick3","Tick4","Tick5","Tick6","Tick7","Tick8","Tick9","Tick10"}) do
		if store[tk] then store[tk].Visible = false end
	end
	-- camera / lighting
	if camRef then pcall(function() camRef.FieldOfView = initCamFOV end) end
	pcall(function()
		lightRef.ClockTime = initClockTime
		lightRef.Brightness = initBrightness
	end)
	-- steal bar + ui visible
	updateStealBar(45)
	if gui then gui.Enabled = true end
end
if store.TextButton115 then
	store.TextButton115.Activated:Connect(function()
		local lbl = store.TextLabel122
		if lbl then lbl.Text = "RESETTING..." end
		safely(resetAllConfig)
		task.delay(1.0, function()
			pcall(function()
				if lbl then lbl.Text = "RESET ALL CONFIG" end
			end)
		end)
	end)
end

-- ---------- 16. live FPS + ping on the steal bar ----------
task.spawn(function()
	local RunService = game:GetService("RunService")
	local frames = 0
	pcall(function()
		RunService.RenderStepped:Connect(function()
			frames = frames + 1
		end)
	end)
	while true do
		task.wait(0.5)
		local fps = frames * 2
		frames = 0
		safely(function()
			if store.StealFps then store.StealFps.Text = "FPS: " .. tostring(fps) end
		end)
		safely(function()
			local stats = game:GetService("Stats")
			local item = stats.Network.ServerStatsItem["Data Ping"]
			local s = item:GetValueString()
			local num = tonumber(string.match(s, "([%d%.]+)"))
			if num and store.StealPing then
				store.StealPing.Text = "PING: " .. tostring(math.floor(num)) .. "ms"
			end
		end)
	end
end)