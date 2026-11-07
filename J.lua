--==================================================
-- DEMONS HUB | V2.0 PREMIUM
-- ORIGINAL SOURCE
-- Roblox Studio - LocalScript
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- CONFIGURATION
local Config = {
    Name = "DEMONS HUB",
    Version = "2.0",
    Logo = "rbxassetid://137228242036869",
    Background = Color3.fromRGB(12, 12, 14),
    Panel = Color3.fromRGB(23, 23, 26),
    Accent = Color3.fromRGB(190, 38, 52),
    Text = Color3.fromRGB(245, 245, 245),
    Muted = Color3.fromRGB(145, 145, 150)
}

local Settings = {
    Animations = true,
    SoundEffects = false,
    AccentColor = "Red",
    ShowNotifications = true
}

local Profiles = {}

-- GUI SETUP
local Gui = Instance.new("ScreenGui")
Gui.Name = "DEMONS_HUB_V2"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 100
Gui.Parent = PlayerGui

local function Corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = object
    return c
end

local function Stroke(object, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Parent = object
    return s
end

local function Animate(object, properties)
    if not Settings.Animations then
        for property, value in pairs(properties) do
            object[property] = value
        end
        return
    end
    TweenService:Create(
        object,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        properties
    ):Play()
end

-- MAIN WINDOW
local Main = Instance.new("Frame")
Main.Name = "MainWindow"
Main.Size = UDim2.fromOffset(650, 420)
Main.Position = UDim2.new(0.5, -325, 0.5, -210)
Main.BackgroundColor3 = Config.Background
Main.BorderSizePixel = 0
Main.Parent = Gui
Corner(Main, 14)
local MainStroke = Stroke(Main, Config.Accent, 1.3)

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 58)
Header.BackgroundColor3 = Config.Panel
Header.BorderSizePixel = 0
Header.Parent = Main
Corner(Header, 14)

local Logo = Instance.new("ImageLabel")
Logo.Name = "OfficialLogo"
Logo.Size = UDim2.fromOffset(40, 40)
Logo.Position = UDim2.fromOffset(12, 9)
Logo.BackgroundTransparency = 1
Logo.Image = Config.Logo
Logo.ScaleType = Enum.ScaleType.Fit
Logo.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -160, 1, 0)
Title.Position = UDim2.fromOffset(62, 0)
Title.BackgroundTransparency = 1
Title.Text = Config.Name
Title.TextColor3 = Config.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 21
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.fromOffset(70, 25)
VersionLabel.Position = UDim2.new(1, -155, 0, 17)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "V" .. Config.Version
VersionLabel.TextColor3 = Config.Muted
VersionLabel.TextSize = 12
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Parent = Header

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(32, 32)
Minimize.Position = UDim2.new(1, -78, 0, 13)
Minimize.BackgroundColor3 = Config.Panel
Minimize.Text = "—"
Minimize.TextColor3 = Config.Text
Minimize.TextSize = 18
Minimize.Parent = Header
Corner(Minimize, 8)

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(32, 32)
Close.Position = UDim2.new(1, -40, 0, 13)
Close.BackgroundColor3 = Config.Accent
Close.Text = "X"
Close.TextColor3 = Config.Text
Close.TextSize = 14
Close.Font = Enum.Font.GothamBold
Close.Parent = Header
Corner(Close, 8)

-- DRAG MAIN WINDOW
local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- FLOATING BAR
local FloatingBar = Instance.new("TextButton")
FloatingBar.Name = "FloatingBar"
FloatingBar.Size = UDim2.fromOffset(190, 44)
FloatingBar.Position = UDim2.new(0.5, -95, 0.88, 0)
FloatingBar.BackgroundColor3 = Color3.fromRGB(8, 8, 9)
FloatingBar.Text = ""
FloatingBar.AutoButtonColor = false
FloatingBar.Parent = Gui
Corner(FloatingBar, 12)
Stroke(FloatingBar, Config.Accent, 1.5)

