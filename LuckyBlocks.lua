-- ============================================================
-- LUCKY BLOCKS BATTLEGROUNDS SPAWNER (v1.1) - STABLE TOGGLE
-- ============================================================

if not game:IsLoaded() then
	pcall(function() game.Loaded:Wait() end)
end

if getgenv().LuckyBlocks_Executed and getgenv().LuckyBlocks_Cleanup then
	pcall(getgenv().LuckyBlocks_Cleanup)
end

getgenv().LuckyBlocks_Executed = true
getgenv().LuckyBlocks_Connections = getgenv().LuckyBlocks_Connections or {}

-- ====================== SERVICES ======================
local Services = setmetatable({}, {
	__index = function(self, name)
		local ok, service = pcall(function()
			return (cloneref or function(x) return x end)(game:GetService(name))
		end)
		if ok and service then
			rawset(self, name, service)
			return service
		end
		return nil
	end
})

local Players            = Services.Players
local UserInputService   = Services.UserInputService
local HttpService        = Services.HttpService
local TeleportService    = Services.TeleportService
local ReplicatedStorage  = Services.ReplicatedStorage

local LocalPlayer = Players.LocalPlayer

-- ====================== HELPERS ======================
local function Track(conn)
	if typeof(conn) == "RBXScriptConnection" then
		table.insert(getgenv().LuckyBlocks_Connections, conn)
	end
	return conn
end

local function DisconnectAll()
	for _, conn in ipairs(getgenv().LuckyBlocks_Connections) do
		if typeof(conn) == "RBXScriptConnection" and conn.Connected then
			pcall(function() conn:Disconnect() end)
		end
	end
	table.clear(getgenv().LuckyBlocks_Connections)
end

local EventConnections = {}

local function Register(name, conn)
	if EventConnections[name] then
		pcall(function() EventConnections[name]:Disconnect() end)
	end
	EventConnections[name] = conn
	Track(conn)
end

local function Unregister(name)
	if EventConnections[name] then
		pcall(function() EventConnections[name]:Disconnect() end)
		EventConnections[name] = nil
	end
end

-- ====================== LOAD WINDUI ======================
local WindUI
do
	local ok, result = pcall(function()
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/ImNotTurtle1891/Turtle-Hub-Main/refs/heads/main/MainV1"))()
	end)
	if not ok or not result then
		warn("[Lucky Blocks] Failed to load WindUI")
		return
	end
	WindUI = result
end

print("[Lucky Blocks] WindUI loaded")

-- ====================== CONFIG ======================
local Config = {
	NotificationsEnabled   = true,
	luckyEnabled           = false,
	superEnabled           = false,
	diamondEnabled         = false,
	rainbowEnabled         = false,
	galaxyEnabled          = false,
	allBlocksEnabled       = false,
}

local CONFIG_FILE = "LuckyBlocks_Config.json"

-- ====================== FLAGS ======================
local LuckyBlockFlags = {
	lucky      = {false},
	super      = {false},
	diamond    = {false},
	rainbow    = {false},
	galaxy     = {false},
	all        = {false},
}

local LuckyBlockThreads = {}

-- ====================== FUNCTIONS ======================
local function Notify(data)
	if not Config.NotificationsEnabled then return end
	if WindUI and WindUI.Notify then
		WindUI:Notify(data)
	end
end

local function SaveConfig()
	local data = {
		NotificationsEnabled = Config.NotificationsEnabled,
		luckyEnabled         = Config.luckyEnabled,
		superEnabled         = Config.superEnabled,
		diamondEnabled       = Config.diamondEnabled,
		rainbowEnabled       = Config.rainbowEnabled,
		galaxyEnabled        = Config.galaxyEnabled,
		allBlocksEnabled     = Config.allBlocksEnabled,
	}
	pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(data)) end)
end

