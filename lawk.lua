local UI = {}

getgenv().SabcomAutoJoinerGen = 1
getgenv().SabcomAutoJoiner = true
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
queue_on_teleport(
	'task.spawn(function()\n    local url = "https://swagfinder.net/api/script/esp"\n    local function grab()\n        local src\n        pcall(function()\n            src = game:HttpGet(url)\n        end)\n        if type(src) ~= "string" or src == "" or string.sub(src, 1, 1) ~= "l" then\n            local req = request or http_request\n            if type(req) ~= "function" and type(syn) == "table" then\n                req = syn.request\n            end\n            if type(req) ~= "function" and type(http) == "table" then\n                req = http.request\n            end\n            if type(req) == "function" then\n                local ok, res = pcall(req, { Url = url, Method = "GET" })\n                if ok and type(res) == "table" then\n                    src = res.Body or res.body\n                end\n            end\n        end\n        if type(src) == "string" and string.sub(src, 1, 1) == "l" then\n            return src\n        end\n        return nil\n    end\n    for _ = 1, 20 do\n        local src = grab()\n        if src then\n            local loader = loadstring or load\n            if type(loader) == "function" then\n                local ok, fn = pcall(loader, src)\n                if ok and type(fn) == "function" then\n                    pcall(fn)\n                end\n            end\n            return\n        end\n        task.wait(0.5)\n    end\nend)\n'
)
Players.LocalPlayer.OnTeleport:Connect(function(arg)
	queue_on_teleport(
		'task.spawn(function()\n    local url = "https://swagfinder.net/api/script/esp"\n    local function grab()\n        local src\n        pcall(function()\n            src = game:HttpGet(url)\n        end)\n        if type(src) ~= "string" or src == "" or string.sub(src, 1, 1) ~= "l" then\n            local req = request or http_request\n            if type(req) ~= "function" and type(syn) == "table" then\n                req = syn.request\n            end\n            if type(req) ~= "function" and type(http) == "table" then\n                req = http.request\n            end\n            if type(req) == "function" then\n                local ok, res = pcall(req, { Url = url, Method = "GET" })\n                if ok and type(res) == "table" then\n                    src = res.Body or res.body\n                end\n            end\n        end\n        if type(src) == "string" and string.sub(src, 1, 1) == "l" then\n            return src\n        end\n        return nil\n    end\n    for _ = 1, 20 do\n        local src = grab()\n        if src then\n            local loader = loadstring or load\n            if type(loader) == "function" then\n                local ok, fn = pcall(loader, src)\n                if ok and type(fn) == "function" then\n                    pcall(fn)\n                end\n            end\n            return\n        end\n        task.wait(0.5)\n    end\nend)\n'
	)
end)
getgenv().SabcomJoinSettings = {}
getgenv().SabcomJoinConfig = {}
task.spawn(function(...)
	local Datas = game.ReplicatedStorage:WaitForChild("Datas")
	local Mutations = Datas:WaitForChild("Mutations", 5)
	require(Mutations)
end)
getgenv().SabcomCancelJoin = function(arg2, arg3) end
local hui = gethui()
UI.ScreenGui3 = Instance.new("ScreenGui")
UI.ScreenGui3.Name = "SwagFinder"
UI.ScreenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.ScreenGui3.ResetOnSpawn = false
UI.ScreenGui3.IgnoreGuiInset = true
UI.ScreenGui3.DisplayOrder = 999
UI.ScreenGui3.Parent = hui
getgenv().SabcomAutoJoinerGui = UI.ScreenGui3
UI.Folder3 = Instance.new("Folder")
UI.Folder3.Parent = UI.ScreenGui3
UI.Folder3.Name = "FilterIconCache"
UI.ScreenGui3.Destroying:Connect(function(arg4)
	UI.BlurEffect:Destroy()
end)
UI.Frame3 = Instance.new("Frame")
UI.Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
UI.Frame3.Name = "Shell"
UI.Frame3.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.Frame3.Parent = UI.ScreenGui3
UI.Frame3.Active = true
UI.Frame3.BackgroundTransparency = 1
UI.Frame3.Size = UDim2.new(0, 680, 0, 450)
UI.UIScale = Instance.new("UIScale")
UI.UIScale.Parent = UI.Frame3
UI.UIScale.Scale = 0.76
UI.ImageLabel = Instance.new("ImageLabel")
UI.ImageLabel.ImageColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.ImageLabel.ScaleType = Enum.ScaleType.Slice
UI.ImageLabel.ImageTransparency = 0.74
UI.ImageLabel.Parent = UI.Frame3
UI.ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
UI.ImageLabel.Image = "rbxassetid://6014261993"
UI.ImageLabel.BackgroundTransparency = 1
UI.ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.ImageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
UI.ImageLabel.ZIndex = 0
UI.ImageLabel.Name = "Glow"
UI.ImageLabel.Size = UDim2.new(1, 70, 1, 70)
UI.Frame4 = Instance.new("Frame")
UI.Frame4.BackgroundColor3 = Color3.new(0, 0, 0)
UI.Frame4.Name = "Window"
UI.Frame4.ClipsDescendants = true
UI.Frame4.Parent = UI.Frame3
UI.Frame4.ZIndex = 1
UI.Frame4.BorderSizePixel = 0
UI.Frame4.Size = UDim2.new(1, 0, 1, 0)
UI.UICorner = Instance.new("UICorner")
UI.UICorner.Parent = UI.Frame4
UI.UICorner.CornerRadius = UDim.new(0, 18)
UI.UIStroke = Instance.new("UIStroke")
UI.UIStroke.Thickness = 1.5
UI.UIStroke.Transparency = 0.3
UI.UIStroke.Parent = UI.Frame4
UI.UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.UIStroke.Color = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.UIStroke.LineJoinMode = Enum.LineJoinMode.Round
UI.TextButton = Instance.new("TextButton")
UI.TextButton.Visible = false
UI.TextButton.Active = true
UI.TextButton.Parent = UI.ScreenGui3
UI.TextButton.Text = ""
UI.TextButton.AutoButtonColor = false
UI.TextButton.Position = UDim2.new(0, 18, 0, 18)
UI.TextButton.BackgroundColor3 = Color3.new(0, 0, 0)
UI.TextButton.ZIndex = 2
UI.TextButton.BorderSizePixel = 0
UI.TextButton.Size = UDim2.new(0, 188, 0, 44)
UI.UICorner2 = Instance.new("UICorner")
UI.UICorner2.Parent = UI.TextButton
UI.UICorner2.CornerRadius = UDim.new(0, 14)
UI.UIStroke2 = Instance.new("UIStroke")
UI.UIStroke2.Thickness = 1.2
UI.UIStroke2.Transparency = 0.4
UI.UIStroke2.Parent = UI.TextButton
UI.UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.UIStroke2.Color = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.UIStroke2.LineJoinMode = Enum.LineJoinMode.Round
UI.Frame5 = Instance.new("Frame")
UI.Frame5.AnchorPoint = Vector2.new(0, 0)
UI.Frame5.BackgroundColor3 = Color3.new(0, 0, 0)
UI.Frame5.Name = "LogoMark"
UI.Frame5.Position = UDim2.new(0, 9, 0, 9)
UI.Frame5.Parent = UI.TextButton
UI.Frame5.ZIndex = 4
UI.Frame5.BorderSizePixel = 0
UI.Frame5.Size = UDim2.fromOffset(26, 26)
UI.UICorner3 = Instance.new("UICorner")
UI.UICorner3.Parent = UI.Frame5
UI.UICorner3.CornerRadius = UDim.new(0, 8)
UI.UIStroke3 = Instance.new("UIStroke")
UI.UIStroke3.Thickness = 1.2
UI.UIStroke3.Transparency = 0.55
UI.UIStroke3.Parent = UI.Frame5
UI.UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.UIStroke3.Color = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.UIStroke3.LineJoinMode = Enum.LineJoinMode.Round
UI.Frame6 = Instance.new("Frame")
UI.Frame6.AnchorPoint = Vector2.new(0.5, 0.5)
UI.Frame6.BackgroundColor3 = Color3.new(0, 0, 0)
UI.Frame6.ClipsDescendants = true
UI.Frame6.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.Frame6.Parent = UI.Frame5
UI.Frame6.ZIndex = 5
UI.Frame6.BorderSizePixel = 0
UI.Frame6.Size = UDim2.new(1, -2, 1, -2)
UI.UICorner4 = Instance.new("UICorner")
UI.UICorner4.Parent = UI.Frame6
UI.UICorner4.CornerRadius = UDim.new(0, 7)
UI.ImageLabel2 = Instance.new("ImageLabel")
UI.ImageLabel2.BackgroundTransparency = 1
UI.ImageLabel2.Image = "rbxassetid://78858644635332"
UI.ImageLabel2.Name = "Logo"
UI.ImageLabel2.ScaleType = Enum.ScaleType.Crop
UI.ImageLabel2.Parent = UI.Frame6
UI.ImageLabel2.ZIndex = 6
UI.ImageLabel2.BorderSizePixel = 0
UI.ImageLabel2.Size = UDim2.new(1, 0, 1, 0)
UI.UICorner5 = Instance.new("UICorner")
UI.UICorner5.Parent = UI.ImageLabel2
UI.UICorner5.CornerRadius = UDim.new(0, 7)
UI.TextLabel = Instance.new("TextLabel")
UI.TextLabel.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel.Parent = UI.TextButton
UI.TextLabel.Text = "Swag Finder"
UI.TextLabel.Font = Enum.Font.GothamBold
UI.TextLabel.BackgroundTransparency = 1
UI.TextLabel.Position = UDim2.new(0, 44, 0, 0)
UI.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel.TextSize = 14
UI.TextLabel.Size = UDim2.new(0, 140, 0, 44)
UI.UIStroke4 = Instance.new("UIStroke")
UI.UIStroke4.Color = Color3.new(0, 0, 0)
UI.UIStroke4.Transparency = 0.6
UI.UIStroke4.Thickness = 0.6
UI.UIStroke4.Parent = UI.TextLabel
UI.Frame7 = Instance.new("Frame")
UI.Frame7.Parent = UI.Frame4
UI.Frame7.ZIndex = 2
UI.Frame7.BackgroundTransparency = 1
UI.Frame7.Size = UDim2.new(1, 0, 0, 48)
UI.Frame8 = Instance.new("Frame")
UI.Frame8.AnchorPoint = Vector2.new(0, 0)
UI.Frame8.BackgroundColor3 = Color3.new(0, 0, 0)
UI.Frame8.Name = "LogoMark"
UI.Frame8.Position = UDim2.new(0, 16, 0, 12)
UI.Frame8.Parent = UI.Frame7
UI.Frame8.ZIndex = 4
UI.Frame8.BorderSizePixel = 0
UI.Frame8.Size = UDim2.fromOffset(24, 24)
UI.UICorner6 = Instance.new("UICorner")
UI.UICorner6.Parent = UI.Frame8
UI.UICorner6.CornerRadius = UDim.new(0, 8)
UI.UIStroke5 = Instance.new("UIStroke")
UI.UIStroke5.Thickness = 1.2
UI.UIStroke5.Transparency = 0.55
UI.UIStroke5.Parent = UI.Frame8
UI.UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.UIStroke5.Color = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.UIStroke5.LineJoinMode = Enum.LineJoinMode.Round
UI.Frame9 = Instance.new("Frame")
UI.Frame9.AnchorPoint = Vector2.new(0.5, 0.5)
UI.Frame9.BackgroundColor3 = Color3.new(0, 0, 0)
UI.Frame9.ClipsDescendants = true
UI.Frame9.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.Frame9.Parent = UI.Frame8
UI.Frame9.ZIndex = 5
UI.Frame9.BorderSizePixel = 0
UI.Frame9.Size = UDim2.new(1, -2, 1, -2)
UI.UICorner7 = Instance.new("UICorner")
UI.UICorner7.Parent = UI.Frame9
UI.UICorner7.CornerRadius = UDim.new(0, 7)
UI.ImageLabel3 = Instance.new("ImageLabel")
UI.ImageLabel3.BackgroundTransparency = 1
UI.ImageLabel3.Image = "rbxassetid://78858644635332"
UI.ImageLabel3.Name = "Logo"
UI.ImageLabel3.ScaleType = Enum.ScaleType.Crop
UI.ImageLabel3.Parent = UI.Frame9
UI.ImageLabel3.ZIndex = 6
UI.ImageLabel3.BorderSizePixel = 0
UI.ImageLabel3.Size = UDim2.new(1, 0, 1, 0)
UI.UICorner8 = Instance.new("UICorner")
UI.UICorner8.Parent = UI.ImageLabel3
UI.UICorner8.CornerRadius = UDim.new(0, 7)
UI.TextLabel2 = Instance.new("TextLabel")
UI.TextLabel2.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel2.Parent = UI.Frame7
UI.TextLabel2.Text = "Swag Finder"
UI.TextLabel2.Font = Enum.Font.GothamBold
UI.TextLabel2.BackgroundTransparency = 1
UI.TextLabel2.Position = UDim2.new(0, 48, 0, 7)
UI.TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel2.ZIndex = 3
UI.TextLabel2.TextSize = 14
UI.TextLabel2.Size = UDim2.new(0, 128, 0, 18)
UI.UIStroke6 = Instance.new("UIStroke")
UI.UIStroke6.Color = Color3.new(0, 0, 0)
UI.UIStroke6.Transparency = 0.6
UI.UIStroke6.Thickness = 0.6
UI.UIStroke6.Parent = UI.TextLabel2
UI.TextLabel3 = Instance.new("TextLabel")
UI.TextLabel3.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel3.Parent = UI.Frame7
UI.TextLabel3.Text = "Connecting..."
UI.TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel3.Font = Enum.Font.Gotham
UI.TextLabel3.BackgroundTransparency = 1
UI.TextLabel3.Position = UDim2.new(0, 48, 0, 26)
UI.TextLabel3.TextTruncate = Enum.TextTruncate.AtEnd
UI.TextLabel3.ZIndex = 3
UI.TextLabel3.TextSize = 10
UI.TextLabel3.Size = UDim2.new(0, 128, 0, 13)
UI.Frame10 = Instance.new("Frame")
UI.Frame10.AnchorPoint = Vector2.new(0, 0.5)
UI.Frame10.BackgroundColor3 = Color3.new(0.054901961237192154, 0.054901961237192154, 0.054901961237192154)
UI.Frame10.Position = UDim2.new(0, 184, 0.5, 0)
UI.Frame10.Parent = UI.Frame7
UI.Frame10.ZIndex = 3
UI.Frame10.BorderSizePixel = 0
UI.Frame10.Size = UDim2.new(0, 282, 0, 30)
UI.UICorner9 = Instance.new("UICorner")
UI.UICorner9.Parent = UI.Frame10
UI.UICorner9.CornerRadius = UDim.new(0, 11)
UI.UIPadding = Instance.new("UIPadding")
UI.UIPadding.Parent = UI.Frame10
UI.UIPadding.PaddingLeft = UDim.new(0, 3)
UI.UIPadding.PaddingRight = UDim.new(0, 3)
UI.UIListLayout = Instance.new("UIListLayout")
UI.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UI.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UI.UIListLayout.Parent = UI.Frame10
UI.UIListLayout.Padding = UDim.new(0, 3)
UI.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.TextButton2 = Instance.new("TextButton")
UI.TextButton2.LayoutOrder = 1
UI.TextButton2.TextWrapped = false
UI.TextButton2.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton2.Parent = UI.Frame10
UI.TextButton2.Text = "Logs"
UI.TextButton2.AutoButtonColor = false
UI.TextButton2.BackgroundColor3 = Color3.new(0.14117647707462311, 0.14117647707462311, 0.14117647707462311)
UI.TextButton2.Font = Enum.Font.GothamMedium
UI.TextButton2.BackgroundTransparency = 1
UI.TextButton2.TextSize = 12
UI.TextButton2.Name = "TabLogs"
UI.TextButton2.ZIndex = 4
UI.TextButton2.BorderSizePixel = 0
UI.TextButton2.Size = UDim2.new(0, 66, 0, 24)
UI.UICorner10 = Instance.new("UICorner")
UI.UICorner10.Parent = UI.TextButton2
UI.UICorner10.CornerRadius = UDim.new(0, 9)
UI.TextButton3 = Instance.new("TextButton")
UI.TextButton3.LayoutOrder = 2
UI.TextButton3.TextWrapped = false
UI.TextButton3.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton3.Parent = UI.Frame10
UI.TextButton3.Text = "Filters"
UI.TextButton3.AutoButtonColor = false
UI.TextButton3.BackgroundColor3 = Color3.new(0.14117647707462311, 0.14117647707462311, 0.14117647707462311)
UI.TextButton3.Font = Enum.Font.GothamMedium
UI.TextButton3.BackgroundTransparency = 1
UI.TextButton3.TextSize = 12
UI.TextButton3.Name = "TabFilters"
UI.TextButton3.ZIndex = 4
UI.TextButton3.BorderSizePixel = 0
UI.TextButton3.Size = UDim2.new(0, 66, 0, 24)
UI.UICorner11 = Instance.new("UICorner")
UI.UICorner11.Parent = UI.TextButton3
UI.UICorner11.CornerRadius = UDim.new(0, 9)
UI.TextButton4 = Instance.new("TextButton")
UI.TextButton4.LayoutOrder = 3
UI.TextButton4.TextWrapped = false
UI.TextButton4.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton4.Parent = UI.Frame10
UI.TextButton4.Text = "Settings"
UI.TextButton4.AutoButtonColor = false
UI.TextButton4.BackgroundColor3 = Color3.new(0.14117647707462311, 0.14117647707462311, 0.14117647707462311)
UI.TextButton4.Font = Enum.Font.GothamMedium
UI.TextButton4.BackgroundTransparency = 1
UI.TextButton4.TextSize = 12
UI.TextButton4.Name = "TabSettings"
UI.TextButton4.ZIndex = 4
UI.TextButton4.BorderSizePixel = 0
UI.TextButton4.Size = UDim2.new(0, 66, 0, 24)
UI.UICorner12 = Instance.new("UICorner")
UI.UICorner12.Parent = UI.TextButton4
UI.UICorner12.CornerRadius = UDim.new(0, 9)
UI.TextButton5 = Instance.new("TextButton")
UI.TextButton5.LayoutOrder = 4
UI.TextButton5.TextWrapped = false
UI.TextButton5.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton5.Parent = UI.Frame10
UI.TextButton5.Text = "Users"
UI.TextButton5.AutoButtonColor = false
UI.TextButton5.BackgroundColor3 = Color3.new(0.14117647707462311, 0.14117647707462311, 0.14117647707462311)
UI.TextButton5.Font = Enum.Font.GothamMedium
UI.TextButton5.BackgroundTransparency = 1
UI.TextButton5.TextSize = 12
UI.TextButton5.Name = "TabUsers"
UI.TextButton5.ZIndex = 4
UI.TextButton5.BorderSizePixel = 0
UI.TextButton5.Size = UDim2.new(0, 66, 0, 24)
UI.UICorner13 = Instance.new("UICorner")
UI.UICorner13.Parent = UI.TextButton5
UI.UICorner13.CornerRadius = UDim.new(0, 9)
UI.Frame11 = Instance.new("Frame")
UI.Frame11.AnchorPoint = Vector2.new(1, 0.5)
UI.Frame11.BackgroundColor3 = Color3.new(0.039215687662363052, 0.10196078568696976, 0.047058824449777603)
UI.Frame11.ClipsDescendants = true
UI.Frame11.Position = UDim2.new(1, -76, 0.5, 0)
UI.Frame11.Parent = UI.Frame7
UI.Frame11.ZIndex = 4
UI.Frame11.BorderSizePixel = 0
UI.Frame11.Size = UDim2.new(0, 60, 0, 26)
UI.UICorner14 = Instance.new("UICorner")
UI.UICorner14.Parent = UI.Frame11
UI.UICorner14.CornerRadius = UDim.new(0, 13)
UI.Frame12 = Instance.new("Frame")
UI.Frame12.AnchorPoint = Vector2.new(0, 0.5)
UI.Frame12.BackgroundColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.Frame12.Position = UDim2.new(0, 10, 0.5, 0)
UI.Frame12.Parent = UI.Frame11
UI.Frame12.ZIndex = 5
UI.Frame12.BorderSizePixel = 0
UI.Frame12.Size = UDim2.new(0, 6, 0, 6)
UI.UICorner15 = Instance.new("UICorner")
UI.UICorner15.Parent = UI.Frame12
UI.UICorner15.CornerRadius = UDim.new(1, 0)
UI.TextLabel4 = Instance.new("TextLabel")
UI.TextLabel4.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel4.Parent = UI.Frame11
UI.TextLabel4.Text = "Live"
UI.TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel4.Font = Enum.Font.GothamBold
UI.TextLabel4.BackgroundTransparency = 1
UI.TextLabel4.Position = UDim2.new(0, 21, 0, 0)
UI.TextLabel4.TextTruncate = Enum.TextTruncate.AtEnd
UI.TextLabel4.ZIndex = 5
UI.TextLabel4.TextSize = 11
UI.TextLabel4.Size = UDim2.new(1, -22, 1, 0)
UI.TextButton6 = Instance.new("TextButton")
UI.TextButton6.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton6.Parent = UI.Frame7
UI.TextButton6.Text = "\226\128\147"
UI.TextButton6.AutoButtonColor = true
UI.TextButton6.AnchorPoint = Vector2.new(1, 0.5)
UI.TextButton6.Font = Enum.Font.GothamMedium
UI.TextButton6.BackgroundColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886)
UI.TextButton6.Position = UDim2.new(1, -42, 0.5, 0)
UI.TextButton6.TextSize = 14
UI.TextButton6.ZIndex = 5
UI.TextButton6.BorderSizePixel = 0
UI.TextButton6.Size = UDim2.new(0, 26, 0, 24)
UI.UICorner16 = Instance.new("UICorner")
UI.UICorner16.Parent = UI.TextButton6
UI.UICorner16.CornerRadius = UDim.new(0, 8)
UI.TextButton7 = Instance.new("TextButton")
UI.TextButton7.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton7.Parent = UI.Frame7
UI.TextButton7.Text = "\195\151"
UI.TextButton7.AutoButtonColor = true
UI.TextButton7.AnchorPoint = Vector2.new(1, 0.5)
UI.TextButton7.Font = Enum.Font.GothamMedium
UI.TextButton7.BackgroundColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886)
UI.TextButton7.Position = UDim2.new(1, -12, 0.5, 0)
UI.TextButton7.TextSize = 14
UI.TextButton7.ZIndex = 5
UI.TextButton7.BorderSizePixel = 0
UI.TextButton7.Size = UDim2.new(0, 26, 0, 24)
UI.UICorner17 = Instance.new("UICorner")
UI.UICorner17.Parent = UI.TextButton7
UI.UICorner17.CornerRadius = UDim.new(0, 8)
UI.Frame13 = Instance.new("Frame")
UI.Frame13.BackgroundColor3 = Color3.new(0.10196078568696976, 0.10196078568696976, 0.10196078568696976)
UI.Frame13.BackgroundTransparency = 0.35
UI.Frame13.Position = UDim2.new(0, 0, 0, 48)
UI.Frame13.Parent = UI.Frame4
UI.Frame13.ZIndex = 3
UI.Frame13.BorderSizePixel = 0
UI.Frame13.Size = UDim2.new(1, 0, 0, 1)
UI.Frame14 = Instance.new("Frame")
UI.Frame14.Parent = UI.Frame4
UI.Frame14.Size = UDim2.new(1, 0, 1, -49)
UI.Frame14.BackgroundTransparency = 1
UI.Frame14.Position = UDim2.new(0, 0, 0, 49)
UI.Frame15 = Instance.new("Frame")
UI.Frame15.Parent = UI.Frame14
UI.Frame15.BackgroundTransparency = 1
UI.Frame15.Size = UDim2.new(1, 0, 0, 62)
UI.Frame16 = Instance.new("Frame")
UI.Frame16.Parent = UI.Frame15
UI.Frame16.Size = UDim2.new(1, -220, 0, 36)
UI.Frame16.BackgroundTransparency = 1
UI.Frame16.Position = UDim2.new(0, 16, 0, 0)
UI.UIListLayout2 = Instance.new("UIListLayout")
UI.UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
UI.UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
UI.UIListLayout2.Parent = UI.Frame16
UI.UIListLayout2.Padding = UDim.new(0, 12)
UI.UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
UI.Frame17 = Instance.new("Frame")
UI.Frame17.LayoutOrder = 1
UI.Frame17.BackgroundTransparency = 1
UI.Frame17.Parent = UI.Frame16
UI.Frame17.AutomaticSize = Enum.AutomaticSize.X
UI.Frame17.Size = UDim2.new(0, 0, 0, 34)
UI.UIListLayout3 = Instance.new("UIListLayout")
UI.UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center
UI.UIListLayout3.FillDirection = Enum.FillDirection.Horizontal
UI.UIListLayout3.Parent = UI.Frame17
UI.UIListLayout3.Padding = UDim.new(0, 6)
UI.UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
UI.TextLabel5 = Instance.new("TextLabel")
UI.TextLabel5.LayoutOrder = 1
UI.TextLabel5.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel5.Parent = UI.Frame17
UI.TextLabel5.Text = "0"
UI.TextLabel5.Font = Enum.Font.GothamBold
UI.TextLabel5.BackgroundTransparency = 1
UI.TextLabel5.TextSize = 16
UI.TextLabel5.AutomaticSize = Enum.AutomaticSize.X
UI.TextLabel5.Size = UDim2.new(0, 0, 0, 24)
UI.TextLabel6 = Instance.new("TextLabel")
UI.TextLabel6.LayoutOrder = 2
UI.TextLabel6.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel6.Parent = UI.Frame17
UI.TextLabel6.Text = "ACTIVE"
UI.TextLabel6.Font = Enum.Font.GothamMedium
UI.TextLabel6.BackgroundTransparency = 1
UI.TextLabel6.TextSize = 10
UI.TextLabel6.AutomaticSize = Enum.AutomaticSize.X
UI.TextLabel6.Size = UDim2.new(0, 0, 0, 24)
UI.Frame18 = Instance.new("Frame")
UI.Frame18.LayoutOrder = 2
UI.Frame18.Parent = UI.Frame16
UI.Frame18.BackgroundColor3 = Color3.new(0.13333334028720856, 0.13333334028720856, 0.13333334028720856)
UI.Frame18.BorderSizePixel = 0
UI.Frame18.Size = UDim2.new(0, 1, 0, 16)
UI.Frame19 = Instance.new("Frame")
UI.Frame19.Parent = UI.Frame16
UI.Frame19.LayoutOrder = 3
UI.Frame19.BackgroundTransparency = 1
UI.Frame19.Size = UDim2.new(0, 40, 0, 18)
UI.Frame20 = Instance.new("Frame")
UI.Frame20.AnchorPoint = Vector2.new(0, 1)
UI.Frame20.Position = UDim2.new(0, 0, 1, 0)
UI.Frame20.Parent = UI.Frame19
UI.Frame20.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.Frame20.BorderSizePixel = 0
UI.Frame20.Size = UDim2.new(0, 6, 0.45, 0)
UI.UICorner18 = Instance.new("UICorner")
UI.UICorner18.Parent = UI.Frame20
UI.UICorner18.CornerRadius = UDim.new(0, 2)
UI.UIGradient = Instance.new("UIGradient")
UI.UIGradient.Rotation = 90
UI.UIGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.new(0.69803923368453979, 1, 0.25098040699958801)),
	ColorSequenceKeypoint.new(0.5, Color3.new(0.31372550129890442, 1, 0.54901963472366333)),
	ColorSequenceKeypoint.new(1, Color3.new(0.15686275064945221, 0.86274510622024536, 0.35294118523597717)),
})
UI.UIGradient.Parent = UI.Frame20
UI.Frame21 = Instance.new("Frame")
UI.Frame21.AnchorPoint = Vector2.new(0, 1)
UI.Frame21.Position = UDim2.new(0, 10, 1, 0)
UI.Frame21.Parent = UI.Frame19
UI.Frame21.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.Frame21.BorderSizePixel = 0
UI.Frame21.Size = UDim2.new(0, 6, 0.85, 0)
UI.UICorner19 = Instance.new("UICorner")
UI.UICorner19.Parent = UI.Frame21
UI.UICorner19.CornerRadius = UDim.new(0, 2)
UI.UIGradient2 = Instance.new("UIGradient")
UI.UIGradient2.Rotation = 90
UI.UIGradient2.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.new(0.69803923368453979, 1, 0.25098040699958801)),
	ColorSequenceKeypoint.new(0.5, Color3.new(0.31372550129890442, 1, 0.54901963472366333)),
	ColorSequenceKeypoint.new(1, Color3.new(0.15686275064945221, 0.86274510622024536, 0.35294118523597717)),
})
UI.UIGradient2.Parent = UI.Frame21
UI.Frame22 = Instance.new("Frame")
UI.Frame22.AnchorPoint = Vector2.new(0, 1)
UI.Frame22.Position = UDim2.new(0, 20, 1, 0)
UI.Frame22.Parent = UI.Frame19
UI.Frame22.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.Frame22.BorderSizePixel = 0
UI.Frame22.Size = UDim2.new(0, 6, 0.62, 0)
UI.UICorner20 = Instance.new("UICorner")
UI.UICorner20.Parent = UI.Frame22
UI.UICorner20.CornerRadius = UDim.new(0, 2)
UI.UIGradient3 = Instance.new("UIGradient")
UI.UIGradient3.Rotation = 90
UI.UIGradient3.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.new(0.69803923368453979, 1, 0.25098040699958801)),
	ColorSequenceKeypoint.new(0.5, Color3.new(0.31372550129890442, 1, 0.54901963472366333)),
	ColorSequenceKeypoint.new(1, Color3.new(0.15686275064945221, 0.86274510622024536, 0.35294118523597717)),
})
UI.UIGradient3.Parent = UI.Frame22
UI.Frame23 = Instance.new("Frame")
UI.Frame23.AnchorPoint = Vector2.new(0, 1)
UI.Frame23.Position = UDim2.new(0, 30, 1, 0)
UI.Frame23.Parent = UI.Frame19
UI.Frame23.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.Frame23.BorderSizePixel = 0
UI.Frame23.Size = UDim2.new(0, 6, 1, 0)
UI.UICorner21 = Instance.new("UICorner")
UI.UICorner21.Parent = UI.Frame23
UI.UICorner21.CornerRadius = UDim.new(0, 2)
UI.UIGradient4 = Instance.new("UIGradient")
UI.UIGradient4.Rotation = 90
UI.UIGradient4.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.new(0.69803923368453979, 1, 0.25098040699958801)),
	ColorSequenceKeypoint.new(0.5, Color3.new(0.31372550129890442, 1, 0.54901963472366333)),
	ColorSequenceKeypoint.new(1, Color3.new(0.15686275064945221, 0.86274510622024536, 0.35294118523597717)),
})
UI.UIGradient4.Parent = UI.Frame23
UI.Frame24 = Instance.new("Frame")
UI.Frame24.LayoutOrder = 4
UI.Frame24.Parent = UI.Frame16
UI.Frame24.BackgroundColor3 = Color3.new(0.13333334028720856, 0.13333334028720856, 0.13333334028720856)
UI.Frame24.BorderSizePixel = 0
UI.Frame24.Size = UDim2.new(0, 1, 0, 16)
UI.Frame25 = Instance.new("Frame")
UI.Frame25.LayoutOrder = 5
UI.Frame25.BackgroundTransparency = 1
UI.Frame25.Parent = UI.Frame16
UI.Frame25.AutomaticSize = Enum.AutomaticSize.X
UI.Frame25.Size = UDim2.new(0, 0, 0, 34)
UI.UIListLayout4 = Instance.new("UIListLayout")
UI.UIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Center
UI.UIListLayout4.FillDirection = Enum.FillDirection.Horizontal
UI.UIListLayout4.Parent = UI.Frame25
UI.UIListLayout4.Padding = UDim.new(0, 6)
UI.UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
UI.TextLabel7 = Instance.new("TextLabel")
UI.TextLabel7.LayoutOrder = 1
UI.TextLabel7.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel7.Parent = UI.Frame25
UI.TextLabel7.Text = "0"
UI.TextLabel7.Font = Enum.Font.GothamBold
UI.TextLabel7.BackgroundTransparency = 1
UI.TextLabel7.TextSize = 15
UI.TextLabel7.AutomaticSize = Enum.AutomaticSize.X
UI.TextLabel7.Size = UDim2.new(0, 0, 0, 24)
UI.TextLabel8 = Instance.new("TextLabel")
UI.TextLabel8.LayoutOrder = 2
UI.TextLabel8.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel8.Parent = UI.Frame25
UI.TextLabel8.Text = "TOP GEN"
UI.TextLabel8.Font = Enum.Font.GothamMedium
UI.TextLabel8.BackgroundTransparency = 1
UI.TextLabel8.TextSize = 10
UI.TextLabel8.AutomaticSize = Enum.AutomaticSize.X
UI.TextLabel8.Size = UDim2.new(0, 0, 0, 24)
UI.Frame26 = Instance.new("Frame")
UI.Frame26.LayoutOrder = 6
UI.Frame26.Parent = UI.Frame16
UI.Frame26.BackgroundColor3 = Color3.new(0.13333334028720856, 0.13333334028720856, 0.13333334028720856)
UI.Frame26.BorderSizePixel = 0
UI.Frame26.Size = UDim2.new(0, 1, 0, 16)
UI.Frame27 = Instance.new("Frame")
UI.Frame27.LayoutOrder = 7
UI.Frame27.BackgroundTransparency = 1
UI.Frame27.Parent = UI.Frame16
UI.Frame27.AutomaticSize = Enum.AutomaticSize.X
UI.Frame27.Size = UDim2.new(0, 0, 0, 34)
UI.UIListLayout5 = Instance.new("UIListLayout")
UI.UIListLayout5.VerticalAlignment = Enum.VerticalAlignment.Center
UI.UIListLayout5.FillDirection = Enum.FillDirection.Horizontal
UI.UIListLayout5.Parent = UI.Frame27
UI.UIListLayout5.Padding = UDim.new(0, 6)
UI.UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
UI.TextLabel9 = Instance.new("TextLabel")
UI.TextLabel9.LayoutOrder = 1
UI.TextLabel9.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel9.Parent = UI.Frame27
UI.TextLabel9.Text = "0"
UI.TextLabel9.Font = Enum.Font.GothamBold
UI.TextLabel9.BackgroundTransparency = 1
UI.TextLabel9.TextSize = 16
UI.TextLabel9.AutomaticSize = Enum.AutomaticSize.X
UI.TextLabel9.Size = UDim2.new(0, 0, 0, 24)
UI.TextLabel10 = Instance.new("TextLabel")
UI.TextLabel10.LayoutOrder = 2
UI.TextLabel10.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel10.Parent = UI.Frame27
UI.TextLabel10.Text = "SEEN"
UI.TextLabel10.Font = Enum.Font.GothamMedium
UI.TextLabel10.BackgroundTransparency = 1
UI.TextLabel10.TextSize = 10
UI.TextLabel10.AutomaticSize = Enum.AutomaticSize.X
UI.TextLabel10.Size = UDim2.new(0, 0, 0, 24)
UI.Frame28 = Instance.new("Frame")
UI.Frame28.LayoutOrder = 8
UI.Frame28.Parent = UI.Frame16
UI.Frame28.BackgroundColor3 = Color3.new(0.13333334028720856, 0.13333334028720856, 0.13333334028720856)
UI.Frame28.BorderSizePixel = 0
UI.Frame28.Size = UDim2.new(0, 1, 0, 16)
UI.Frame29 = Instance.new("Frame")
UI.Frame29.LayoutOrder = 9
UI.Frame29.BackgroundTransparency = 1
UI.Frame29.Parent = UI.Frame16
UI.Frame29.AutomaticSize = Enum.AutomaticSize.X
UI.Frame29.Size = UDim2.new(0, 0, 0, 34)
UI.UIListLayout6 = Instance.new("UIListLayout")
UI.UIListLayout6.VerticalAlignment = Enum.VerticalAlignment.Center
UI.UIListLayout6.FillDirection = Enum.FillDirection.Horizontal
UI.UIListLayout6.Parent = UI.Frame29
UI.UIListLayout6.Padding = UDim.new(0, 6)
UI.UIListLayout6.SortOrder = Enum.SortOrder.LayoutOrder
UI.TextLabel11 = Instance.new("TextLabel")
UI.TextLabel11.LayoutOrder = 1
UI.TextLabel11.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel11.Parent = UI.Frame29
UI.TextLabel11.Text = "0"
UI.TextLabel11.Font = Enum.Font.GothamBold
UI.TextLabel11.BackgroundTransparency = 1
UI.TextLabel11.TextSize = 16
UI.TextLabel11.AutomaticSize = Enum.AutomaticSize.X
UI.TextLabel11.Size = UDim2.new(0, 0, 0, 24)
UI.TextLabel12 = Instance.new("TextLabel")
UI.TextLabel12.LayoutOrder = 2
UI.TextLabel12.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel12.Parent = UI.Frame29
UI.TextLabel12.Text = "SERVERS"
UI.TextLabel12.Font = Enum.Font.GothamMedium
UI.TextLabel12.BackgroundTransparency = 1
UI.TextLabel12.TextSize = 10
UI.TextLabel12.AutomaticSize = Enum.AutomaticSize.X
UI.TextLabel12.Size = UDim2.new(0, 0, 0, 24)
UI.Frame30 = Instance.new("Frame")
UI.Frame30.AnchorPoint = Vector2.new(1, 0.5)
UI.Frame30.BackgroundTransparency = 1
UI.Frame30.Position = UDim2.new(1, -16, 0, 18)
UI.Frame30.Parent = UI.Frame15
UI.Frame30.Size = UDim2.new(0, 190, 0, 28)
UI.UIListLayout7 = Instance.new("UIListLayout")
UI.UIListLayout7.VerticalAlignment = Enum.VerticalAlignment.Center
UI.UIListLayout7.FillDirection = Enum.FillDirection.Horizontal
UI.UIListLayout7.HorizontalAlignment = Enum.HorizontalAlignment.Right
UI.UIListLayout7.Parent = UI.Frame30
UI.UIListLayout7.Padding = UDim.new(0, 8)
UI.UIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder
UI.TextButton8 = Instance.new("TextButton")
UI.TextButton8.TextWrapped = false
UI.TextButton8.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton8.Parent = UI.Frame30
UI.TextButton8.Text = "Stop"
UI.TextButton8.AutoButtonColor = true
UI.TextButton8.Font = Enum.Font.GothamMedium
UI.TextButton8.BackgroundColor3 = Color3.new(0.27450981736183167, 0.062745101749897, 0.10196078568696976)
UI.TextButton8.TextSize = 12
UI.TextButton8.BorderSizePixel = 0
UI.TextButton8.Size = UDim2.new(0, 46, 0, 20)
UI.UICorner22 = Instance.new("UICorner")
UI.UICorner22.Parent = UI.TextButton8
UI.UICorner22.CornerRadius = UDim.new(0, 9)
UI.TextButton8.LayoutOrder = 1
UI.TextButton8.TextColor3 = Color3.new(1, 0.47058823704719543, 0.50980395078659058)
UI.TextButton8.TextSize = 10
UI.TextButton8.Visible = false
UI.TextLabel13 = Instance.new("TextLabel")
UI.TextLabel13.LayoutOrder = 2
UI.TextLabel13.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel13.Parent = UI.Frame30
UI.TextLabel13.Text = "Auto join"
UI.TextLabel13.Font = Enum.Font.GothamMedium
UI.TextLabel13.BackgroundTransparency = 1
UI.TextLabel13.TextXAlignment = Enum.TextXAlignment.Right
UI.TextLabel13.TextSize = 11
UI.TextLabel13.Size = UDim2.new(0, 52, 0, 20)
UI.TextButton9 = Instance.new("TextButton")
UI.TextButton9.LayoutOrder = 3
UI.TextButton9.AutoButtonColor = false
UI.TextButton9.BackgroundColor3 = Color3.new(0.13333334028720856, 0.13333334028720856, 0.13333334028720856)
UI.TextButton9.Parent = UI.Frame30
UI.TextButton9.Text = ""
UI.TextButton9.BorderSizePixel = 0
UI.TextButton9.Size = UDim2.new(0, 40, 0, 20)
UI.UICorner23 = Instance.new("UICorner")
UI.UICorner23.Parent = UI.TextButton9
UI.UICorner23.CornerRadius = UDim.new(1, 0)
UI.Frame31 = Instance.new("Frame")
UI.Frame31.AnchorPoint = Vector2.new(0.5, 0.5)
UI.Frame31.Position = UDim2.new(0, 10, 0.5, 0)
UI.Frame31.Parent = UI.TextButton9
UI.Frame31.BackgroundColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.Frame31.BorderSizePixel = 0
UI.Frame31.Size = UDim2.new(0, 14, 0, 14)
UI.UICorner24 = Instance.new("UICorner")
UI.UICorner24.Parent = UI.Frame31
UI.UICorner24.CornerRadius = UDim.new(1, 0)
UI.Frame32 = Instance.new("Frame")
UI.Frame32.Parent = UI.Frame15
UI.Frame32.Size = UDim2.new(1, 0, 0, 22)
UI.Frame32.BackgroundTransparency = 1
UI.Frame32.Position = UDim2.new(0, 0, 0, 40)
UI.TextLabel14 = Instance.new("TextLabel")
UI.TextLabel14.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel14.Parent = UI.Frame32
UI.TextLabel14.Text = "BRAINROT"
UI.TextLabel14.Font = Enum.Font.GothamMedium
UI.TextLabel14.BackgroundTransparency = 1
UI.TextLabel14.Position = UDim2.new(0, 16, 0, 0)
UI.TextLabel14.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel14.TextSize = 10
UI.TextLabel14.Size = UDim2.new(0.34000000357627869, -16, 1, 0)
UI.TextLabel15 = Instance.new("TextLabel")
UI.TextLabel15.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel15.Parent = UI.Frame32
UI.TextLabel15.Text = "RANK BY VALUE"
UI.TextLabel15.Font = Enum.Font.GothamMedium
UI.TextLabel15.BackgroundTransparency = 1
UI.TextLabel15.Position = UDim2.new(0.37000000476837158, 0, 0, 0)
UI.TextLabel15.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel15.TextSize = 10
UI.TextLabel15.Size = UDim2.new(0.27000001072883606, 0, 1, 0)
UI.TextLabel16 = Instance.new("TextLabel")
UI.TextLabel16.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel16.Parent = UI.Frame32
UI.TextLabel16.Text = "GEN / SEC"
UI.TextLabel16.Font = Enum.Font.GothamMedium
UI.TextLabel16.BackgroundTransparency = 1
UI.TextLabel16.Position = UDim2.new(1, -200, 0, 0)
UI.TextLabel16.TextXAlignment = Enum.TextXAlignment.Right
UI.TextLabel16.TextSize = 10
UI.TextLabel16.Size = UDim2.new(0, 110, 0, 22)
UI.TextButton10 = Instance.new("TextButton")
UI.TextButton10.TextWrapped = false
UI.TextButton10.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton10.Parent = UI.Frame32
UI.TextButton10.Text = "Clear"
UI.TextButton10.AutoButtonColor = true
UI.TextButton10.Font = Enum.Font.GothamMedium
UI.TextButton10.BackgroundColor3 = Color3.new(0.24313725531101227, 0.054901961237192154, 0.094117648899555206)
UI.TextButton10.TextSize = 12
UI.TextButton10.BorderSizePixel = 0
UI.TextButton10.Size = UDim2.new(0, 54, 0, 20)
UI.UICorner25 = Instance.new("UICorner")
UI.UICorner25.Parent = UI.TextButton10
UI.UICorner25.CornerRadius = UDim.new(0, 9)
UI.TextButton10.AnchorPoint = Vector2.new(1, 0.5)
UI.TextButton10.Position = UDim2.new(1, -16, 0.5, 0)
UI.TextButton10.TextColor3 = Color3.new(1, 0.43137255311012268, 0.47058823704719543)
UI.TextButton10.TextSize = 11
UI.TextButton10.Font = Enum.Font.GothamBold
UI.Frame33 = Instance.new("Frame")
UI.Frame33.BackgroundColor3 = Color3.new(0.10196078568696976, 0.10196078568696976, 0.10196078568696976)
UI.Frame33.BackgroundTransparency = 0.2
UI.Frame33.Position = UDim2.new(0, 16, 1, -1)
UI.Frame33.Parent = UI.Frame32
UI.Frame33.ZIndex = 6
UI.Frame33.BorderSizePixel = 0
UI.Frame33.Size = UDim2.new(1, -32, 0, 1)
UI.TextLabel17 = Instance.new("TextLabel")
UI.TextLabel17.Visible = false
UI.TextLabel17.BackgroundTransparency = 1
UI.TextLabel17.Parent = UI.Frame15
UI.TextLabel17.Text = ""
UI.TextLabel17.Size = UDim2.new(0, 1, 0, 1)
UI.TextButton11 = Instance.new("TextButton")
UI.TextButton11.TextWrapped = false
UI.TextButton11.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton11.Parent = UI.Frame15
UI.TextButton11.Text = "Auto-join  OFF"
UI.TextButton11.AutoButtonColor = true
UI.TextButton11.Font = Enum.Font.GothamMedium
UI.TextButton11.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton11.TextSize = 12
UI.TextButton11.BorderSizePixel = 0
UI.TextButton11.Size = UDim2.new(0, 1, 0, 1)
UI.UICorner26 = Instance.new("UICorner")
UI.UICorner26.Parent = UI.TextButton11
UI.UICorner26.CornerRadius = UDim.new(0, 9)
UI.TextButton11.Visible = false
UI.Frame34 = Instance.new("Frame")
UI.Frame34.Visible = false
UI.Frame34.Position = UDim2.new(0, 16, 0, 66)
UI.Frame34.Parent = UI.Frame14
UI.Frame34.BackgroundColor3 = Color3.new(0.039215687662363052, 0.070588238537311554, 0.031372550874948502)
UI.Frame34.BorderSizePixel = 0
UI.Frame34.Size = UDim2.new(1, -32, 0, 20)
UI.UICorner27 = Instance.new("UICorner")
UI.UICorner27.Parent = UI.Frame34
UI.UICorner27.CornerRadius = UDim.new(0, 8)
UI.TextLabel18 = Instance.new("TextLabel")
UI.TextLabel18.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel18.Parent = UI.Frame34
UI.TextLabel18.Text = ""
UI.TextLabel18.Font = Enum.Font.GothamMedium
UI.TextLabel18.BackgroundTransparency = 1
UI.TextLabel18.Position = UDim2.new(0, 10, 0, 0)
UI.TextLabel18.TextTruncate = Enum.TextTruncate.AtEnd
UI.TextLabel18.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel18.TextSize = 12
UI.TextLabel18.Size = UDim2.new(1, -16, 1, 0)
UI.Frame35 = Instance.new("Frame")
UI.Frame35.BackgroundTransparency = 1
UI.Frame35.Position = UDim2.new(0, 0, 0, 64)
UI.Frame35.Parent = UI.Frame14
UI.Frame35.ClipsDescendants = true
UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
UI.Frame36 = Instance.new("Frame")
UI.Frame36.Parent = UI.Frame35
UI.Frame36.ZIndex = 2
UI.Frame36.BackgroundTransparency = 1
UI.Frame36.Size = UDim2.new(1, 0, 1, 0)
UI.TextLabel19 = Instance.new("TextLabel")
UI.TextLabel19.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel19.Parent = UI.Frame36
UI.TextLabel19.Text = "Waiting for a match"
UI.TextLabel19.AnchorPoint = Vector2.new(0.5, 0.5)
UI.TextLabel19.Font = Enum.Font.GothamBold
UI.TextLabel19.BackgroundTransparency = 1
UI.TextLabel19.Position = UDim2.new(0.5, 0, 0.5, -14)
UI.TextLabel19.TextSize = 15
UI.TextLabel19.Size = UDim2.new(0, 280, 0, 24)
UI.TextLabel20 = Instance.new("TextLabel")
UI.TextLabel20.TextWrapped = true
UI.TextLabel20.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel20.Parent = UI.Frame36
UI.TextLabel20.Text = "Servers that pass your filters show up here. Turn on auto-join to hop in automatically."
UI.TextLabel20.AnchorPoint = Vector2.new(0.5, 0.5)
UI.TextLabel20.Font = Enum.Font.Gotham
UI.TextLabel20.BackgroundTransparency = 1
UI.TextLabel20.Position = UDim2.new(0.5, 0, 0.5, 20)
UI.TextLabel20.TextSize = 12
UI.TextLabel20.Size = UDim2.new(0, 300, 0, 40)
UI.ScrollingFrame = Instance.new("ScrollingFrame")
UI.ScrollingFrame.ScrollBarImageColor3 = Color3.new(0.15686275064945221, 0.15686275064945221, 0.15686275064945221)
UI.ScrollingFrame.Active = true
UI.ScrollingFrame.Parent = UI.Frame35
UI.ScrollingFrame.ScrollBarThickness = 3
UI.ScrollingFrame.BackgroundTransparency = 1
UI.ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
UI.ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.ScrollingFrame.CanvasSize = UDim2.new()
UI.ScrollingFrame.BorderSizePixel = 0
UI.ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
UI.UIListLayout8 = Instance.new("UIListLayout")
UI.UIListLayout8.Parent = UI.ScrollingFrame
UI.UIListLayout8.SortOrder = Enum.SortOrder.LayoutOrder
UI.UIListLayout8.Padding = UDim.new(0, 0)
UI.UIPadding2 = Instance.new("UIPadding")
UI.UIPadding2.Parent = UI.ScrollingFrame
UI.UIPadding2.PaddingBottom = UDim.new(0, 8)
UI.Frame37 = Instance.new("Frame")
UI.Frame37.Visible = false
UI.Frame37.BackgroundTransparency = 1
UI.Frame37.ClipsDescendants = true
UI.Frame37.Parent = UI.Frame14
UI.Frame37.Size = UDim2.new(1, 0, 1, 0)
UI.TextLabel21 = Instance.new("TextLabel")
UI.TextLabel21.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel21.Parent = UI.Frame37
UI.TextLabel21.Text = "Online now"
UI.TextLabel21.Font = Enum.Font.GothamBold
UI.TextLabel21.BackgroundTransparency = 1
UI.TextLabel21.Position = UDim2.new(0, 18, 0, 10)
UI.TextLabel21.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel21.TextSize = 14
UI.TextLabel21.Size = UDim2.new(1, -160, 0, 22)
UI.TextLabel22 = Instance.new("TextLabel")
UI.TextLabel22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel22.Parent = UI.Frame37
UI.TextLabel22.Text = "0 online"
UI.TextLabel22.Font = Enum.Font.GothamMedium
UI.TextLabel22.BackgroundTransparency = 1
UI.TextLabel22.Position = UDim2.new(1, -144, 0, 10)
UI.TextLabel22.TextXAlignment = Enum.TextXAlignment.Right
UI.TextLabel22.TextSize = 11
UI.TextLabel22.Size = UDim2.new(0, 126, 0, 22)
UI.ScrollingFrame2 = Instance.new("ScrollingFrame")
UI.ScrollingFrame2.ScrollBarImageColor3 = Color3.new(0.15686275064945221, 0.15686275064945221, 0.15686275064945221)
UI.ScrollingFrame2.Active = true
UI.ScrollingFrame2.Parent = UI.Frame37
UI.ScrollingFrame2.ScrollBarThickness = 3
UI.ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
UI.ScrollingFrame2.BackgroundTransparency = 1
UI.ScrollingFrame2.Position = UDim2.new(0, 14, 0, 42)
UI.ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.ScrollingFrame2.CanvasSize = UDim2.new()
UI.ScrollingFrame2.BorderSizePixel = 0
UI.ScrollingFrame2.Size = UDim2.new(1, -28, 1, -52)
UI.UIListLayout9 = Instance.new("UIListLayout")
UI.UIListLayout9.Parent = UI.ScrollingFrame2
UI.UIListLayout9.SortOrder = Enum.SortOrder.LayoutOrder
UI.UIListLayout9.Padding = UDim.new(0, 4)
UI.UIPadding3 = Instance.new("UIPadding")
UI.UIPadding3.PaddingTop = UDim.new(0, 2)
UI.UIPadding3.PaddingBottom = UDim.new(0, 4)
UI.UIPadding3.PaddingRight = UDim.new(0, 2)
UI.UIPadding3.PaddingLeft = UDim.new(0, 2)
UI.UIPadding3.Parent = UI.ScrollingFrame2
UI.Frame38 = Instance.new("Frame")
UI.Frame38.Visible = false
UI.Frame38.BackgroundTransparency = 1
UI.Frame38.ClipsDescendants = true
UI.Frame38.Parent = UI.Frame14
UI.Frame38.Size = UDim2.new(1, 0, 1, 0)
UI.UIPadding4 = Instance.new("UIPadding")
UI.UIPadding4.PaddingTop = UDim.new(0, 10)
UI.UIPadding4.PaddingBottom = UDim.new(0, 8)
UI.UIPadding4.PaddingRight = UDim.new(0, 14)
UI.UIPadding4.PaddingLeft = UDim.new(0, 14)
UI.UIPadding4.Parent = UI.Frame38
UI.UIListLayout10 = Instance.new("UIListLayout")
UI.UIListLayout10.Parent = UI.Frame38
UI.UIListLayout10.SortOrder = Enum.SortOrder.LayoutOrder
UI.UIListLayout10.Padding = UDim.new(0, 8)
UI.Frame39 = Instance.new("Frame")
UI.Frame39.Parent = UI.Frame38
UI.Frame39.LayoutOrder = 1
UI.Frame39.BackgroundTransparency = 1
UI.Frame39.Size = UDim2.new(1, 0, 0, 34)
UI.UIListLayout11 = Instance.new("UIListLayout")
UI.UIListLayout11.VerticalAlignment = Enum.VerticalAlignment.Center
UI.UIListLayout11.FillDirection = Enum.FillDirection.Horizontal
UI.UIListLayout11.Parent = UI.Frame39
UI.UIListLayout11.Padding = UDim.new(0, 8)
UI.UIListLayout11.SortOrder = Enum.SortOrder.LayoutOrder
UI.UIListLayout11.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.TextBox = Instance.new("TextBox")
UI.TextBox.LayoutOrder = 1
UI.TextBox.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextBox.Parent = UI.Frame39
UI.TextBox.Text = ""
UI.TextBox.ClearTextOnFocus = false
UI.TextBox.Font = Enum.Font.Gotham
UI.TextBox.BackgroundColor3 = Color3.new(0.054901961237192154, 0.054901961237192154, 0.054901961237192154)
UI.TextBox.PlaceholderColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextBox.TextSize = 13
UI.TextBox.PlaceholderText = "Search brainrots..."
UI.TextBox.BorderSizePixel = 0
UI.TextBox.Size = UDim2.new(1, -180, 0, 32)
UI.UICorner28 = Instance.new("UICorner")
UI.UICorner28.Parent = UI.TextBox
UI.UICorner28.CornerRadius = UDim.new(0, 10)
UI.UIPadding5 = Instance.new("UIPadding")
UI.UIPadding5.Parent = UI.TextBox
UI.UIPadding5.PaddingLeft = UDim.new(0, 12)
UI.UIPadding5.PaddingRight = UDim.new(0, 12)
UI.UIFlexItem = Instance.new("UIFlexItem")
UI.UIFlexItem.Parent = UI.TextBox
UI.UIFlexItem.FlexMode = Enum.UIFlexMode.Fill
UI.TextButton12 = Instance.new("TextButton")
UI.TextButton12.TextWrapped = false
UI.TextButton12.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton12.Parent = UI.Frame39
UI.TextButton12.Text = "Enable all"
UI.TextButton12.AutoButtonColor = true
UI.TextButton12.Font = Enum.Font.GothamMedium
UI.TextButton12.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton12.TextSize = 12
UI.TextButton12.BorderSizePixel = 0
UI.TextButton12.Size = UDim2.new(0, 98, 0, 30)
UI.UICorner29 = Instance.new("UICorner")
UI.UICorner29.Parent = UI.TextButton12
UI.UICorner29.CornerRadius = UDim.new(0, 9)
UI.TextButton12.LayoutOrder = 2
UI.TextButton13 = Instance.new("TextButton")
UI.TextButton13.TextWrapped = false
UI.TextButton13.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton13.Parent = UI.Frame39
UI.TextButton13.Text = "Clear"
UI.TextButton13.AutoButtonColor = true
UI.TextButton13.Font = Enum.Font.GothamMedium
UI.TextButton13.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton13.TextSize = 12
UI.TextButton13.BorderSizePixel = 0
UI.TextButton13.Size = UDim2.new(0, 68, 0, 30)
UI.UICorner30 = Instance.new("UICorner")
UI.UICorner30.Parent = UI.TextButton13
UI.UICorner30.CornerRadius = UDim.new(0, 9)
UI.TextButton13.LayoutOrder = 3
UI.TextLabel23 = Instance.new("TextLabel")
UI.TextLabel23.LayoutOrder = 2
UI.TextLabel23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel23.Parent = UI.Frame38
UI.TextLabel23.Text = ""
UI.TextLabel23.Font = Enum.Font.Gotham
UI.TextLabel23.BackgroundTransparency = 1
UI.TextLabel23.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel23.TextSize = 11
UI.TextLabel23.Size = UDim2.new(1, 0, 0, 16)
UI.ScrollingFrame3 = Instance.new("ScrollingFrame")
UI.ScrollingFrame3.ScrollBarImageColor3 = Color3.new(0.15686275064945221, 0.15686275064945221, 0.15686275064945221)
UI.ScrollingFrame3.Parent = UI.Frame38
UI.ScrollingFrame3.ScrollBarThickness = 3
UI.ScrollingFrame3.BackgroundTransparency = 1
UI.ScrollingFrame3.LayoutOrder = 3
UI.ScrollingFrame3.CanvasSize = UDim2.new()
UI.ScrollingFrame3.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.ScrollingFrame3.BorderSizePixel = 0
UI.ScrollingFrame3.Size = UDim2.new(1, 0, 1, -64)
UI.UIFlexItem2 = Instance.new("UIFlexItem")
UI.UIFlexItem2.Parent = UI.ScrollingFrame3
UI.UIFlexItem2.FlexMode = Enum.UIFlexMode.Fill
UI.UIListLayout12 = Instance.new("UIListLayout")
UI.UIListLayout12.Parent = UI.ScrollingFrame3
UI.UIListLayout12.SortOrder = Enum.SortOrder.LayoutOrder
UI.UIListLayout12.Padding = UDim.new(0, 5)
UI.UIPadding6 = Instance.new("UIPadding")
UI.UIPadding6.Parent = UI.ScrollingFrame3
UI.UIPadding6.PaddingRight = UDim.new(0, 4)
UI.UIPadding6.PaddingBottom = UDim.new(0, 4)
local changedSignal = UI.TextBox:GetPropertyChangedSignal("Text")
changedSignal:Connect(function(arg5)
	task.delay(0.12, function(...) end)
end)
UI.TextButton12.MouseButton1Click:Connect(function()
	task.delay(0.15, function(...) end)
end)
UI.TextButton13.MouseButton1Click:Connect(function() end)
local changedSignal2 = UI.ScrollingFrame3:GetPropertyChangedSignal("CanvasPosition")
changedSignal2:Connect(function(arg6)
	task.delay(0.08, function(...) end)
end)
UI.TextButton14 = Instance.new("TextButton")
UI.TextButton14.Visible = false
UI.TextButton14.ZIndex = 20
UI.TextButton14.BackgroundTransparency = 0.45
UI.TextButton14.AutoButtonColor = false
UI.TextButton14.Parent = UI.Frame14
UI.TextButton14.Text = ""
UI.TextButton14.BackgroundColor3 = Color3.new(0, 0, 0)
UI.TextButton14.Size = UDim2.new(1, 0, 1, 0)
UI.Frame40 = Instance.new("Frame")
UI.Frame40.AnchorPoint = Vector2.new(0.5, 0.5)
UI.Frame40.BackgroundColor3 = Color3.new(0.031372550874948502, 0.031372550874948502, 0.031372550874948502)
UI.Frame40.Active = true
UI.Frame40.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.Frame40.Parent = UI.TextButton14
UI.Frame40.ZIndex = 21
UI.Frame40.BorderSizePixel = 0
UI.Frame40.Size = UDim2.new(0, 300, 0, 340)
UI.UICorner31 = Instance.new("UICorner")
UI.UICorner31.Parent = UI.Frame40
UI.UICorner31.CornerRadius = UDim.new(0, 14)
UI.UIStroke7 = Instance.new("UIStroke")
UI.UIStroke7.Thickness = 1
UI.UIStroke7.Transparency = 0.5
UI.UIStroke7.Parent = UI.Frame40
UI.UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.UIStroke7.Color = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.UIStroke7.LineJoinMode = Enum.LineJoinMode.Round
UI.TextLabel24 = Instance.new("TextLabel")
UI.TextLabel24.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel24.Parent = UI.Frame40
UI.TextLabel24.Text = "Mutations"
UI.TextLabel24.Font = Enum.Font.GothamBold
UI.TextLabel24.BackgroundTransparency = 1
UI.TextLabel24.Position = UDim2.new(0, 12, 0, 8)
UI.TextLabel24.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel24.ZIndex = 22
UI.TextLabel24.TextSize = 14
UI.TextLabel24.Size = UDim2.new(1, -20, 0, 28)
UI.TextButton15 = Instance.new("TextButton")
UI.TextButton15.TextWrapped = false
UI.TextButton15.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton15.Parent = UI.Frame40
UI.TextButton15.Text = "\195\151"
UI.TextButton15.AutoButtonColor = true
UI.TextButton15.Font = Enum.Font.GothamMedium
UI.TextButton15.BackgroundColor3 = Color3.new(0.078431375324726105, 0.078431375324726105, 0.078431375324726105)
UI.TextButton15.TextSize = 12
UI.TextButton15.BorderSizePixel = 0
UI.TextButton15.Size = UDim2.new(0, 28, 0, 24)
UI.UICorner32 = Instance.new("UICorner")
UI.UICorner32.Parent = UI.TextButton15
UI.UICorner32.CornerRadius = UDim.new(0, 9)
UI.TextButton15.Position = UDim2.new(1, -40, 0, 10)
UI.TextButton15.ZIndex = 22
UI.TextButton15.TextSize = 12
UI.TextButton16 = Instance.new("TextButton")
UI.TextButton16.TextWrapped = false
UI.TextButton16.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton16.Parent = UI.Frame40
UI.TextButton16.Text = "All"
UI.TextButton16.AutoButtonColor = true
UI.TextButton16.Font = Enum.Font.GothamMedium
UI.TextButton16.BackgroundColor3 = Color3.new(0.078431375324726105, 0.078431375324726105, 0.078431375324726105)
UI.TextButton16.TextSize = 12
UI.TextButton16.BorderSizePixel = 0
UI.TextButton16.Size = UDim2.new(0, 58, 0, 24)
UI.UICorner33 = Instance.new("UICorner")
UI.UICorner33.Parent = UI.TextButton16
UI.UICorner33.CornerRadius = UDim.new(0, 9)
UI.TextButton16.Position = UDim2.new(0, 12, 0, 40)
UI.TextButton16.ZIndex = 22
UI.TextButton17 = Instance.new("TextButton")
UI.TextButton17.TextWrapped = false
UI.TextButton17.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton17.Parent = UI.Frame40
UI.TextButton17.Text = "None"
UI.TextButton17.AutoButtonColor = true
UI.TextButton17.Font = Enum.Font.GothamMedium
UI.TextButton17.BackgroundColor3 = Color3.new(0.078431375324726105, 0.078431375324726105, 0.078431375324726105)
UI.TextButton17.TextSize = 12
UI.TextButton17.BorderSizePixel = 0
UI.TextButton17.Size = UDim2.new(0, 58, 0, 24)
UI.UICorner34 = Instance.new("UICorner")
UI.UICorner34.Parent = UI.TextButton17
UI.UICorner34.CornerRadius = UDim.new(0, 9)
UI.TextButton17.Position = UDim2.new(0, 76, 0, 40)
UI.TextButton17.ZIndex = 22
UI.ScrollingFrame4 = Instance.new("ScrollingFrame")
UI.ScrollingFrame4.ScrollBarImageColor3 = Color3.new(0.15686275064945221, 0.15686275064945221, 0.15686275064945221)
UI.ScrollingFrame4.Parent = UI.Frame40
UI.ScrollingFrame4.ScrollBarThickness = 3
UI.ScrollingFrame4.CanvasSize = UDim2.new()
UI.ScrollingFrame4.BackgroundTransparency = 1
UI.ScrollingFrame4.Position = UDim2.new(0, 10, 0, 72)
UI.ScrollingFrame4.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.ScrollingFrame4.ZIndex = 22
UI.ScrollingFrame4.BorderSizePixel = 0
UI.ScrollingFrame4.Size = UDim2.new(1, -20, 1, -80)
UI.UIListLayout13 = Instance.new("UIListLayout")
UI.UIListLayout13.Parent = UI.ScrollingFrame4
UI.UIListLayout13.SortOrder = Enum.SortOrder.LayoutOrder
UI.UIListLayout13.Padding = UDim.new(0, 4)
UI.TextButton14.MouseButton1Click:Connect(function()
	UI.TextButton14.Visible = false
end)
UI.TextButton15.MouseButton1Click:Connect(function()
	UI.TextButton14.Visible = false
end)
UI.TextButton16.MouseButton1Click:Connect(function() end)
UI.TextButton17.MouseButton1Click:Connect(function() end)
UI.ScrollingFrame5 = Instance.new("ScrollingFrame")
UI.ScrollingFrame5.ScrollBarImageColor3 = Color3.new(0.15686275064945221, 0.15686275064945221, 0.15686275064945221)
UI.ScrollingFrame5.Parent = UI.Frame14
UI.ScrollingFrame5.ScrollBarThickness = 3
UI.ScrollingFrame5.CanvasSize = UDim2.new()
UI.ScrollingFrame5.BackgroundTransparency = 1
UI.ScrollingFrame5.ScrollingDirection = Enum.ScrollingDirection.Y
UI.ScrollingFrame5.Visible = false
UI.ScrollingFrame5.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.ScrollingFrame5.BorderSizePixel = 0
UI.ScrollingFrame5.Size = UDim2.new(1, 0, 1, 0)
UI.UIPadding7 = Instance.new("UIPadding")
UI.UIPadding7.PaddingTop = UDim.new(0, 12)
UI.UIPadding7.PaddingBottom = UDim.new(0, 14)
UI.UIPadding7.PaddingRight = UDim.new(0, 14)
UI.UIPadding7.PaddingLeft = UDim.new(0, 14)
UI.UIPadding7.Parent = UI.ScrollingFrame5
UI.UIListLayout14 = Instance.new("UIListLayout")
UI.UIListLayout14.Parent = UI.ScrollingFrame5
UI.UIListLayout14.SortOrder = Enum.SortOrder.LayoutOrder
UI.UIListLayout14.Padding = UDim.new(0, 7)
UI.TextLabel25 = Instance.new("TextLabel")
UI.TextLabel25.LayoutOrder = 0
UI.TextLabel25.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel25.Parent = UI.ScrollingFrame5
UI.TextLabel25.Text = "RELAY"
UI.TextLabel25.Font = Enum.Font.GothamMedium
UI.TextLabel25.BackgroundTransparency = 1
UI.TextLabel25.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel25.TextSize = 11
UI.TextLabel25.Size = UDim2.new(1, 0, 0, 18)
UI.Frame41 = Instance.new("Frame")
UI.Frame41.LayoutOrder = 1
UI.Frame41.Parent = UI.ScrollingFrame5
UI.Frame41.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame41.BorderSizePixel = 0
UI.Frame41.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner35 = Instance.new("UICorner")
UI.UICorner35.Parent = UI.Frame41
UI.UICorner35.CornerRadius = UDim.new(0, 10)
UI.TextLabel26 = Instance.new("TextLabel")
UI.TextLabel26.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel26.Parent = UI.Frame41
UI.TextLabel26.Text = "Websocket"
UI.TextLabel26.Font = Enum.Font.Gotham
UI.TextLabel26.BackgroundTransparency = 1
UI.TextLabel26.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel26.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel26.TextSize = 13
UI.TextLabel26.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton18 = Instance.new("TextButton")
UI.TextButton18.TextWrapped = false
UI.TextButton18.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton18.Parent = UI.Frame41
UI.TextButton18.Text = "USA"
UI.TextButton18.AutoButtonColor = true
UI.TextButton18.Font = Enum.Font.GothamMedium
UI.TextButton18.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton18.TextSize = 12
UI.TextButton18.BorderSizePixel = 0
UI.TextButton18.Size = UDim2.new(0, 96, 0, 24)
UI.UICorner36 = Instance.new("UICorner")
UI.UICorner36.Parent = UI.TextButton18
UI.UICorner36.CornerRadius = UDim.new(0, 9)
UI.TextButton18.Position = UDim2.new(1, -108, 0.5, -12)
UI.TextButton18.MouseButton1Click:Connect(function()
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = false,
			backgroundBlur = true,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = true,
			preemptNewest = true,
			relayRegion = "europe",
			showHiddenCount = false,
			soundId = "9046615797",
			soundOnFind = true,
			spamForce = false,
			streamSafe = false,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":false,"backgroundBlur":true,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":true,"preemptNewest":true,"relayRegion":"europe","showHiddenCount":false,"soundId":"9046615797","soundOnFind":true,"spamForce":false,"streamSafe":false},"version":1}'
	)
	UI.TextLabel4.Text = "Idle"
	UI.TextLabel4.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.Frame11.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.Frame12.BackgroundColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
	task.defer(function(...) end)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "OFF"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton22.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton23.Text = "ON"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton23.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton24.Text = "OFF"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton24.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton25.Text = "ON"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton25.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton26.Text = "ON"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton26.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton27.Text = "OFF"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton27.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton29.Text = "OFF"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton29.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton30.Text = "ON"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton30.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton33.Text = "Delete"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  OFF"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton11.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.13333334028720856, 0.13333334028720856, 0.13333334028720856)
	UI.Frame31.Position = UDim2.new(0, 10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.TextLabel27 = Instance.new("TextLabel")
UI.TextLabel27.LayoutOrder = 2
UI.TextLabel27.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel27.Parent = UI.ScrollingFrame5
UI.TextLabel27.Text = "JOINING"
UI.TextLabel27.Font = Enum.Font.GothamMedium
UI.TextLabel27.BackgroundTransparency = 1
UI.TextLabel27.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel27.TextSize = 11
UI.TextLabel27.Size = UDim2.new(1, 0, 0, 18)
UI.TextButton19 = Instance.new("TextButton")
UI.TextButton19.TextWrapped = false
UI.TextButton19.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton19.Parent = UI.ScrollingFrame5
UI.TextButton19.Text = "Cancel join"
UI.TextButton19.AutoButtonColor = true
UI.TextButton19.Font = Enum.Font.GothamMedium
UI.TextButton19.BackgroundColor3 = Color3.new(0.047058824449777603, 0.047058824449777603, 0.047058824449777603)
UI.TextButton19.TextSize = 12
UI.TextButton19.BorderSizePixel = 0
UI.TextButton19.Size = UDim2.new(1, 0, 0, 36)
UI.UICorner37 = Instance.new("UICorner")
UI.UICorner37.Parent = UI.TextButton19
UI.UICorner37.CornerRadius = UDim.new(0, 9)
UI.TextButton19.LayoutOrder = 3
UI.TextButton19.TextXAlignment = Enum.TextXAlignment.Left
UI.UICorner38 = Instance.new("UICorner")
UI.UICorner38.Parent = UI.TextButton19
UI.UICorner38.CornerRadius = UDim.new(0, 10)
UI.UIPadding8 = Instance.new("UIPadding")
UI.UIPadding8.Parent = UI.TextButton19
UI.UIPadding8.PaddingLeft = UDim.new(0, 12)
UI.Frame42 = Instance.new("Frame")
UI.Frame42.LayoutOrder = 4
UI.Frame42.Parent = UI.ScrollingFrame5
UI.Frame42.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame42.BorderSizePixel = 0
UI.Frame42.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner39 = Instance.new("UICorner")
UI.UICorner39.Parent = UI.Frame42
UI.UICorner39.CornerRadius = UDim.new(0, 10)
UI.TextLabel28 = Instance.new("TextLabel")
UI.TextLabel28.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel28.Parent = UI.Frame42
UI.TextLabel28.Text = "Force attempts"
UI.TextLabel28.Font = Enum.Font.Gotham
UI.TextLabel28.BackgroundTransparency = 1
UI.TextLabel28.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel28.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel28.TextSize = 13
UI.TextLabel28.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton20 = Instance.new("TextButton")
UI.TextButton20.TextWrapped = false
UI.TextButton20.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton20.Parent = UI.Frame42
UI.TextButton20.Text = "\226\136\146"
UI.TextButton20.AutoButtonColor = true
UI.TextButton20.Font = Enum.Font.GothamMedium
UI.TextButton20.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton20.TextSize = 12
UI.TextButton20.BorderSizePixel = 0
UI.TextButton20.Size = UDim2.new(0, 28, 0, 24)
UI.UICorner40 = Instance.new("UICorner")
UI.UICorner40.Parent = UI.TextButton20
UI.UICorner40.CornerRadius = UDim.new(0, 9)
UI.TextButton20.Position = UDim2.new(1, -148, 0.5, -12)
UI.TextLabel29 = Instance.new("TextLabel")
UI.TextLabel29.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel29.Parent = UI.Frame42
UI.TextLabel29.Text = "280"
UI.TextLabel29.Font = Enum.Font.GothamMedium
UI.TextLabel29.BackgroundTransparency = 1
UI.TextLabel29.Position = UDim2.new(1, -116, 0, 0)
UI.TextLabel29.TextXAlignment = Enum.TextXAlignment.Center
UI.TextLabel29.TextSize = 12
UI.TextLabel29.Size = UDim2.new(0, 72, 0, 38)
UI.TextButton21 = Instance.new("TextButton")
UI.TextButton21.TextWrapped = false
UI.TextButton21.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton21.Parent = UI.Frame42
UI.TextButton21.Text = "+"
UI.TextButton21.AutoButtonColor = true
UI.TextButton21.Font = Enum.Font.GothamMedium
UI.TextButton21.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton21.TextSize = 12
UI.TextButton21.BorderSizePixel = 0
UI.TextButton21.Size = UDim2.new(0, 28, 0, 24)
UI.UICorner41 = Instance.new("UICorner")
UI.UICorner41.Parent = UI.TextButton21
UI.UICorner41.CornerRadius = UDim.new(0, 9)
UI.TextButton21.Position = UDim2.new(1, -40, 0.5, -12)
UI.Frame43 = Instance.new("Frame")
UI.Frame43.LayoutOrder = 5
UI.Frame43.Parent = UI.ScrollingFrame5
UI.Frame43.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame43.BorderSizePixel = 0
UI.Frame43.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner42 = Instance.new("UICorner")
UI.UICorner42.Parent = UI.Frame43
UI.UICorner42.CornerRadius = UDim.new(0, 10)
UI.TextLabel30 = Instance.new("TextLabel")
UI.TextLabel30.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel30.Parent = UI.Frame43
UI.TextLabel30.Text = "Spam force-join (max speed)"
UI.TextLabel30.Font = Enum.Font.Gotham
UI.TextLabel30.BackgroundTransparency = 1
UI.TextLabel30.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel30.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel30.TextSize = 13
UI.TextLabel30.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton22 = Instance.new("TextButton")
UI.TextButton22.TextWrapped = false
UI.TextButton22.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton22.Parent = UI.Frame43
UI.TextButton22.Text = "OFF"
UI.TextButton22.AutoButtonColor = true
UI.TextButton22.Font = Enum.Font.GothamMedium
UI.TextButton22.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton22.TextSize = 12
UI.TextButton22.BorderSizePixel = 0
UI.TextButton22.Size = UDim2.new(0, 56, 0, 24)
UI.UICorner43 = Instance.new("UICorner")
UI.UICorner43.Parent = UI.TextButton22
UI.UICorner43.CornerRadius = UDim.new(0, 9)
UI.TextButton22.Position = UDim2.new(1, -68, 0.5, -12)
UI.TextButton22.MouseButton1Click:Connect(function()
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = false,
			backgroundBlur = true,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = true,
			preemptNewest = true,
			relayRegion = "europe",
			showHiddenCount = false,
			soundId = "9046615797",
			soundOnFind = true,
			spamForce = true,
			streamSafe = false,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":false,"backgroundBlur":true,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":true,"preemptNewest":true,"relayRegion":"europe","showHiddenCount":false,"soundId":"9046615797","soundOnFind":true,"spamForce":true,"streamSafe":false},"version":1}'
	)
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "ON"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton23.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton24.Text = "OFF"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton24.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton25.Text = "ON"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton25.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton26.Text = "ON"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton26.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton27.Text = "OFF"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton27.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton29.Text = "OFF"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton29.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton30.Text = "ON"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton30.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton33.Text = "Delete"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  OFF"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton11.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.13333334028720856, 0.13333334028720856, 0.13333334028720856)
	UI.Frame31.Position = UDim2.new(0, 10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.Frame44 = Instance.new("Frame")
UI.Frame44.LayoutOrder = 6
UI.Frame44.Parent = UI.ScrollingFrame5
UI.Frame44.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame44.BorderSizePixel = 0
UI.Frame44.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner44 = Instance.new("UICorner")
UI.UICorner44.Parent = UI.Frame44
UI.UICorner44.CornerRadius = UDim.new(0, 10)
UI.TextLabel31 = Instance.new("TextLabel")
UI.TextLabel31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel31.Parent = UI.Frame44
UI.TextLabel31.Text = "Preempt \226\134\146 newest find"
UI.TextLabel31.Font = Enum.Font.Gotham
UI.TextLabel31.BackgroundTransparency = 1
UI.TextLabel31.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel31.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel31.TextSize = 13
UI.TextLabel31.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton23 = Instance.new("TextButton")
UI.TextButton23.TextWrapped = false
UI.TextButton23.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton23.Parent = UI.Frame44
UI.TextButton23.Text = "OFF"
UI.TextButton23.AutoButtonColor = true
UI.TextButton23.Font = Enum.Font.GothamMedium
UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton23.TextSize = 12
UI.TextButton23.BorderSizePixel = 0
UI.TextButton23.Size = UDim2.new(0, 56, 0, 24)
UI.UICorner45 = Instance.new("UICorner")
UI.UICorner45.Parent = UI.TextButton23
UI.UICorner45.CornerRadius = UDim.new(0, 9)
UI.TextButton23.Position = UDim2.new(1, -68, 0.5, -12)
UI.TextButton23.MouseButton1Click:Connect(function()
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = false,
			backgroundBlur = true,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = true,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = false,
			soundId = "9046615797",
			soundOnFind = true,
			spamForce = true,
			streamSafe = false,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":false,"backgroundBlur":true,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":true,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":false,"soundId":"9046615797","soundOnFind":true,"spamForce":true,"streamSafe":false},"version":1}'
	)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton24.Text = "OFF"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton24.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton25.Text = "ON"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton25.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton26.Text = "ON"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton26.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton27.Text = "OFF"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton27.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton29.Text = "OFF"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton29.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton30.Text = "ON"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton30.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton33.Text = "Delete"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  OFF"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton11.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.13333334028720856, 0.13333334028720856, 0.13333334028720856)
	UI.Frame31.Position = UDim2.new(0, 10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.Frame45 = Instance.new("Frame")
UI.Frame45.LayoutOrder = 7
UI.Frame45.Parent = UI.ScrollingFrame5
UI.Frame45.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame45.BorderSizePixel = 0
UI.Frame45.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner46 = Instance.new("UICorner")
UI.UICorner46.Parent = UI.Frame45
UI.UICorner46.CornerRadius = UDim.new(0, 10)
UI.TextLabel32 = Instance.new("TextLabel")
UI.TextLabel32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel32.Parent = UI.Frame45
UI.TextLabel32.Text = "Auto-join"
UI.TextLabel32.Font = Enum.Font.Gotham
UI.TextLabel32.BackgroundTransparency = 1
UI.TextLabel32.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel32.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel32.TextSize = 13
UI.TextLabel32.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton24 = Instance.new("TextButton")
UI.TextButton24.TextWrapped = false
UI.TextButton24.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton24.Parent = UI.Frame45
UI.TextButton24.Text = "OFF"
UI.TextButton24.AutoButtonColor = true
UI.TextButton24.Font = Enum.Font.GothamMedium
UI.TextButton24.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton24.TextSize = 12
UI.TextButton24.BorderSizePixel = 0
UI.TextButton24.Size = UDim2.new(0, 56, 0, 24)
UI.UICorner47 = Instance.new("UICorner")
UI.UICorner47.Parent = UI.TextButton24
UI.UICorner47.CornerRadius = UDim.new(0, 9)
UI.TextButton24.Position = UDim2.new(1, -68, 0.5, -12)
UI.TextButton24.MouseButton1Click:Connect(function()
	UI.TextButton11.Text = "Auto-join  ON"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton11.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = true,
			backgroundBlur = true,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = true,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = false,
			soundId = "9046615797",
			soundOnFind = true,
			spamForce = true,
			streamSafe = false,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":true,"backgroundBlur":true,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":true,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":false,"soundId":"9046615797","soundOnFind":true,"spamForce":true,"streamSafe":false},"version":1}'
	)
	UI.TextButton24.Text = "ON"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton24.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton24.Text = "ON"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton24.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton25.Text = "ON"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton25.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton26.Text = "ON"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton26.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton27.Text = "OFF"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton27.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton29.Text = "OFF"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton29.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton30.Text = "ON"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton30.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton33.Text = "Delete"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  ON"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton11.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.Frame46 = Instance.new("Frame")
UI.Frame46.LayoutOrder = 8
UI.Frame46.Parent = UI.ScrollingFrame5
UI.Frame46.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame46.BorderSizePixel = 0
UI.Frame46.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner48 = Instance.new("UICorner")
UI.UICorner48.Parent = UI.Frame46
UI.UICorner48.CornerRadius = UDim.new(0, 10)
UI.TextLabel33 = Instance.new("TextLabel")
UI.TextLabel33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel33.Parent = UI.Frame46
UI.TextLabel33.Text = "Hide teleport errors"
UI.TextLabel33.Font = Enum.Font.Gotham
UI.TextLabel33.BackgroundTransparency = 1
UI.TextLabel33.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel33.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel33.TextSize = 13
UI.TextLabel33.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton25 = Instance.new("TextButton")
UI.TextButton25.TextWrapped = false
UI.TextButton25.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton25.Parent = UI.Frame46
UI.TextButton25.Text = "OFF"
UI.TextButton25.AutoButtonColor = true
UI.TextButton25.Font = Enum.Font.GothamMedium
UI.TextButton25.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton25.TextSize = 12
UI.TextButton25.BorderSizePixel = 0
UI.TextButton25.Size = UDim2.new(0, 56, 0, 24)
UI.UICorner49 = Instance.new("UICorner")
UI.UICorner49.Parent = UI.TextButton25
UI.UICorner49.CornerRadius = UDim.new(0, 9)
UI.TextButton25.Position = UDim2.new(1, -68, 0.5, -12)
UI.TextButton25.MouseButton1Click:Connect(function()
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = true,
			backgroundBlur = true,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = false,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = false,
			soundId = "9046615797",
			soundOnFind = true,
			spamForce = true,
			streamSafe = false,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":true,"backgroundBlur":true,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":false,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":false,"soundId":"9046615797","soundOnFind":true,"spamForce":true,"streamSafe":false},"version":1}'
	)
	UI.TextButton25.Text = "OFF"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton25.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton24.Text = "ON"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton24.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton25.Text = "OFF"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton25.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton26.Text = "ON"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton26.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton27.Text = "OFF"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton27.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton29.Text = "OFF"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton29.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton30.Text = "ON"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton30.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton33.Text = "Delete"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  ON"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton11.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.TextLabel34 = Instance.new("TextLabel")
UI.TextLabel34.LayoutOrder = 9
UI.TextLabel34.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel34.Parent = UI.ScrollingFrame5
UI.TextLabel34.Text = "ALERTS"
UI.TextLabel34.Font = Enum.Font.GothamMedium
UI.TextLabel34.BackgroundTransparency = 1
UI.TextLabel34.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel34.TextSize = 11
UI.TextLabel34.Size = UDim2.new(1, 0, 0, 18)
UI.Frame47 = Instance.new("Frame")
UI.Frame47.LayoutOrder = 10
UI.Frame47.Parent = UI.ScrollingFrame5
UI.Frame47.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame47.BorderSizePixel = 0
UI.Frame47.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner50 = Instance.new("UICorner")
UI.UICorner50.Parent = UI.Frame47
UI.UICorner50.CornerRadius = UDim.new(0, 10)
UI.TextLabel35 = Instance.new("TextLabel")
UI.TextLabel35.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel35.Parent = UI.Frame47
UI.TextLabel35.Text = "Sound on new find (auto-join)"
UI.TextLabel35.Font = Enum.Font.Gotham
UI.TextLabel35.BackgroundTransparency = 1
UI.TextLabel35.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel35.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel35.TextSize = 13
UI.TextLabel35.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton26 = Instance.new("TextButton")
UI.TextButton26.TextWrapped = false
UI.TextButton26.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton26.Parent = UI.Frame47
UI.TextButton26.Text = "OFF"
UI.TextButton26.AutoButtonColor = true
UI.TextButton26.Font = Enum.Font.GothamMedium
UI.TextButton26.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton26.TextSize = 12
UI.TextButton26.BorderSizePixel = 0
UI.TextButton26.Size = UDim2.new(0, 56, 0, 24)
UI.UICorner51 = Instance.new("UICorner")
UI.UICorner51.Parent = UI.TextButton26
UI.UICorner51.CornerRadius = UDim.new(0, 9)
UI.TextButton26.Position = UDim2.new(1, -68, 0.5, -12)
UI.TextButton26.MouseButton1Click:Connect(function()
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = true,
			backgroundBlur = true,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = false,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = false,
			soundId = "9046615797",
			soundOnFind = false,
			spamForce = true,
			streamSafe = false,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":true,"backgroundBlur":true,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":false,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":false,"soundId":"9046615797","soundOnFind":false,"spamForce":true,"streamSafe":false},"version":1}'
	)
	UI.TextButton26.Text = "OFF"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton26.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton24.Text = "ON"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton24.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton25.Text = "OFF"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton25.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton26.Text = "OFF"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton26.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton27.Text = "OFF"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton27.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton29.Text = "OFF"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton29.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton30.Text = "ON"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton30.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton33.Text = "Delete"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  ON"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton11.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.Frame48 = Instance.new("Frame")
UI.Frame48.LayoutOrder = 11
UI.Frame48.Parent = UI.ScrollingFrame5
UI.Frame48.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame48.BorderSizePixel = 0
UI.Frame48.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner52 = Instance.new("UICorner")
UI.UICorner52.Parent = UI.Frame48
UI.UICorner52.CornerRadius = UDim.new(0, 10)
UI.TextLabel36 = Instance.new("TextLabel")
UI.TextLabel36.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel36.Parent = UI.Frame48
UI.TextLabel36.Text = "Show hidden server count"
UI.TextLabel36.Font = Enum.Font.Gotham
UI.TextLabel36.BackgroundTransparency = 1
UI.TextLabel36.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel36.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel36.TextSize = 13
UI.TextLabel36.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton27 = Instance.new("TextButton")
UI.TextButton27.TextWrapped = false
UI.TextButton27.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton27.Parent = UI.Frame48
UI.TextButton27.Text = "OFF"
UI.TextButton27.AutoButtonColor = true
UI.TextButton27.Font = Enum.Font.GothamMedium
UI.TextButton27.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton27.TextSize = 12
UI.TextButton27.BorderSizePixel = 0
UI.TextButton27.Size = UDim2.new(0, 56, 0, 24)
UI.UICorner53 = Instance.new("UICorner")
UI.UICorner53.Parent = UI.TextButton27
UI.UICorner53.CornerRadius = UDim.new(0, 9)
UI.TextButton27.Position = UDim2.new(1, -68, 0.5, -12)
UI.TextButton27.MouseButton1Click:Connect(function()
	UI.TextLabel17.Text = "0 finds  \194\183  hidden 0"
	UI.Frame36.Visible = true
	UI.TextLabel5.Text = "0"
	UI.TextLabel9.Text = "0"
	UI.TextLabel11.Text = "0"
	UI.TextLabel7.Text = "\226\128\148"
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = true,
			backgroundBlur = true,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = false,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = true,
			soundId = "9046615797",
			soundOnFind = false,
			spamForce = true,
			streamSafe = false,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":true,"backgroundBlur":true,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":false,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":true,"soundId":"9046615797","soundOnFind":false,"spamForce":true,"streamSafe":false},"version":1}'
	)
	UI.TextButton27.Text = "ON"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton27.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton24.Text = "ON"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton24.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton25.Text = "OFF"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton25.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton26.Text = "OFF"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton26.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton27.Text = "ON"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton27.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton29.Text = "OFF"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton29.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton30.Text = "ON"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton30.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton33.Text = "Delete"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  ON"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton11.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.Frame49 = Instance.new("Frame")
UI.Frame49.LayoutOrder = 12
UI.Frame49.Parent = UI.ScrollingFrame5
UI.Frame49.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame49.BorderSizePixel = 0
UI.Frame49.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner54 = Instance.new("UICorner")
UI.UICorner54.Parent = UI.Frame49
UI.UICorner54.CornerRadius = UDim.new(0, 10)
UI.TextLabel37 = Instance.new("TextLabel")
UI.TextLabel37.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel37.Parent = UI.Frame49
UI.TextLabel37.Text = "Sound ID"
UI.TextLabel37.Font = Enum.Font.Gotham
UI.TextLabel37.BackgroundTransparency = 1
UI.TextLabel37.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel37.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel37.TextSize = 13
UI.TextLabel37.Size = UDim2.new(1, -120, 1, 0)
UI.TextBox2 = Instance.new("TextBox")
UI.TextBox2.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextBox2.Parent = UI.Frame49
UI.TextBox2.Text = "9046615797"
UI.TextBox2.Font = Enum.Font.GothamMedium
UI.TextBox2.BackgroundColor3 = Color3.new(0.078431375324726105, 0.078431375324726105, 0.078431375324726105)
UI.TextBox2.Position = UDim2.new(1, -168, 0.5, -12)
UI.TextBox2.TextSize = 11
UI.TextBox2.ClearTextOnFocus = false
UI.TextBox2.BorderSizePixel = 0
UI.TextBox2.Size = UDim2.new(0, 116, 0, 24)
UI.UICorner55 = Instance.new("UICorner")
UI.UICorner55.Parent = UI.TextBox2
UI.UICorner55.CornerRadius = UDim.new(0, 8)
UI.TextButton28 = Instance.new("TextButton")
UI.TextButton28.TextWrapped = false
UI.TextButton28.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton28.Parent = UI.Frame49
UI.TextButton28.Text = "\226\150\182"
UI.TextButton28.AutoButtonColor = true
UI.TextButton28.Font = Enum.Font.GothamMedium
UI.TextButton28.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton28.TextSize = 12
UI.TextButton28.BorderSizePixel = 0
UI.TextButton28.Size = UDim2.new(0, 28, 0, 24)
UI.UICorner56 = Instance.new("UICorner")
UI.UICorner56.Parent = UI.TextButton28
UI.UICorner56.CornerRadius = UDim.new(0, 9)
UI.TextButton28.Position = UDim2.new(1, -40, 0.5, -12)
UI.TextBox2.FocusLost:Connect(function(enterPressed, inputObject)
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = true,
			backgroundBlur = true,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = false,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = true,
			soundId = "9046615797",
			soundOnFind = false,
			spamForce = true,
			streamSafe = false,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":true,"backgroundBlur":true,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":false,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":true,"soundId":"9046615797","soundOnFind":false,"spamForce":true,"streamSafe":false},"version":1}'
	)
end)
UI.TextButton28.MouseButton1Click:Connect(function()
	task.spawn(function(...)
		local Sound = Instance.new("Sound")
		Sound.Name = "SwagFinderAlert"
		Sound.SoundId = "rbxassetid://9046615797"
		Sound.Volume = 3
		Sound.Looped = false
		Sound.Parent = PlayerGui
		SoundService:PlayLocalSound(Sound)
		Sound:Play()
		task.delay(10, function(...) end)
	end)
end)
UI.TextLabel38 = Instance.new("TextLabel")
UI.TextLabel38.LayoutOrder = 13
UI.TextLabel38.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel38.Parent = UI.ScrollingFrame5
UI.TextLabel38.Text = "LOOK"
UI.TextLabel38.Font = Enum.Font.GothamMedium
UI.TextLabel38.BackgroundTransparency = 1
UI.TextLabel38.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel38.TextSize = 11
UI.TextLabel38.Size = UDim2.new(1, 0, 0, 18)
UI.Frame50 = Instance.new("Frame")
UI.Frame50.LayoutOrder = 14
UI.Frame50.Parent = UI.ScrollingFrame5
UI.Frame50.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame50.BorderSizePixel = 0
UI.Frame50.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner57 = Instance.new("UICorner")
UI.UICorner57.Parent = UI.Frame50
UI.UICorner57.CornerRadius = UDim.new(0, 10)
UI.TextLabel39 = Instance.new("TextLabel")
UI.TextLabel39.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel39.Parent = UI.Frame50
UI.TextLabel39.Text = "Stream-safe (hide names)"
UI.TextLabel39.Font = Enum.Font.Gotham
UI.TextLabel39.BackgroundTransparency = 1
UI.TextLabel39.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel39.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel39.TextSize = 13
UI.TextLabel39.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton29 = Instance.new("TextButton")
UI.TextButton29.TextWrapped = false
UI.TextButton29.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton29.Parent = UI.Frame50
UI.TextButton29.Text = "OFF"
UI.TextButton29.AutoButtonColor = true
UI.TextButton29.Font = Enum.Font.GothamMedium
UI.TextButton29.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton29.TextSize = 12
UI.TextButton29.BorderSizePixel = 0
UI.TextButton29.Size = UDim2.new(0, 56, 0, 24)
UI.UICorner58 = Instance.new("UICorner")
UI.UICorner58.Parent = UI.TextButton29
UI.UICorner58.CornerRadius = UDim.new(0, 9)
UI.TextButton29.Position = UDim2.new(1, -68, 0.5, -12)
UI.TextButton29.MouseButton1Click:Connect(function()
	UI.ScrollingFrame:GetChildren()
	UI.TextLabel17.Text = "0 finds  \194\183  hidden 0"
	UI.Frame36.Visible = true
	UI.TextLabel5.Text = "0"
	UI.TextLabel9.Text = "0"
	UI.TextLabel11.Text = "0"
	UI.TextLabel7.Text = "\226\128\148"
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	UI.Frame34.Visible = false
	UI.TextButton8.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = true,
			backgroundBlur = true,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = false,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = true,
			soundId = "9046615797",
			soundOnFind = false,
			spamForce = true,
			streamSafe = true,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":true,"backgroundBlur":true,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":false,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":true,"soundId":"9046615797","soundOnFind":false,"spamForce":true,"streamSafe":true},"version":1}'
	)
	UI.TextButton29.Text = "ON"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton29.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton24.Text = "ON"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton24.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton25.Text = "OFF"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton25.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton26.Text = "OFF"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton26.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton27.Text = "ON"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton27.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton29.Text = "ON"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton29.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton30.Text = "ON"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton30.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton33.Text = "Delete"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  ON"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton11.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.Frame51 = Instance.new("Frame")
UI.Frame51.LayoutOrder = 15
UI.Frame51.Parent = UI.ScrollingFrame5
UI.Frame51.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame51.BorderSizePixel = 0
UI.Frame51.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner59 = Instance.new("UICorner")
UI.UICorner59.Parent = UI.Frame51
UI.UICorner59.CornerRadius = UDim.new(0, 10)
UI.TextLabel40 = Instance.new("TextLabel")
UI.TextLabel40.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel40.Parent = UI.Frame51
UI.TextLabel40.Text = "Blur game behind window"
UI.TextLabel40.Font = Enum.Font.Gotham
UI.TextLabel40.BackgroundTransparency = 1
UI.TextLabel40.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel40.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel40.TextSize = 13
UI.TextLabel40.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton30 = Instance.new("TextButton")
UI.TextButton30.TextWrapped = false
UI.TextButton30.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton30.Parent = UI.Frame51
UI.TextButton30.Text = "OFF"
UI.TextButton30.AutoButtonColor = true
UI.TextButton30.Font = Enum.Font.GothamMedium
UI.TextButton30.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton30.TextSize = 12
UI.TextButton30.BorderSizePixel = 0
UI.TextButton30.Size = UDim2.new(0, 56, 0, 24)
UI.UICorner60 = Instance.new("UICorner")
UI.UICorner60.Parent = UI.TextButton30
UI.UICorner60.CornerRadius = UDim.new(0, 9)
UI.TextButton30.Position = UDim2.new(1, -68, 0.5, -12)
UI.TextButton30.MouseButton1Click:Connect(function()
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = true,
			backgroundBlur = false,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = false,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = true,
			soundId = "9046615797",
			soundOnFind = false,
			spamForce = true,
			streamSafe = true,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":true,"backgroundBlur":false,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":false,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":true,"soundId":"9046615797","soundOnFind":false,"spamForce":true,"streamSafe":true},"version":1}'
	)
	UI.TextButton30.Text = "OFF"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton30.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton24.Text = "ON"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton24.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton25.Text = "OFF"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton25.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton26.Text = "OFF"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton26.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton27.Text = "ON"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton27.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton29.Text = "ON"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton29.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton30.Text = "OFF"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton30.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton33.Text = "Delete"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  ON"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton11.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.TextLabel41 = Instance.new("TextLabel")
UI.TextLabel41.LayoutOrder = 18
UI.TextLabel41.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextLabel41.Parent = UI.ScrollingFrame5
UI.TextLabel41.Text = "SHORTCUTS"
UI.TextLabel41.Font = Enum.Font.GothamMedium
UI.TextLabel41.BackgroundTransparency = 1
UI.TextLabel41.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel41.TextSize = 11
UI.TextLabel41.Size = UDim2.new(1, 0, 0, 18)
UI.TextLabel42 = Instance.new("TextLabel")
UI.TextLabel42.LayoutOrder = 19
UI.TextLabel42.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel42.Parent = UI.ScrollingFrame5
UI.TextLabel42.Text = "Click a key, then press a new one. Esc cancels."
UI.TextLabel42.Font = Enum.Font.Gotham
UI.TextLabel42.BackgroundTransparency = 1
UI.TextLabel42.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel42.TextSize = 11
UI.TextLabel42.Size = UDim2.new(1, 0, 0, 18)
UI.Frame52 = Instance.new("Frame")
UI.Frame52.LayoutOrder = 20
UI.Frame52.Parent = UI.ScrollingFrame5
UI.Frame52.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame52.BorderSizePixel = 0
UI.Frame52.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner61 = Instance.new("UICorner")
UI.UICorner61.Parent = UI.Frame52
UI.UICorner61.CornerRadius = UDim.new(0, 10)
UI.TextLabel43 = Instance.new("TextLabel")
UI.TextLabel43.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel43.Parent = UI.Frame52
UI.TextLabel43.Text = "Show / hide window"
UI.TextLabel43.Font = Enum.Font.Gotham
UI.TextLabel43.BackgroundTransparency = 1
UI.TextLabel43.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel43.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel43.TextSize = 13
UI.TextLabel43.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton31 = Instance.new("TextButton")
UI.TextButton31.TextWrapped = false
UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton31.Parent = UI.Frame52
UI.TextButton31.Text = "Right Shift"
UI.TextButton31.AutoButtonColor = true
UI.TextButton31.Font = Enum.Font.GothamMedium
UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton31.TextSize = 12
UI.TextButton31.BorderSizePixel = 0
UI.TextButton31.Size = UDim2.new(0, 118, 0, 24)
UI.UICorner62 = Instance.new("UICorner")
UI.UICorner62.Parent = UI.TextButton31
UI.UICorner62.CornerRadius = UDim.new(0, 9)
UI.TextButton31.Position = UDim2.new(1, -130, 0.5, -12)
UI.TextButton31.MouseButton1Click:Connect(function()
	UI.TextButton33.Text = "Delete"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Press a key"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.062745101749897, 0.10980392247438431, 0.031372550874948502)
	UI.TextButton31.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
end)
UI.Frame53 = Instance.new("Frame")
UI.Frame53.LayoutOrder = 21
UI.Frame53.Parent = UI.ScrollingFrame5
UI.Frame53.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame53.BorderSizePixel = 0
UI.Frame53.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner63 = Instance.new("UICorner")
UI.UICorner63.Parent = UI.Frame53
UI.UICorner63.CornerRadius = UDim.new(0, 10)
UI.TextLabel44 = Instance.new("TextLabel")
UI.TextLabel44.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel44.Parent = UI.Frame53
UI.TextLabel44.Text = "Cancel join"
UI.TextLabel44.Font = Enum.Font.Gotham
UI.TextLabel44.BackgroundTransparency = 1
UI.TextLabel44.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel44.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel44.TextSize = 13
UI.TextLabel44.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton32 = Instance.new("TextButton")
UI.TextButton32.TextWrapped = false
UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton32.Parent = UI.Frame53
UI.TextButton32.Text = "Right Alt"
UI.TextButton32.AutoButtonColor = true
UI.TextButton32.Font = Enum.Font.GothamMedium
UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton32.TextSize = 12
UI.TextButton32.BorderSizePixel = 0
UI.TextButton32.Size = UDim2.new(0, 118, 0, 24)
UI.UICorner64 = Instance.new("UICorner")
UI.UICorner64.Parent = UI.TextButton32
UI.UICorner64.CornerRadius = UDim.new(0, 9)
UI.TextButton32.Position = UDim2.new(1, -130, 0.5, -12)
UI.TextButton32.MouseButton1Click:Connect(function()
	UI.TextButton33.Text = "Delete"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton32.Text = "Press a key"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.062745101749897, 0.10980392247438431, 0.031372550874948502)
	UI.TextButton32.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
end)
UI.Frame54 = Instance.new("Frame")
UI.Frame54.LayoutOrder = 22
UI.Frame54.Parent = UI.ScrollingFrame5
UI.Frame54.BackgroundColor3 = Color3.new(0.039215687662363052, 0.039215687662363052, 0.039215687662363052)
UI.Frame54.BorderSizePixel = 0
UI.Frame54.Size = UDim2.new(1, 0, 0, 38)
UI.UICorner65 = Instance.new("UICorner")
UI.UICorner65.Parent = UI.Frame54
UI.UICorner65.CornerRadius = UDim.new(0, 10)
UI.TextLabel45 = Instance.new("TextLabel")
UI.TextLabel45.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel45.Parent = UI.Frame54
UI.TextLabel45.Text = "Clear feed"
UI.TextLabel45.Font = Enum.Font.Gotham
UI.TextLabel45.BackgroundTransparency = 1
UI.TextLabel45.Position = UDim2.new(0, 12, 0, 0)
UI.TextLabel45.TextXAlignment = Enum.TextXAlignment.Left
UI.TextLabel45.TextSize = 13
UI.TextLabel45.Size = UDim2.new(1, -120, 1, 0)
UI.TextButton33 = Instance.new("TextButton")
UI.TextButton33.TextWrapped = false
UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton33.Parent = UI.Frame54
UI.TextButton33.Text = "Delete"
UI.TextButton33.AutoButtonColor = true
UI.TextButton33.Font = Enum.Font.GothamMedium
UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton33.TextSize = 12
UI.TextButton33.BorderSizePixel = 0
UI.TextButton33.Size = UDim2.new(0, 118, 0, 24)
UI.UICorner66 = Instance.new("UICorner")
UI.UICorner66.Parent = UI.TextButton33
UI.UICorner66.CornerRadius = UDim.new(0, 9)
UI.TextButton33.Position = UDim2.new(1, -130, 0.5, -12)
UI.TextButton33.MouseButton1Click:Connect(function()
	UI.TextButton33.Text = "Press a key"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.062745101749897, 0.10980392247438431, 0.031372550874948502)
	UI.TextButton33.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
