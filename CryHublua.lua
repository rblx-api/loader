--// REDBULL LAGGER - PANEL AZUL CON LETRAS AMARILLAS
--// SIN ANIMACIONES DE ESTRELLAS NI SOMBRAS
--// Selector de tecla/botón personalizable (haz clic en el cuadro y pulsa la tecla deseada)

--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local ConfigFile = "RedbullLaggerConfig.json"

-- ⚙️ PODER EXACTO: 23 - 32 - 70
local NIVELES = {
    Low     = { poder = 23 },
    Mid     = { poder = 32 },
    High    = { poder = 70 }
}

-- 🔑 TECLA PREDETERMINADA: M (SIEMPRE M, IGNORA LA CONFIGURACIÓN GUARDADA)
local keybind = Enum.KeyCode.M
local listeningForInput = false
local laggerActive = false
local lagThread = nil
local nivelActual = "Low"
local ventanaBloqueada = false

-- 🎨 ESTILO AZUL CON LETRAS AMARILLAS
local UI_CONFIG = {
    MainBg       = Color3.fromRGB(0, 0, 0),
    TitleColor   = Color3.fromRGB(255, 255, 0),   -- Amarillo
    TextColor    = Color3.fromRGB(255, 255, 0),   -- Amarillo
    ButtonInact  = Color3.fromRGB(40, 40, 40),
    ButtonLow    = Color3.fromRGB(0, 255, 0),
    ButtonMid    = Color3.fromRGB(255, 255, 0),
    ButtonHigh   = Color3.fromRGB(255, 0, 0),
    ToggleOff    = Color3.fromRGB(45, 45, 45),
    ToggleOn     = Color3.fromRGB(45, 45, 45),
    LockColor    = Color3.fromRGB(255, 255, 0),   -- Amarillo