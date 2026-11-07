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
    Background = Color3.fromRGB(5, 5, 8),
    Panel = Color3.fromRGB(10, 10, 10),
    Accent = Color3.fromRGB(235, 45, 65),
    Text = Color3.fromRGB(245, 247, 252),
    Muted = Color3.fromRGB(145, 153, 168)
}

local Settings = {
    Animations = true,
    SoundEffects = false,
    AccentColor = "Silver",
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
Main.Size = UDim2.fromOffset(330, 500)
Main.Position = UDim2.new(0, 20, 0, 2)
Main.BackgroundColor3 = Color3.fromRGB(8, 10, 15)
Main.BorderSizePixel = 0
Main.Parent = Gui
Corner(Main, 16)
local MainStroke = Stroke(Main, Color3.fromRGB(190, 35, 55), 1.4)
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 17, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 6, 10))
})
MainGradient.Rotation = 90
MainGradient.Parent = Main

-- FUTURISTIC HEADER / LOGO (image ratio preserved; never stretched)
local Header = Instance.new("Frame")
Header.Name = "FuturisticHeader"
Header.Size = UDim2.new(1, 0, 0, 94)
Header.BackgroundColor3 = Color3.fromRGB(9, 11, 17)
Header.BorderSizePixel = 0
Header.Parent = Main
Corner(Header, 16)

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 13, 19)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(11, 13, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 8, 13))
})
HeaderGradient.Rotation = 0
HeaderGradient.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Name = "AccentLine"
HeaderLine.Size = UDim2.new(1, -28, 0, 2)
HeaderLine.Position = UDim2.new(0, 14, 1, -3)
HeaderLine.BackgroundColor3 = Config.Accent
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header
Corner(HeaderLine, 2)

local Logo = Instance.new("ImageLabel")
Logo.Name = "OfficialLogo"
Logo.AnchorPoint = Vector2.new(0, 0.5)
Logo.Size = UDim2.new(0, 178, 0, 70)
Logo.Position = UDim2.new(0, 13, 0.5, -1)
Logo.BackgroundTransparency = 1
Logo.Image = Config.Logo
Logo.ScaleType = Enum.ScaleType.Fit
Logo.Parent = Header

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Name = "VersionLabel"
VersionLabel.Size = UDim2.fromOffset(48, 22)
VersionLabel.Position = UDim2.new(1, -105, 0, 12)
VersionLabel.BackgroundColor3 = Color3.fromRGB(24, 18, 24)
VersionLabel.BackgroundTransparency = 0.1
VersionLabel.Text = "V" .. Config.Version
VersionLabel.TextColor3 = Color3.fromRGB(255, 105, 120)
VersionLabel.TextSize = 10
VersionLabel.Font = Enum.Font.GothamBold
VersionLabel.Parent = Header
Corner(VersionLabel, 7)
Stroke(VersionLabel, Color3.fromRGB(115, 35, 49), 1)

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(30, 30)
Minimize.Position = UDim2.new(1, -72, 0, 42)
Minimize.BackgroundColor3 = Color3.fromRGB(26, 29, 38)
Minimize.Text = "—"
Minimize.TextColor3 = Config.Text
Minimize.TextSize = 17
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Header
Corner(Minimize, 8)
Stroke(Minimize, Color3.fromRGB(65, 72, 88), 1)

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(30, 30)
Close.Position = UDim2.new(1, -36, 0, 42)
Close.BackgroundColor3 = Color3.fromRGB(48, 17, 25)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 130, 140)
Close.TextSize = 18
Close.Font = Enum.Font.GothamBold
Close.Parent = Header
Corner(Close, 8)
Stroke(Close, Color3.fromRGB(130, 40, 53), 1)

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
FloatingBar.Size = UDim2.fromOffset(190, 46)
FloatingBar.Position = UDim2.new(0, 16, 0, 58)
FloatingBar.BackgroundColor3 = Color3.fromRGB(7, 9, 14)
FloatingBar.Text = ""
FloatingBar.AutoButtonColor = false
FloatingBar.Parent = Gui
Corner(FloatingBar, 13)
Stroke(FloatingBar, Color3.fromRGB(205, 42, 62), 1.4)

local FloatLogo = Instance.new("ImageLabel")
FloatLogo.AnchorPoint = Vector2.new(0.5, 0.5)
FloatLogo.Size = UDim2.new(1, -18, 1, -8)
FloatLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
FloatLogo.BackgroundTransparency = 1
FloatLogo.Image = Config.Logo
FloatLogo.ScaleType = Enum.ScaleType.Fit
FloatLogo.Parent = FloatingBar

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
Sidebar.Size = UDim2.new(0, 88, 1, -110)
Sidebar.Position = UDim2.fromOffset(8, 102)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Corner(Sidebar, 11)
Stroke(Sidebar, Color3.fromRGB(45, 51, 65), 1)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 5)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 8)
SidePadding.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -112, 1, -110)
Content.Position = UDim2.fromOffset(104, 102)
Content.BackgroundColor3 = Color3.fromRGB(11, 14, 21)
Content.BorderSizePixel = 0
Content.Parent = Main
Corner(Content, 11)
Stroke(Content, Color3.fromRGB(42, 49, 63), 1)

local PageTitle = Instance.new("TextLabel")
PageTitle.Size = UDim2.new(1, -20, 0, 38)
PageTitle.Position = UDim2.fromOffset(10, 5)
PageTitle.BackgroundTransparency = 1
PageTitle.Text = "INICIO"
PageTitle.TextColor3 = Config.Text
PageTitle.TextSize = 16
PageTitle.Font = Enum.Font.GothamBold
PageTitle.TextXAlignment = Enum.TextXAlignment.Left
PageTitle.Parent = Content

local PageBody = Instance.new("ScrollingFrame")
PageBody.Size = UDim2.new(1, -16, 1, -52)
PageBody.Position = UDim2.fromOffset(8, 46)
PageBody.BackgroundTransparency = 1
PageBody.BorderSizePixel = 0
PageBody.ScrollBarThickness = 3
PageBody.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 95)
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
    item.BackgroundColor3 = Color3.fromRGB(18, 22, 31)
    item.Text = text
    item.TextColor3 = Config.Text
    item.Font = Enum.Font.GothamSemibold
    item.TextSize = 13
    item.Parent = PageBody
    Corner(item, 8)
    Stroke(item, Color3.fromRGB(52, 59, 75), 1)

    item.Activated:Connect(callback)
    item.MouseEnter:Connect(function()
        Animate(item, {BackgroundColor3 = Color3.fromRGB(65, 23, 34)})
    end)
    item.MouseLeave:Connect(function()
        Animate(item, {BackgroundColor3 = Color3.fromRGB(18, 22, 31)})
    end)
    return item
end

local function Toggle(text, setting, callback)
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -8, 0, 38)
    item.BackgroundColor3 = Color3.fromRGB(18, 22, 31)
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

        Button("Tema plateado", function()
            Config.Accent = Color3.fromRGB(235, 45, 65)
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
            Config.Accent = Color3.fromRGB(235, 45, 65)
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
                    Silver = Color3.fromRGB(180, 180, 190),
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
    nav.Size = UDim2.new(1, -10, 0, 34)
    nav.BackgroundColor3 = Color3.fromRGB(18, 22, 31)
    nav.Text = page
    nav.TextColor3 = Config.Text
    nav.TextSize = 11
    nav.Font = Enum.Font.GothamSemibold
    nav.LayoutOrder = index
    nav.Parent = Sidebar
    Corner(nav, 8)
    Stroke(nav, Color3.fromRGB(43, 50, 64), 1)

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