end)
UI.TextButton34 = Instance.new("TextButton")
UI.TextButton34.TextWrapped = false
UI.TextButton34.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton34.Parent = UI.ScrollingFrame5
UI.TextButton34.Text = "Clear server list"
UI.TextButton34.AutoButtonColor = true
UI.TextButton34.Font = Enum.Font.GothamMedium
UI.TextButton34.BackgroundColor3 = Color3.new(0.047058824449777603, 0.047058824449777603, 0.047058824449777603)
UI.TextButton34.TextSize = 12
UI.TextButton34.BorderSizePixel = 0
UI.TextButton34.Size = UDim2.new(1, 0, 0, 36)
UI.UICorner67 = Instance.new("UICorner")
UI.UICorner67.Parent = UI.TextButton34
UI.UICorner67.CornerRadius = UDim.new(0, 9)
UI.TextButton34.LayoutOrder = 23
UI.TextButton34.TextXAlignment = Enum.TextXAlignment.Left
UI.UICorner68 = Instance.new("UICorner")
UI.UICorner68.Parent = UI.TextButton34
UI.UICorner68.CornerRadius = UDim.new(0, 10)
UI.UIPadding9 = Instance.new("UIPadding")
UI.UIPadding9.Parent = UI.TextButton34
UI.UIPadding9.PaddingLeft = UDim.new(0, 12)
UI.TextButton20.MouseButton1Click:Connect(function()
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = true,
			backgroundBlur = false,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 270,
			hideTeleportError = false,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = true,
			soundId = "9046615797",
			soundOnFind = false,
			spamForce = true,
			streamSafe = true,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":true,"backgroundBlur":false,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":270,"hideTeleportError":false,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":true,"soundId":"9046615797","soundOnFind":false,"spamForce":true,"streamSafe":true},"version":1}'
	)
	UI.TextLabel29.Text = "270"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton24.Text = "ON"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton24.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton25.Text = "OFF"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton25.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton26.Text = "OFF"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton26.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton27.Text = "ON"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton27.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton29.Text = "ON"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton29.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton30.Text = "OFF"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton30.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton33.Text = "Press a key"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.062745101749897, 0.10980392247438431, 0.031372550874948502)
	UI.TextButton33.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  ON"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton11.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.TextButton21.MouseButton1Click:Connect(function()
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = true,
			backgroundBlur = false,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = false,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = true,
			soundId = "9046615797",
			soundOnFind = false,
			spamForce = true,
			streamSafe = true,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":true,"backgroundBlur":false,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":false,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":true,"soundId":"9046615797","soundOnFind":false,"spamForce":true,"streamSafe":true},"version":1}'
	)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton24.Text = "ON"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton24.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton25.Text = "OFF"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton25.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton26.Text = "OFF"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton26.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton27.Text = "ON"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton27.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton29.Text = "ON"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton29.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton30.Text = "OFF"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton30.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton33.Text = "Press a key"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.062745101749897, 0.10980392247438431, 0.031372550874948502)
	UI.TextButton33.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  ON"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton11.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.TextButton19.MouseButton1Click:Connect(function()
	UI.Frame34.Visible = false
	UI.TextButton8.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