local function LoadConfig()
	local ok, content = pcall(function() return readfile(CONFIG_FILE) end)
	if not ok or not content or content == "" then
		SaveConfig()
		return
	end
	local decodeOk, data = pcall(function() return HttpService:JSONDecode(content) end)
	if not decodeOk or type(data) ~= "table" then
		SaveConfig()
		return
	end

	Config.NotificationsEnabled = data.NotificationsEnabled ~= false
	Config.luckyEnabled         = data.luckyEnabled or false
	Config.superEnabled         = data.superEnabled or false
	Config.diamondEnabled       = data.diamondEnabled or false
	Config.rainbowEnabled       = data.rainbowEnabled or false
	Config.galaxyEnabled        = data.galaxyEnabled or false
	Config.allBlocksEnabled     = data.allBlocksEnabled or false
end

LoadConfig()

local function StopAllBlocks()
	LuckyBlockFlags.lucky[1]   = false
	LuckyBlockFlags.super[1]   = false
	LuckyBlockFlags.diamond[1] = false
	LuckyBlockFlags.rainbow[1] = false
	LuckyBlockFlags.galaxy[1]  = false
	LuckyBlockFlags.all[1]     = false
	
	for name, thread in pairs(LuckyBlockThreads) do
		if thread then
			pcall(function() task.cancel(thread) end)
			LuckyBlockThreads[name] = nil
		end
	end
	
	Config.luckyEnabled     = false
	Config.superEnabled     = false
	Config.diamondEnabled   = false
	Config.rainbowEnabled   = false
	Config.galaxyEnabled    = false
	Config.allBlocksEnabled = false
	
	Notify({Title = "Lucky Blocks", Content = "All spawners stopped", Duration = 1.5, Icon = "square"})
	SaveConfig()
end

local function AutoSpawn(flag, remote, blockName)
	local thread = task.spawn(function()
		while flag[1] do
			local ok = pcall(function()
				local rem = ReplicatedStorage:WaitForChild(remote, 5)
				if rem then rem:FireServer() end
			end)
			if not ok then
				Notify({Title = "Lucky Blocks", Content = blockName .. " remote not found", Duration = 2, Icon = "alert-circle"})
				flag[1] = false
				break
			end
			task.wait(1)
		end
	end)
	
	LuckyBlockThreads[blockName] = thread
	Notify({Title = "Lucky Blocks", Content = blockName .. " spawning...", Duration = 1.5, Icon = "zap"})
end

-- ====================== CLEANUP ======================
getgenv().LuckyBlocks_Cleanup = function()
	StopAllBlocks()
	for name in pairs(EventConnections) do Unregister(name) end
	DisconnectAll()
end

-- ====================== UI ======================
local Window = WindUI:CreateWindow({
	Title       = "LUCKY <font color='#FFD700'>BLOCKS</font>",
	Author      = "Battlegrounds Spawner",
	Folder      = "LuckyBlocks",
	Resizable   = true,
	Minimizable = true,
	Theme       = "Midnight",
	Transparent = true,
	HasOutline  = true,
	SideBarWidth = 150,
	CornerRadius = UDim.new(0, 12),
	OpenButton  = {
		Title          = "LUCKY <font color='#FFD700'>BLOCKS</font>",
		CornerRadius   = UDim.new(0, 10),
		StrokeThickness= 2,
		Enabled        = true,
		Draggable      = true,
		OnlyMobile     = true,
		Color          = ColorSequence.new(Color3.fromHex("#FFD700")),
		GradientEnabled= true,
	},
})

-- ====================== STABLE TOGGLE (ONLY MANUAL) ======================
local debounce = false

local function ToggleMenu()
	if debounce then return end
	debounce = true
	
	pcall(function()
		if Window.Toggle then
			Window:Toggle()
		elseif Window.SetVisible then
			Window:SetVisible(not Window.Visible)
		elseif type(Window.Visible) == "boolean" then
			Window.Visible = not Window.Visible
		end
	end)
	
	task.delay(0.25, function()
		debounce = false
	end)
end