local FloatLogo = Instance.new("ImageLabel")
FloatLogo.Size = UDim2.fromOffset(35, 35)
FloatLogo.Position = UDim2.fromOffset(5, 4)
FloatLogo.BackgroundTransparency = 1
FloatLogo.Image = Config.Logo
FloatLogo.ScaleType = Enum.ScaleType.Fit
FloatLogo.Parent = FloatingBar

local FloatTitle = Instance.new("TextLabel")
FloatTitle.Size = UDim2.new(1, -48, 1, 0)
FloatTitle.Position = UDim2.fromOffset(43, 0)
FloatTitle.BackgroundTransparency = 1
FloatTitle.Text = Config.Name
FloatTitle.TextColor3 = Config.Text
FloatTitle.TextSize = 16
FloatTitle.Font = Enum.Font.GothamBold
FloatTitle.Parent = FloatingBar

-- FLOATING BAR DRAG
local barDragging = false
local barDragStart
local barStartPosition

FloatingBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        barDragging = true
        barDragStart = input.Position
        barStartPosition = FloatingBar.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if barDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - barDragStart
        FloatingBar.Position = UDim2.new(
            barStartPosition.X.Scale,
            barStartPosition.X.Offset + delta.X,
            barStartPosition.Y.Scale,
            barStartPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        barDragging = false
    end
end)

-- CONTENT AREA
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -72)
Sidebar.Position = UDim2.fromOffset(10, 64)
Sidebar.BackgroundColor3 = Config.Panel
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Corner(Sidebar, 10)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 7)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 12)
SidePadding.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -174, 1, -72)
Content.Position = UDim2.fromOffset(164, 64)
Content.BackgroundColor3 = Config.Panel
Content.BorderSizePixel = 0
Content.Parent = Main
Corner(Content, 10)

local PageTitle = Instance.new("TextLabel")
PageTitle.Size = UDim2.new(1, -30, 0, 45)
PageTitle.Position = UDim2.fromOffset(15, 8)
PageTitle.BackgroundTransparency = 1
PageTitle.Text = "INICIO"
PageTitle.TextColor3 = Config.Text
PageTitle.TextSize = 21
PageTitle.Font = Enum.Font.GothamBold
PageTitle.TextXAlignment = Enum.TextXAlignment.Left
PageTitle.Parent = Content

local PageBody = Instance.new("ScrollingFrame")
PageBody.Size = UDim2.new(1, -25, 1, -62)
PageBody.Position = UDim2.fromOffset(13, 55)
PageBody.BackgroundTransparency = 1
PageBody.BorderSizePixel = 0
PageBody.ScrollBarThickness = 3
PageBody.ScrollBarImageColor3 = Config.Accent
PageBody.CanvasSize = UDim2.new(0, 0, 0, 0)
PageBody.AutomaticCanvasSize = Enum.AutomaticSize.Y
PageBody.Parent = Content

local BodyLayout = Instance.new("UIListLayout")
BodyLayout.Padding = UDim.new(0, 9)
BodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
BodyLayout.Parent = PageBody

-- UI ELEMENT CREATORS
local function ClearPage()
    for _, child in ipairs(PageBody:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

local function Label(text)
    local item = Instance.new("TextLabel")
    item.Size = UDim2.new(1, -8, 0, 32)
    item.BackgroundTransparency = 1
    item.Text = text
    item.TextColor3 = Config.Text
    item.Font = Enum.Font.GothamBold
    item.TextSize = 15
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.Parent = PageBody
    return item
end

local function Description(text)
    local item = Instance.new("TextLabel")
    item.Size = UDim2.new(1, -8, 0, 36)
    item.BackgroundTransparency = 1
    item.Text = text
    item.TextColor3 = Config.Muted
    item.Font = Enum.Font.Gotham
    item.TextSize = 12
    item.TextWrapped = true
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.Parent = PageBody
    return item
end

local function Button(text, callback)
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -8, 0, 38)
    item.BackgroundColor3 = Config.Background
    item.Text = text
    item.TextColor3 = Config.Text
    item.Font = Enum.Font.GothamSemibold
    item.TextSize = 13
    item.Parent = PageBody
    Corner(item, 8)

    item.Activated:Connect(callback)
    item.MouseEnter:Connect(function()
        Animate(item, {BackgroundColor3 = Config.Accent})
    end)
    item.MouseLeave:Connect(function()
        Animate(item, {BackgroundColor3 = Config.Background})
    end)
    return item