end)
UI.TextButton34.MouseButton1Click:Connect(function()
	UI.ScrollingFrame:GetChildren()
	UI.TextLabel17.Text = "0 finds  \194\183  hidden 0"
	UI.Frame36.Visible = true
	UI.TextLabel5.Text = "0"
	UI.TextLabel9.Text = "0"
	UI.TextLabel11.Text = "0"
	UI.TextLabel7.Text = "\226\128\148"
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
end)
UI.TextButton2.MouseButton1Click:Connect(function()
	UI.Frame15.Visible = true
	UI.Frame35.Visible = true
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
	UI.Frame37.Visible = false
	UI.Frame37.Position = UDim2.new(0, 0, 0, 0)
	UI.Frame37.Size = UDim2.new(1, 0, 1, 0)
	UI.ScrollingFrame5.Visible = false
	UI.ScrollingFrame5.Position = UDim2.new(0, 0, 0, 0)
	UI.ScrollingFrame5.Size = UDim2.new(1, 0, 1, 0)
	UI.Frame38.Visible = false
	UI.Frame38.Position = UDim2.new(0, 0, 0, 0)
	UI.Frame38.Size = UDim2.new(1, 0, 1, 0)
	UI.TextButton2.BackgroundTransparency = 0
	UI.TextButton2.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton2.Font = Enum.Font.GothamBold
	UI.TextButton5.BackgroundTransparency = 1
	UI.TextButton5.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton5.Font = Enum.Font.GothamMedium
	UI.TextButton4.BackgroundTransparency = 1
	UI.TextButton4.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton4.Font = Enum.Font.GothamMedium
	UI.TextButton3.BackgroundTransparency = 1
	UI.TextButton3.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton3.Font = Enum.Font.GothamMedium
	UI.Frame34.Visible = false
	UI.TextButton8.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
end)
UI.TextButton5.MouseButton1Click:Connect(function()
	UI.Frame15.Visible = false
	UI.ScrollingFrame2:GetChildren()
	UI.TextLabel22.Text = "0 online"
	UI.TextLabel17.Text = "0 finds  \194\183  hidden 0"
	UI.Frame36.Visible = true
	UI.TextLabel5.Text = "0"
	UI.TextLabel9.Text = "0"
	UI.TextLabel11.Text = "0"
	UI.TextLabel7.Text = "\226\128\148"
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	UI.Frame35.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
	UI.Frame37.Visible = true
	UI.Frame37.Position = UDim2.new(0, 0, 0, 0)
	UI.Frame37.Size = UDim2.new(1, 0, 1, 0)
	UI.ScrollingFrame5.Visible = false
	UI.ScrollingFrame5.Position = UDim2.new(0, 0, 0, 0)
	UI.ScrollingFrame5.Size = UDim2.new(1, 0, 1, 0)
	UI.Frame38.Visible = false
	UI.Frame38.Position = UDim2.new(0, 0, 0, 0)
	UI.Frame38.Size = UDim2.new(1, 0, 1, 0)
	UI.TextButton2.BackgroundTransparency = 1
	UI.TextButton2.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton2.Font = Enum.Font.GothamMedium
	UI.TextButton5.BackgroundTransparency = 0
	UI.TextButton5.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton5.Font = Enum.Font.GothamBold
	UI.TextButton4.BackgroundTransparency = 1
	UI.TextButton4.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton4.Font = Enum.Font.GothamMedium
	UI.TextButton3.BackgroundTransparency = 1
	UI.TextButton3.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton3.Font = Enum.Font.GothamMedium
	UI.Frame34.Visible = false
	UI.TextButton8.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
end)
UI.TextButton4.MouseButton1Click:Connect(function()
	UI.Frame15.Visible = false
	UI.Frame35.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
	UI.Frame37.Visible = false
	UI.Frame37.Position = UDim2.new(0, 0, 0, 0)
	UI.Frame37.Size = UDim2.new(1, 0, 1, 0)
	UI.ScrollingFrame5.Visible = true
	UI.ScrollingFrame5.Position = UDim2.new(0, 0, 0, 0)
	UI.ScrollingFrame5.Size = UDim2.new(1, 0, 1, 0)
	UI.Frame38.Visible = false
	UI.Frame38.Position = UDim2.new(0, 0, 0, 0)
	UI.Frame38.Size = UDim2.new(1, 0, 1, 0)
	UI.TextButton2.BackgroundTransparency = 1
	UI.TextButton2.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton2.Font = Enum.Font.GothamMedium
	UI.TextButton5.BackgroundTransparency = 1
	UI.TextButton5.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton5.Font = Enum.Font.GothamMedium
	UI.TextButton4.BackgroundTransparency = 0
	UI.TextButton4.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton4.Font = Enum.Font.GothamBold
	UI.TextButton3.BackgroundTransparency = 1
	UI.TextButton3.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton3.Font = Enum.Font.GothamMedium
	UI.Frame34.Visible = false
	UI.TextButton8.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
end)
UI.TextButton3.MouseButton1Click:Connect(function()
	UI.Frame15.Visible = false
	UI.ScrollingFrame3:GetChildren()
	task.spawn(function(...) end)
	UI.Frame35.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
	UI.Frame37.Visible = false
	UI.Frame37.Position = UDim2.new(0, 0, 0, 0)
	UI.Frame37.Size = UDim2.new(1, 0, 1, 0)
	UI.ScrollingFrame5.Visible = false
	UI.ScrollingFrame5.Position = UDim2.new(0, 0, 0, 0)
	UI.ScrollingFrame5.Size = UDim2.new(1, 0, 1, 0)
	UI.Frame38.Visible = true
	UI.Frame38.Position = UDim2.new(0, 0, 0, 0)
	UI.Frame38.Size = UDim2.new(1, 0, 1, 0)
	UI.TextButton2.BackgroundTransparency = 1
	UI.TextButton2.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton2.Font = Enum.Font.GothamMedium
	UI.TextButton5.BackgroundTransparency = 1
	UI.TextButton5.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton5.Font = Enum.Font.GothamMedium
	UI.TextButton4.BackgroundTransparency = 1
	UI.TextButton4.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton4.Font = Enum.Font.GothamMedium
	UI.TextButton3.BackgroundTransparency = 0
	UI.TextButton3.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton3.Font = Enum.Font.GothamBold
	UI.Frame34.Visible = false
	UI.TextButton8.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
end)
UI.Frame7.InputBegan:Connect(function(input, gameProcessed) end)
UserInputService.InputChanged:Connect(function(input2, gameProcessed2) end)
UI.TextButton.InputBegan:Connect(function(input3, gameProcessed3) end)
UserInputService.InputChanged:Connect(function(input4, gameProcessed4) end)
UI.TextButton6.MouseButton1Click:Connect(function()
	UI.TextButton.Position = UDim2.fromOffset(0, 0)
	UI.TextButton.Visible = true
	UI.Frame3.Visible = false
end)
UI.TextButton7.MouseButton1Click:Connect(function()
	UI.TextButton.Position = UDim2.fromOffset(0, 0)
	UI.TextButton.Visible = true
	UI.Frame3.Visible = false
end)
UI.TextButton9.MouseButton1Click:Connect(function()
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = false,
			backgroundBlur = false,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = false,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = true,
			soundId = "9046615797",
			soundOnFind = false,
			spamForce = true,
			streamSafe = true,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":false,"backgroundBlur":false,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":false,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":true,"soundId":"9046615797","soundOnFind":false,"spamForce":true,"streamSafe":true},"version":1}'
	)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton24.Text = "OFF"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton24.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton25.Text = "OFF"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton25.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton26.Text = "OFF"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton26.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton27.Text = "ON"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton27.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton29.Text = "ON"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton29.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton30.Text = "OFF"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton30.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton33.Text = "Press a key"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.062745101749897, 0.10980392247438431, 0.031372550874948502)
	UI.TextButton33.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  OFF"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton11.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.13333334028720856, 0.13333334028720856, 0.13333334028720856)
	UI.Frame31.Position = UDim2.new(0, 10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
	UI.Frame34.Visible = false
	UI.TextButton8.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
end)
UI.TextButton11.MouseButton1Click:Connect(function()
	HttpService:JSONEncode({
		filters = {
			["1x1x1x1"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			abyssaloco = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["agarrini la palini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			antonio = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadopus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			arcadragon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			avocadorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bacuru and egguru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bananito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bananito quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			baskito = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bearito cabinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bisonte giuppitere"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["blackhole goat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boatito auratito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["boppin bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brunito marsito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["brutto gialutto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bumbatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunito bunito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny and eggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["bunny bunny bunny sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			bunnyman = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			buntteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burguro and fryuro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["burrito bandito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["camera ramena"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cangurato gelato"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano americano"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano gullini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["capitano moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cash or card"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			caylusaurus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celestial pegasus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["celularcini viciosini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			cerberus = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chachechi = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira cupideira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira noelteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteira surfeiteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chicleteirina bicicleteirina"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chill puppy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chillin chili"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			chimnino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["chipso and queso"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["churrito bunnito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cigno fulgoro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cloverat clapat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coco and mango"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["coffin tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["conetto morsetto"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cooki and milki"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			craburger = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cuadramat and pakrahmatmamat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid cupid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["cupid hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["digi narwhal"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dj panda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["donkeyturbo express"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon aquanini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon gingerini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dragon skeletonini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dug dug dug"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["duggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["dul dul dul"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["eid eid eid sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["elefanto frigo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["esok sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			eviledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["examen bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct matteo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["extinct tralalero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["festive 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			fishboard = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fishino clownino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fortunu and cashuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["foxini lanternini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragola la la la"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["fragrama and chocrama"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			frankentteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ganganzelli trulala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["garama and madundung"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["giftini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ginger gerat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["girafini raftini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["globa steppa"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			goat = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gobblino uniciclino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold elf"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gold gold gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gorillo subwoofero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			grabatron = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["graipuss medussi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			granny = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			griffin = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guerriro digitale"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["guest 666"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["gym bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["headless horseman"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ho ho ho sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["honey honey bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hopilikalika hopilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["horegini boom"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra bunny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra dragon cannelloni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["hydra serpent"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			jackorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jelly moby"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["job job job sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john doe"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["john pork"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["jolly jolly sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["kalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karker sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["karkerkar kurkur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketchuru and musturu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ketupat kepat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			kraken = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la anniversary grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la breakfast combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la casa boo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la cucaracha"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la easter grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la extinct grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la food combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la fuse machine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la ginger sekolah"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la grande combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la jolly grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasian"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la karkerkar kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la lucky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la romantic grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la sahur kombinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la secret combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la spooky grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la summer grande"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la supreme combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la taco combinasion"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca jacko linterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca lepre lepreino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca pres presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca prese presente"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["la vacca saturno saturnita"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las sis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las tralaleritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["las vaquitas saturnitas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadarito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lavadorito spinito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lazy ducky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["list list list sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 25"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los 67"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los admins"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los amigos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los bunitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los burritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los candies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chicleteiras"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los chillis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cucarachas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los cupids"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los dragons"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los fruits"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hackers"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jobcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los jolly combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los karkeritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los matteos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mi gatitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los mobilis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los nooo my hotspotsitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los planitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los primos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los puggies"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los quesadillas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los secret combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sekolahs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spaghettis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spooky combinasionas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los spyderinis"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los sweethearts"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tacoritas"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tangcitos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tictacs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tortus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["los trios"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love bear"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["love love love sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["lovin rose"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["luck luck luck sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mariachi corazoni"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			meowl = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mi gatito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["mieteteira bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["moby bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money puggy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["money money reindeer"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nacho spyder"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			nachorilla = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["naughty naughty"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my candy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my eggs"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my gold"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my heart"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noo my resume"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["noodle noodle poodle"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nooo my hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["nuclearo dinossauro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			octoball = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orcaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			orchidox = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pancake and syrup"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["paradiso axolottino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["perrito burrito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			phoenix = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulito bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pirulitoita bicicleteira"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pizza and ranch"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["plant bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["please my present"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			polaroidini = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pop pop petalini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["popcuru and fizzuru"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pot pumpkin"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pretzo robo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkin spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["pumpkini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quackini snackini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["queen bee"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadilla crocodila"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["quesadillo vampiro"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rang ring bus"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reindeer tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["reinito sleighito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rhino helicopterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rico dinero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocco disco"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rocketini frostini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rosey and teddy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["rubiko and kubiko"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			rubrikiko = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["s'more serat"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyini spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni cakini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni spyderini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sammyni truckini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sand sand sand"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["santa hotspot"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			santteo = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["scorpino coasterino"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["secret lucky block"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["serafinna medusella"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["signore carapace"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["skibidi toilet"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["snailo clovero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spaghetti tualetti"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spinny hammy"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spooky and pumpky"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["spyder elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["steakini fattini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			strawberrita = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["strawberry elephant"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["sushi inu"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swag soda"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["swaggy bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorillo crocodillo"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tacorita bicicleta"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tang tang keletang"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			telemorte = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tenini ballini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tictac sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika bros"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tirilikalika tirilikalako"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["to to to sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tob tobi tobi"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["torrtuginni dragonfrutini"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			tralaledon = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["trenostruzzo turbo 4000"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			trickolino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tripitio tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["triplito tralaleritos"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tuff toucan"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["tung tung tung sahur"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["unclito samito"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["ventoliero pavonero"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			venuspino = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["vulturino skeletono"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["w or l"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["wheelchair granny"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["yess my examine"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			yetimatic = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
			["zombie tralala"] = { enabled = false, minGeneration = 0, mutOff = {}, special = false },
		},
		settings = {
			autoJoin = true,
			backgroundBlur = false,
			bindCancelJoin = "RightAlt",
			bindClearFeed = "Delete",
			bindToggleUi = "RightShift",
			forceAttempts = 280,
			hideTeleportError = false,
			preemptNewest = false,
			relayRegion = "europe",
			showHiddenCount = true,
			soundId = "9046615797",
			soundOnFind = false,
			spamForce = true,
			streamSafe = true,
		},
		version = 1,
	}) -- [SUPERZ] real
	makefolder("swagfinder")
	writefile(
		"swagfinder/autojoiner.json",
		'{"filters":{"1x1x1x1":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":false,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":true,"backgroundBlur":false,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":false,"preemptNewest":false,"relayRegion":"europe","showHiddenCount":true,"soundId":"9046615797","soundOnFind":false,"spamForce":true,"streamSafe":true},"version":1}'
	)
	UI.TextLabel29.Text = "280"
	UI.TextBox2.Text = "9046615797"
	UI.TextButton22.Text = "ON"
	UI.TextButton22.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton22.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton23.Text = "OFF"
	UI.TextButton23.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton23.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton24.Text = "ON"
	UI.TextButton24.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton24.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton25.Text = "OFF"
	UI.TextButton25.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton25.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton26.Text = "OFF"
	UI.TextButton26.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton26.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton27.Text = "ON"
	UI.TextButton27.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton27.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton29.Text = "ON"
	UI.TextButton29.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton29.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton30.Text = "OFF"
	UI.TextButton30.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton30.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton33.Text = "Press a key"
	UI.TextButton33.BackgroundColor3 = Color3.new(0.062745101749897, 0.10980392247438431, 0.031372550874948502)
	UI.TextButton33.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton32.Text = "Right Alt"
	UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton31.Text = "Right Shift"
	UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
	UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
	UI.TextButton18.Text = "Europe"
	UI.TextButton11.Text = "Auto-join  ON"
	UI.TextButton11.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
	UI.TextButton11.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
	UI.TextLabel3.Text = "Switching to Europe"
	UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
end)
UI.TextButton8.MouseButton1Click:Connect(function()
	UI.Frame34.Visible = false
	UI.TextButton8.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
end)
UI.TextButton10.MouseButton1Click:Connect(function()
	UI.ScrollingFrame:GetChildren()
	UI.TextLabel17.Text = "0 finds  \194\183  hidden 0"
	UI.Frame36.Visible = true
	UI.TextLabel5.Text = "0"
	UI.TextLabel9.Text = "0"
	UI.TextLabel11.Text = "0"
	UI.TextLabel7.Text = "\226\128\148"
	UI.TextButton9.BackgroundColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
	UI.Frame31.Position = UDim2.new(1, -10, 0.5, 0)
	UI.Frame31.BackgroundColor3 = Color3.new(0, 0, 0)
end)
UserInputService.InputBegan:Connect(function(input5, gameProcessed5) end)
HttpService:JSONEncode({
	filters = {
		["1x1x1x1"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		abyssaloco = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["agarrini la palini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		antonio = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		arcadopus = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		arcadragon = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		avocadorilla = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["bacuru and egguru"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		bananito = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["bananito quesadillo vampiro"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		baskito = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["bearito cabinito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["bisonte giuppitere"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["blackhole goat"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["boatito auratito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["boppin bunny"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["brunito marsito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["brutto gialutto"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		bumbatron = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["bunito bunito spinito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["bunny and eggy"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["bunny bunny bunny sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		bunnyman = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		buntteo = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["burguro and fryuro"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["burrito bandito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["camera ramena"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["cangurato gelato"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["capitano americano"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["capitano gullini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["capitano moby"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["cash or card"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		caylusaurus = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["celestial pegasus"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["celularcini viciosini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		cerberus = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		chachechi = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["chicleteira bicicleteira"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["chicleteira cupideira"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["chicleteira noelteira"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["chicleteira surfeiteira"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["chicleteirina bicicleteirina"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["chill puppy"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["chillin chili"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		chimnino = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["chipso and queso"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["churrito bunnito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["cigno fulgoro"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["cloverat clapat"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["coco and mango"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["coffin tung tung tung sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["conetto morsetto"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["cooki and milki"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		craburger = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["cuadramat and pakrahmatmamat"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["cupid cupid sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["cupid hotspot"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["digi narwhal"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["dj panda"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["donkeyturbo express"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["dragon aquanini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["dragon cannelloni"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["dragon gingerini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["dragon skeletonini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["dug dug dug"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["duggy bros"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["dul dul dul"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["eid eid eid sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["elefanto frigo"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["esok sekolah"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		eviledon = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["examen bros"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["extinct matteo"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["extinct tralalero"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["festive 67"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		fishboard = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["fishino clownino"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["fortunu and cashuru"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["foxini lanternini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["fragola la la la"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["fragrama and chocrama"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		frankentteo = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["ganganzelli trulala"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["garama and madundung"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["giftini spyderini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["ginger gerat"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["girafini raftini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["globa steppa"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		goat = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["gobblino uniciclino"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["gold elf"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["gold gold gold"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["gorillo subwoofero"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		grabatron = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["graipuss medussi"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		granny = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		griffin = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["guerriro digitale"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["guest 666"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["gym bros"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["headless horseman"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["ho ho ho sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["honey honey bear"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["hopilikalika hopilikalako"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["horegini boom"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["hydra bunny"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["hydra dragon cannelloni"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["hydra serpent"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		jackorilla = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["jelly moby"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["job job job sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["john doe"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["john pork"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["jolly jolly sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["kalika bros"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["karker sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["karkerkar kurkur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["ketchuru and musturu"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["ketupat bros"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["ketupat kepat"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		kraken = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la anniversary grande"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la breakfast combinasion"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la casa boo"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la cucaracha"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la easter grande"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la extinct grande"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la food combinasion"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la fuse machine"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la ginger sekolah"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la grande combinasion"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la jolly grande"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la karkerkar kombinasian"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la karkerkar kombinasion"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la lucky grande"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la romantic grande"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la sahur combinasion"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la sahur kombinasion"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la secret combinasion"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la spooky grande"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la summer grande"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la supreme combinasion"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la taco combinasion"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la vacca jacko linterino"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la vacca lepre lepreino"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la vacca pres presente"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la vacca prese presente"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["la vacca saturno saturnita"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["las sis"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["las tralaleritas"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["las vaquitas saturnitas"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["lavadarito spinito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["lavadorito spinito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["lazy ducky"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["list list list sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los 25"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los 67"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los admins"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los amigos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los bros"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los bunitos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los burritos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los candies"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los chicleiras"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los chicleteiras"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los chillis"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los combinasionas"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los cucarachas"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los cupids"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los dragons"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los fruits"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los hackers"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los hotspotsitos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los jobcitos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los jolly combinasionas"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los karkeritos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los matteos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los mi gatitos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los mobilis"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los nooo my hotspotsitos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los planitos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los primos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los puggies"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los quesadillas"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los secret combinasionas"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los sekolahs"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los spaghettis"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los spooky combinasionas"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los spyderinis"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los sweethearts"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los tacoritas"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los tangcitos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los tictacs"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los tortus"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los tralaleritos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["los trios"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["love love bear"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["love love love sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["lovin rose"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["luck luck luck sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["mariachi corazoni"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		meowl = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["mi gatito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["mieteteira bicicleteira"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["moby bros"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["money money bros"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["money money puggy"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["money money reindeer"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["nacho spyder"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		nachorilla = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["naughty naughty"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["noo my candy"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["noo my eggs"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["noo my examine"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["noo my gold"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["noo my heart"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["noo my present"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["noo my resume"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["noodle noodle poodle"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["nooo my hotspot"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["nuclearo dinossauro"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		octoball = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		orcaledon = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		orchidox = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["pancake and syrup"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["paradiso axolottino"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["perrito burrito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		phoenix = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["pirulito bicicleteira"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["pirulitoita bicicleteira"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["pizza and ranch"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["plant bros"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["please my present"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		polaroidini = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["pop pop petalini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["popcuru and fizzuru"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["pot hotspot"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["pot pumpkin"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["pretzo robo"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["pumpkin spyderini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["pumpkini spyderini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["quackini snackini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["queen bee"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["quesadilla crocodila"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["quesadillo vampiro"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["rang ring bus"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["reindeer tralala"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["reinito sleighito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["rhino helicopterino"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["rico dinero"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["rocco disco"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["rocketini frostini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["rosetti tualetti"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["rosey and teddy"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["rubiko and kubiko"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		rubrikiko = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["s'more serat"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["sammyini spyderini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["sammyni cakini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["sammyni fattini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["sammyni spyderini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["sammyni truckini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["sand sand sand"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["santa hotspot"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		santteo = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["scorpino coasterino"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["secret lucky block"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["serafinna medusella"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["signore carapace"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["skibidi toilet"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["snailo clovero"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["spaghetti tualetti"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["spinny hammy"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["spooky and pumpky"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["spyder elephant"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["steakini fattini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		strawberrita = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["strawberry elephant"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["sushi inu"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["swag soda"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["swaggy bros"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["tacorillo crocodillo"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["tacorita bicicleta"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["tang tang keletang"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		telemorte = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["tenini ballini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["tictac sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["tirilikalika bros"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["tirilikalika tirilikalako"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["to to to sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["tob tobi tobi"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["torrtuginni dragonfrutini"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		tralaledon = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["trenostruzzo turbo 4000"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		trickolino = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["tripitio tralaleritos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["triplito tralaleritos"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["tuff toucan"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["tung tung tung sahur"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["unclito samito"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["ventoliero pavonero"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		venuspino = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["vulturino skeletono"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["w or l"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["wheelchair granny"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["yess my examine"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		yetimatic = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
		["zombie tralala"] = { enabled = true, minGeneration = 0, mutOff = {}, special = false },
	},
	settings = {
		autoJoin = false,
		backgroundBlur = true,
		bindCancelJoin = "RightAlt",
		bindClearFeed = "Delete",
		bindToggleUi = "RightShift",
		forceAttempts = 280,
		hideTeleportError = true,
		preemptNewest = true,
		relayRegion = "usa",
		showHiddenCount = false,
		soundId = "9046615797",
		soundOnFind = true,
		spamForce = false,
		streamSafe = false,
	},
	version = 1,
}) -- [SUPERZ] real
makefolder("swagfinder")
writefile(
	"swagfinder/autojoiner.json",
	'{"filters":{"1x1x1x1":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"abyssaloco":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"agarrini la palini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"antonio":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"arcadopus":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"arcadragon":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"avocadorilla":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"bacuru and egguru":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"bananito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"bananito quesadillo vampiro":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"baskito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"bearito cabinito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"bisonte giuppitere":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"blackhole goat":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"boatito auratito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"boppin bunny":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"brunito marsito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"brutto gialutto":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"bumbatron":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"bunito bunito spinito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"bunny and eggy":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"bunny bunny bunny sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"bunnyman":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"buntteo":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"burguro and fryuro":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"burrito bandito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"camera ramena":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"cangurato gelato":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"capitano americano":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"capitano gullini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"capitano moby":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"cash or card":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"caylusaurus":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"celestial pegasus":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"celularcini viciosini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"cerberus":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"chachechi":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"chicleteira bicicleteira":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"chicleteira cupideira":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"chicleteira noelteira":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"chicleteira surfeiteira":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"chicleteirina bicicleteirina":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"chill puppy":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"chillin chili":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"chimnino":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"chipso and queso":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"churrito bunnito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"cigno fulgoro":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"cloverat clapat":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"coco and mango":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"coffin tung tung tung sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"conetto morsetto":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"cooki and milki":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"craburger":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"cuadramat and pakrahmatmamat":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"cupid cupid sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"cupid hotspot":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"digi narwhal":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"dj panda":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"donkeyturbo express":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"dragon aquanini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"dragon cannelloni":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"dragon gingerini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"dragon skeletonini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"dug dug dug":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"duggy bros":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"dul dul dul":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"eid eid eid sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"elefanto frigo":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"esok sekolah":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"eviledon":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"examen bros":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"extinct matteo":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"extinct tralalero":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"festive 67":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"fishboard":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"fishino clownino":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"fortunu and cashuru":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"foxini lanternini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"fragola la la la":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"fragrama and chocrama":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"frankentteo":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"ganganzelli trulala":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"garama and madundung":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"giftini spyderini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"ginger gerat":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"girafini raftini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"globa steppa":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"goat":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"gobblino uniciclino":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"gold elf":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"gold gold gold":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"gorillo subwoofero":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"grabatron":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"graipuss medussi":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"granny":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"griffin":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"guerriro digitale":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"guest 666":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"gym bros":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"headless horseman":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"ho ho ho sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"honey honey bear":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"hopilikalika hopilikalako":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"horegini boom":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"hydra bunny":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"hydra dragon cannelloni":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"hydra serpent":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"jackorilla":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"jelly moby":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"job job job sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"john doe":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"john pork":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"jolly jolly sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"kalika bros":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"karker sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"karkerkar kurkur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"ketchuru and musturu":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"ketupat bros":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"ketupat kepat":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"kraken":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la anniversary grande":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la breakfast combinasion":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la casa boo":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la cucaracha":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la easter grande":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la extinct grande":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la food combinasion":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la fuse machine":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la ginger sekolah":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la grande combinasion":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la jolly grande":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasian":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la karkerkar kombinasion":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la lucky grande":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la romantic grande":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la sahur combinasion":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la sahur kombinasion":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la secret combinasion":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la spooky grande":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la summer grande":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la supreme combinasion":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la taco combinasion":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la vacca jacko linterino":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la vacca lepre lepreino":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la vacca pres presente":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la vacca prese presente":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"la vacca saturno saturnita":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"las sis":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"las tralaleritas":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"las vaquitas saturnitas":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"lavadarito spinito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"lavadorito spinito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"lazy ducky":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"list list list sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los 25":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los 67":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los admins":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los amigos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los bros":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los bunitos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los burritos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los candies":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los chicleiras":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los chicleteiras":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los chillis":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los combinasionas":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los cucarachas":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los cupids":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los dragons":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los fruits":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los hackers":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los hotspotsitos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los jobcitos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los jolly combinasionas":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los karkeritos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los matteos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los mi gatitos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los mobilis":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los nooo my hotspotsitos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los planitos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los primos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los puggies":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los quesadillas":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los secret combinasionas":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los sekolahs":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los spaghettis":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los spooky combinasionas":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los spyderinis":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los sweethearts":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los tacoritas":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los tangcitos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los tictacs":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los tortus":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los tralaleritos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"los trios":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"love love bear":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"love love love sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"lovin rose":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"luck luck luck sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"mariachi corazoni":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"meowl":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"mi gatito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"mieteteira bicicleteira":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"moby bros":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"money money bros":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"money money puggy":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"money money reindeer":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"nacho spyder":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"nachorilla":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"naughty naughty":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"noo my candy":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"noo my eggs":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"noo my examine":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"noo my gold":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"noo my heart":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"noo my present":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"noo my resume":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"noodle noodle poodle":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"nooo my hotspot":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"nuclearo dinossauro":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"octoball":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"orcaledon":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"orchidox":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"pancake and syrup":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"paradiso axolottino":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"perrito burrito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"phoenix":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"pirulito bicicleteira":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"pirulitoita bicicleteira":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"pizza and ranch":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"plant bros":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"please my present":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"polaroidini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"pop pop petalini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"popcuru and fizzuru":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"pot hotspot":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"pot pumpkin":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"pretzo robo":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"pumpkin spyderini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"pumpkini spyderini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"quackini snackini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"queen bee":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"quesadilla crocodila":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"quesadillo vampiro":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"rang ring bus":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"reindeer tralala":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"reinito sleighito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"rhino helicopterino":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"rico dinero":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"rocco disco":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"rocketini frostini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"rosetti tualetti":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"rosey and teddy":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"rubiko and kubiko":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"rubrikiko":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"s\'more serat":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"sammyini spyderini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"sammyni cakini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"sammyni fattini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"sammyni spyderini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"sammyni truckini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"sand sand sand":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"santa hotspot":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"santteo":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"scorpino coasterino":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"secret lucky block":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"serafinna medusella":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"signore carapace":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"skibidi toilet":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"snailo clovero":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"spaghetti tualetti":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"spinny hammy":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"spooky and pumpky":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"spyder elephant":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"steakini fattini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"strawberrita":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"strawberry elephant":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"sushi inu":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"swag soda":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"swaggy bros":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tacorillo crocodillo":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tacorita bicicleta":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tang tang keletang":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"telemorte":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tenini ballini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tictac sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika bros":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tirilikalika tirilikalako":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"to to to sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tob tobi tobi":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"torrtuginni dragonfrutini":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tralaledon":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"trenostruzzo turbo 4000":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"trickolino":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tripitio tralaleritos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"triplito tralaleritos":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tuff toucan":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"tung tung tung sahur":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"unclito samito":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"ventoliero pavonero":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"venuspino":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"vulturino skeletono":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"w or l":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"wheelchair granny":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"yess my examine":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"yetimatic":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false},"zombie tralala":{"enabled":true,"minGeneration":0,"mutOff":{},"special":false}},"settings":{"autoJoin":false,"backgroundBlur":true,"bindCancelJoin":"RightAlt","bindClearFeed":"Delete","bindToggleUi":"RightShift","forceAttempts":280,"hideTeleportError":true,"preemptNewest":true,"relayRegion":"usa","showHiddenCount":false,"soundId":"9046615797","soundOnFind":true,"spamForce":false,"streamSafe":false},"version":1}'
)
UI.TextLabel29.Text = "280"
UI.TextBox2.Text = "9046615797"
UI.TextButton22.Text = "OFF"
UI.TextButton22.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton22.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton23.Text = "ON"
UI.TextButton23.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
UI.TextButton23.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextButton24.Text = "OFF"
UI.TextButton24.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton24.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton25.Text = "ON"
UI.TextButton25.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
UI.TextButton25.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextButton26.Text = "ON"
UI.TextButton26.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
UI.TextButton26.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextButton27.Text = "OFF"
UI.TextButton27.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton27.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton29.Text = "OFF"
UI.TextButton29.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton29.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton30.Text = "ON"
UI.TextButton30.BackgroundColor3 = Color3.new(0.18823529779911041, 0.37647059559822083, 0.062745101749897)
UI.TextButton30.TextColor3 = Color3.new(0.69803923368453979, 1, 0.25098040699958801)
UI.TextButton33.Text = "Delete"
UI.TextButton33.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton33.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton32.Text = "Right Alt"
UI.TextButton32.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton32.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton31.Text = "Right Shift"
UI.TextButton31.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton31.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton18.Text = "USA"
UI.TextButton11.Text = "Auto-join  OFF"
UI.TextButton11.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.TextButton11.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton9.BackgroundColor3 = Color3.new(0.13333334028720856, 0.13333334028720856, 0.13333334028720856)
UI.Frame31.Position = UDim2.new(0, 10, 0.5, 0)
UI.Frame31.BackgroundColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextLabel3.Text = "Connecting..."
UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
UI.Frame15.Visible = true
UI.Frame35.Visible = true
UI.Frame35.Position = UDim2.fromOffset(0, 64)
UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
UI.Frame37.Visible = false
UI.Frame37.Position = UDim2.new(0, 0, 0, 0)
UI.Frame37.Size = UDim2.new(1, 0, 1, 0)
UI.ScrollingFrame5.Visible = false
UI.ScrollingFrame5.Position = UDim2.new(0, 0, 0, 0)
UI.ScrollingFrame5.Size = UDim2.new(1, 0, 1, 0)
UI.Frame38.Visible = false
UI.Frame38.Position = UDim2.new(0, 0, 0, 0)
UI.Frame38.Size = UDim2.new(1, 0, 1, 0)
UI.TextButton2.BackgroundTransparency = 0
UI.TextButton2.TextColor3 = Color3.new(0.96078431606292725, 0.96078431606292725, 0.96078431606292725)
UI.TextButton2.Font = Enum.Font.GothamBold
UI.TextButton5.BackgroundTransparency = 1
UI.TextButton5.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton5.Font = Enum.Font.GothamMedium
UI.TextButton4.BackgroundTransparency = 1
UI.TextButton4.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton4.Font = Enum.Font.GothamMedium
UI.TextButton3.BackgroundTransparency = 1
UI.TextButton3.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextButton3.Font = Enum.Font.GothamMedium
UI.Frame34.Visible = false
UI.TextButton8.Visible = false
UI.Frame35.Position = UDim2.fromOffset(0, 64)
UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
getgenv().SabcomSetTab = function(arg7, arg8)
	UI.Frame15.Visible = false
	UI.Frame35.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
	UI.Frame37.Visible = false
	UI.Frame37.Position = UDim2.new(0, 0, 0, 0)
	UI.Frame37.Size = UDim2.new(1, 0, 1, 0)
	UI.ScrollingFrame5.Visible = false
	UI.ScrollingFrame5.Position = UDim2.new(0, 0, 0, 0)
	UI.ScrollingFrame5.Size = UDim2.new(1, 0, 1, 0)
	UI.Frame38.Visible = false
	UI.Frame38.Position = UDim2.new(0, 0, 0, 0)
	UI.Frame38.Size = UDim2.new(1, 0, 1, 0)
	UI.TextButton2.BackgroundTransparency = 1
	UI.TextButton2.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton2.Font = Enum.Font.GothamMedium
	UI.TextButton5.BackgroundTransparency = 1
	UI.TextButton5.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton5.Font = Enum.Font.GothamMedium
	UI.TextButton4.BackgroundTransparency = 1
	UI.TextButton4.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton4.Font = Enum.Font.GothamMedium
	UI.TextButton3.BackgroundTransparency = 1
	UI.TextButton3.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
	UI.TextButton3.Font = Enum.Font.GothamMedium
	UI.Frame34.Visible = false
	UI.TextButton8.Visible = false
	UI.Frame35.Position = UDim2.fromOffset(0, 64)
	UI.Frame35.Size = UDim2.new(1, 0, 1, -64)
end
UI.TextLabel4.Text = "Idle"
UI.TextLabel4.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.Frame11.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.Frame12.BackgroundColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel3.Text = "Connecting..."
UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
local TweenService = game:GetService("TweenService")
UI.BlurEffect = Instance.new("BlurEffect")
UI.BlurEffect.Name = "SwagFinderBlur"
UI.BlurEffect.Size = 0
local Lighting = game:GetService("Lighting")
UI.BlurEffect.Parent = Lighting
UI.BlurEffect.Enabled = true
local tween = TweenService:Create(UI.BlurEffect, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Size = 12 })
tween:Play()
task.spawn(function(...)
	task.wait()
	UI.Frame12.BackgroundTransparency = 0
	task.wait()
end)
GuiService.ErrorMessageChanged:Connect(function(arg9) end)
TeleportService.TeleportInitFailed:Connect(function(arg10) end)
GuiService:GetErrorCode()
GuiService:GetErrorMessage()
GuiService:ClearError()
UI.TextLabel4.Text = "Idle"
UI.TextLabel4.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.Frame11.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.Frame12.BackgroundColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel3.Text = "Connecting USA..."
UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)
UI.TextLabel4.Text = "Idle"
UI.TextLabel4.TextColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.Frame11.BackgroundColor3 = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554)
UI.Frame12.BackgroundColor3 = Color3.new(0.47058823704719543, 0.50980395078659058, 0.47058823704719543)
UI.TextLabel3.Text = "Missing script key"
UI.TextLabel3.TextColor3 = Color3.new(1, 0.83921569585800171, 0.37647059559822083)