-- Only one listener - RightControl
Register("ToggleKey", UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		ToggleMenu()
	end
end))

task.spawn(function()
	WindUI:Notify({
		Title   = "Controls",
		Content = "RightControl = Toggle Menu",
		Duration= 4,
	})
end)

-- ====================== TABS ======================
local HomeTab     = Window:Tab({Title = "Home",        Icon = "house"})
local BlocksTab   = Window:Tab({Title = "Lucky Blocks", Icon = "package"})
local SettingsTab = Window:Tab({Title = "Settings",    Icon = "settings"})

HomeTab:Select()

-- ====================== HOME ======================
HomeTab:Paragraph({
	Title    = "Welcome, " .. LocalPlayer.Name .. "!",
	Desc     = string.format(
		"<font color='#AAAAAA'>Executor:</font> %s\n<font color='#AAAAAA'>UserId:</font> %d",
		typeof(identifyexecutor) == "function" and identifyexecutor() or "Unknown",
		LocalPlayer.UserId
	),
	RichText = true,
	Image    = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
	ImageSize= 55,
})

HomeTab:Divider()

HomeTab:Paragraph({
	Title = "Lucky Blocks Battlegrounds",
	Desc  = table.concat({
		"• Automatic block spawner",
		"• 5 types of blocks available",
		"• Simultaneous spawn of all",
		"• Control from a single interface",
		"• Auto-save configuration",
		"• RightControl to open/close menu",
	}, "\n"),
})

HomeTab:Divider()

HomeTab:Paragraph({
	Title = "How to Use",
	Desc  = "Go to the 'Lucky Blocks' tab to start using the spawner",
})

-- ====================== LUCKY BLOCKS TAB ======================
BlocksTab:Paragraph({
	Title = "Lucky Block Spawner",
	Desc  = "Auto-spawn blocks every 1 second",
})

BlocksTab:Divider()

BlocksTab:Toggle({
	Title    = "Lucky Block",
	Desc     = "Spawns Lucky Blocks",
	Value    = Config.luckyEnabled,
	Callback = function(v)
		Config.luckyEnabled = v
		LuckyBlockFlags.lucky[1] = v
		if v then
			AutoSpawn(LuckyBlockFlags.lucky, "SpawnLuckyBlock", "Lucky Block")
		end
		SaveConfig()
	end,
})

BlocksTab:Toggle({
	Title    = "Super Block",
	Desc     = "Spawns Super Blocks",
	Value    = Config.superEnabled,
	Callback = function(v)
		Config.superEnabled = v
		LuckyBlockFlags.super[1] = v
		if v then
			AutoSpawn(LuckyBlockFlags.super, "SpawnSuperBlock", "Super Block")
		end
		SaveConfig()
	end,
})

BlocksTab:Toggle({
	Title    = "Diamond Block",
	Desc     = "Spawns Diamond Blocks",
	Value    = Config.diamondEnabled,
	Callback = function(v)
		Config.diamondEnabled = v
		LuckyBlockFlags.diamond[1] = v
		if v then
			AutoSpawn(LuckyBlockFlags.diamond, "SpawnDiamondBlock", "Diamond Block")
		end
		SaveConfig()
	end,
})

BlocksTab:Toggle({
	Title    = "Rainbow Block",
	Desc     = "Spawns Rainbow Blocks",
	Value    = Config.rainbowEnabled,
	Callback = function(v)
		Config.rainbowEnabled = v
		LuckyBlockFlags.rainbow[1] = v
		if v then
			AutoSpawn(LuckyBlockFlags.rainbow, "SpawnRainbowBlock", "Rainbow Block")
		end
		SaveConfig()
	end,
})

BlocksTab:Toggle({
	Title    = "Galaxy Block",
	Desc     = "Spawns Galaxy Blocks",
	Value    = Config.galaxyEnabled,
	Callback = function(v)
		Config.galaxyEnabled = v
		LuckyBlockFlags.galaxy[1] = v
		if v then
			AutoSpawn(LuckyBlockFlags.galaxy, "SpawnGalaxyBlock", "Galaxy Block")
		end
		SaveConfig()
	end,
})