end

local function Toggle(text, setting, callback)
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -8, 0, 38)
    item.BackgroundColor3 = Config.Background
    item.TextColor3 = Config.Text
    item.Font = Enum.Font.Gotham
    item.TextSize = 13
    item.Parent = PageBody
    Corner(item, 8)

    local function Refresh()
        item.Text = text .. (Settings[setting] and "     [ ON ]" or "     [ OFF ]")
    end

    Refresh()
    item.Activated:Connect(function()
        Settings[setting] = not Settings[setting]
        Refresh()
        if callback then
            callback(Settings[setting])
        end
    end)
    return item
end

-- PAGE SYSTEM
local function OpenPage(page)
    PageTitle.Text = string.upper(page)
    ClearPage()

    if page == "Inicio" then
        Label("Bienvenido a DEMONS HUB")
        Description("Tu espacio personal de configuracion y herramientas.")
        Label("INFORMACION")
        Description("Version: " .. Config.Version)
        Description("Usuario: " .. Player.Name)
        Description("Estado: Interfaz cargada correctamente")
        Button("Abrir funciones", function()
            OpenPage("Funciones")
        end)

    elseif page == "Jugador" then
        Label("INFORMACION DEL JUGADOR")
        Description("Nombre: " .. Player.Name)
        Description("Display Name: " .. Player.DisplayName)
        Description("User ID: " .. Player.UserId)

        local function RefreshCharacter()
            local character = Player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                Description("Salud actual: " .. math.floor(humanoid.Health))
                Description("Velocidad actual: " .. math.floor(humanoid.WalkSpeed))
            else
                Description("Personaje no disponible")
            end
        end

        Button("Actualizar informacion", RefreshCharacter)
        RefreshCharacter()

    elseif page == "Camara" then
        Label("CONTROLES DE CAMARA")
        Description("Ajustes locales de la camara.")

        Button("Aumentar campo de vision (+5)", function()
            local camera = workspace.CurrentCamera
            if camera then
                camera.FieldOfView = math.clamp(camera.FieldOfView + 5, 40, 100)
            end
        end)

        Button("Reducir campo de vision (-5)", function()
            local camera = workspace.CurrentCamera
            if camera then
                camera.FieldOfView = math.clamp(camera.FieldOfView - 5, 40, 100)
            end
        end)

        Button("Restablecer camara", function()
            local camera = workspace.CurrentCamera
            if camera then
                camera.FieldOfView = 70
            end
        end)

    elseif page == "Funciones" then
        Label("FUNCIONES DEL PANEL")
        Description("Preferencias de la interfaz DEMONS HUB.")
        Toggle("Animaciones", "Animations")
        Toggle("Efectos de sonido (preferencia)", "SoundEffects")
        Toggle("Notificaciones", "ShowNotifications")

    elseif page == "Temas" then
        Label("PERSONALIZAR COLORES")
        Description("Selecciona el color de acento del panel.")

        Button("Tema rojo", function()
            Config.Accent = Color3.fromRGB(190, 38, 52)
            Config.AccentColor = "Red"
            MainStroke.Color = Config.Accent
            OpenPage("Temas")
        end)

        Button("Tema morado", function()
            Config.Accent = Color3.fromRGB(130, 75, 190)
            Config.AccentColor = "Purple"
            MainStroke.Color = Config.Accent
            OpenPage("Temas")
        end)

        Button("Tema azul", function()
            Config.Accent = Color3.fromRGB(45, 110, 210)
            Config.AccentColor = "Blue"
            MainStroke.Color = Config.Accent
            OpenPage("Temas")
        end)

    elseif page == "Ajustes" then
        Label("CONFIGURACION")
        Description("Ajustes generales del proyecto.")

        Button("Reiniciar ajustes", function()
            Settings.Animations = true
            Settings.SoundEffects = false
            Settings.ShowNotifications = true
            Config.Accent = Color3.fromRGB(190, 38, 52)
            Config.AccentColor = "Red"
            MainStroke.Color = Config.Accent
            OpenPage("Ajustes")
        end)

        Button("Volver al inicio", function()
            OpenPage("Inicio")
        end)

    elseif page == "Perfiles" then
        Label("SISTEMA DE PERFILES")
        Description("Los perfiles se mantienen durante esta sesion.")

        Button("Guardar perfil actual", function()
            Profiles.Default = {
                Animations = Settings.Animations,
                SoundEffects = Settings.SoundEffects,
                ShowNotifications = Settings.ShowNotifications,
                AccentColor = Config.AccentColor
            }
            Description("Perfil guardado correctamente.")
        end)

        Button("Cargar perfil guardado", function()
            local profile = Profiles.Default
            if profile then
                Settings.Animations = profile.Animations
                Settings.SoundEffects = profile.SoundEffects
                Settings.ShowNotifications = profile.ShowNotifications
                Config.AccentColor = profile.AccentColor

                local colors = {
                    Red = Color3.fromRGB(190, 38, 52),
                    Purple = Color3.fromRGB(130, 75, 190),
                    Blue = Color3.fromRGB(45, 110, 210)
                }
                Config.Accent = colors[Config.AccentColor] or colors.Red
                MainStroke.Color = Config.Accent
                OpenPage("Perfiles")
            end
        end)

    elseif page == "Buscador" then
        Label("BUSCADOR DE FUNCIONES")
        Description("Escribe para filtrar las paginas.")

        local Search = Instance.new("TextBox")
        Search.Size = UDim2.new(1, -8, 0, 38)
        Search.BackgroundColor3 = Config.Background
        Search.TextColor3 = Config.Text
        Search.PlaceholderColor3 = Config.Muted
        Search.PlaceholderText = "Buscar..."
        Search.Text = ""
        Search.Font = Enum.Font.Gotham
        Search.TextSize = 14
        Search.ClearTextOnFocus = false
        Search.Parent = PageBody
        Corner(Search, 8)

        local results = {
            "Inicio", "Jugador", "Camara", "Funciones",
            "Temas", "Ajustes", "Perfiles", "Buscador", "Historial"
        }

        local resultButtons = {}
        for _, result in ipairs(results) do
            local b = Button(result, function()
                OpenPage(result)
            end)
            table.insert(resultButtons, b)
        end

        Search:GetPropertyChangedSignal("Text"):Connect(function()
            local query = string.lower(Search.Text)
            for _, b in ipairs(resultButtons) do
                b.Visible = query == ""
                    or string.find(string.lower(b.Text), query, 1, true) ~= nil
            end
        end)

    elseif page == "Historial" then
        Label("REGISTRO DE CAMBIOS")
        Description("DEMONS HUB V2.0")
        Description("Interfaz premium creada desde cero.")
        Description("Barra flotante con logo oficial.")
        Description("Sistema de paginas y personalizacion.")
        Description("Herramientas locales de camara.")
        Description("Sistema de perfiles de sesion.")
    end
end

-- NAVIGATION
local pages = {
    "Inicio", "Jugador", "Camara", "Funciones", "Temas",
    "Ajustes", "Perfiles", "Buscador", "Historial"
}

for index, page in ipairs(pages) do
    local nav = Instance.new("TextButton")
    nav.Name = page .. "Button"
    nav.Size = UDim2.new(1, -16, 0, 35)
    nav.BackgroundColor3 = Config.Background
    nav.Text = page
    nav.TextColor3 = Config.Text
    nav.TextSize = 12
    nav.Font = Enum.Font.GothamSemibold
    nav.LayoutOrder = index
    nav.Parent = Sidebar
    Corner(nav, 7)

    nav.Activated:Connect(function()
        OpenPage(page)
    end)
end

-- BUTTON ACTIONS
Minimize.Activated:Connect(function()
    Main.Visible = false
end)

FloatingBar.Activated:Connect(function()
    Main.Visible = not Main.Visible
end)

Close.Activated:Connect(function()
    Gui:Destroy()
end)

-- KEYBOARD SHORTCUT
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

-- INITIALIZATION
OpenPage("Inicio")

print("================================")
print("DEMONS HUB V2.0 LOADED")
print("PREMIUM INTERFACE")
print("================================")