BlocksTab:Divider()

BlocksTab:Toggle({
	Title    = "All Blocks",
	Desc     = "Spawns ALL blocks simultaneously",
	Value    = Config.allBlocksEnabled,
	Callback = function(v)
		Config.allBlocksEnabled = v
		LuckyBlockFlags.all[1] = v
		
		if not v then
			StopAllBlocks()
			return
		end
		
		local thread = task.spawn(function()
			while LuckyBlockFlags.all[1] do
				local remotes = {
					ReplicatedStorage:FindFirstChild("SpawnLuckyBlock"),
					ReplicatedStorage:FindFirstChild("SpawnSuperBlock"),
					ReplicatedStorage:FindFirstChild("SpawnDiamondBlock"),
					ReplicatedStorage:FindFirstChild("SpawnRainbowBlock"),
					ReplicatedStorage:FindFirstChild("SpawnGalaxyBlock"),
				}
				
				for _, rem in ipairs(remotes) do
					if rem then
						pcall(function() rem:FireServer() end)
					end
				end
				task.wait(1)
			end
		end)
		
		LuckyBlockThreads["AllBlocks"] = thread
		Notify({Title = "Lucky Blocks", Content = "All block types spawning!", Duration = 2, Icon = "zap"})
		SaveConfig()
	end,
})

BlocksTab:Divider()

BlocksTab:Button({
	Title    = "⏹️  STOP ALL SPAWNERS",
	Icon     = "square",
	Callback = StopAllBlocks,
})

-- ====================== SETTINGS TAB ======================
SettingsTab:Toggle({
	Title    = "Notifications",
	Value    = Config.NotificationsEnabled,
	Callback = function(v)
		Config.NotificationsEnabled = v
		SaveConfig()
	end,
})

SettingsTab:Paragraph({
	Title = "UI Toggle Key",
	Desc  = "<b>RightControl</b>\n(This key is fixed and cannot be changed)",
	RichText = true,
})

SettingsTab:Divider()

SettingsTab:Button({
	Title = "Rejoin Server",
	Icon  = "refresh-cw",
	Callback = function()
		Window:Dialog({
			Title = "Rejoin?",
			Content = "Return to the same server?",
			Buttons = {
				{Title = "Cancel", Variant = "Secondary"},
				{Title = "Rejoin", Icon = "check", Callback = function()
					TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
				end},
			},
		})
	end,
})

SettingsTab:Button({
	Title = "Server Hop",
	Icon  = "shuffle",
	Callback = function()
		Window:Dialog({
			Title = "Server Hop?",
			Content = "Join a different server?",
			Buttons = {
				{Title = "Cancel", Variant = "Secondary"},
				{Title = "Hop", Icon = "check", Callback = function()
					local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
					local ok, data = pcall(function()
						return HttpService:JSONDecode(game:HttpGet(url))
					end)
					if ok and data and data.data then
						for _, s in ipairs(data.data) do
							if s.id ~= game.JobId and s.playing < s.maxPlayers then
								TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
								return
							end
						end
					end
					TeleportService:Teleport(game.PlaceId, LocalPlayer)
				end},
			},
		})
	end,
})

SettingsTab:Divider()

SettingsTab:Button({
	Title = "Unload Script",
	Icon  = "power",
	Callback = function()
		getgenv().LuckyBlocks_Cleanup()
		if Window and Window.Destroy then
			pcall(function() Window:Destroy() end)
		end
	end,
})

-- ====================== INIT ======================
Notify({
	Title = "Lucky Blocks",
	Content = "Ready • RightControl = Menu",
	Duration = 3.5,
	Icon = "check-circle",
})

print("[Lucky Blocks] v1.1 loaded - Stable RightControl toggle")